//
//  RequestServices.swift
//  SodexoUI
//
//  Created by Reinner Daza Leiva on 6/08/22.
//

import Foundation


typealias CompletionResponseHTTPS = (_ response: MResponseServices ) -> Void

protocol ExecuteRequestServicesProtocol {
  func executeRequest( dataRequest: MRequestServices, onCompletion: @escaping CompletionResponseHTTPS)
}

class ExecuteRequestServices: NSObject, ExecuteRequestServicesProtocol{
  
  private var sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
  private var sessionRequest: URLSession!
  
  override init(){
    super.init()
    self.configurationSessionRequest()
  }
  
  private func configurationSessionRequest(){
    self.sessionConfiguration.timeoutIntervalForRequest = 60
    self.sessionConfiguration.timeoutIntervalForResource = 60
    self.sessionRequest = URLSession(configuration: self.sessionConfiguration, delegate: self, delegateQueue: nil)
  }
  
  public func executeRequest( dataRequest: MRequestServices, onCompletion: @escaping CompletionResponseHTTPS) {
    Logs.logs(
      operation: String(describing: ExecuteRequestServices.self) ,
      message: "executeRequest \(dataRequest.description)",
      isError: false)
    
    guard let url =  URL(string: dataRequest.requestURL) else {
      onCompletion(MResponseServices(code: 0, data: nil, error: nil, status: false))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = dataRequest.methodHTTP.rawValue
    
    for (key, value) in dataRequest.headers {
      request.addValue(value, forHTTPHeaderField: key)
    }
    
    if dataRequest.body != nil {
      if let httpBody = try? JSONSerialization.data(withJSONObject: dataRequest.body!, options: []) {
        request.httpBody = httpBody
      }
    }
    
    let task = self.sessionRequest.dataTask(with: request) { data, response, error in
      
      guard let data = data, error == nil, let response = response as? HTTPURLResponse else {
        
        Logs.logs(
          operation: String(describing: ExecuteRequestServices.self) ,
          message: "response \(error!.localizedDescription)",
          isError: true)
        
        onCompletion(MResponseServices(code: 0, data: nil, error: error, status: false))
        return
      }
    
      let dataResponse =  MResponseServices(
        code: response.statusCode,
        data: data,
        error: nil,
        status: true)
      
      Logs.logs(operation: String(describing: ExecuteRequestServices.self), message: "Response: \(dataResponse)")
      
      onCompletion(dataResponse)
    }
    
    task.resume()
  }
}

extension ExecuteRequestServices: URLSessionDelegate {
  func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    completionHandler(.useCredential, challenge.proposedCredential)
  }
}
