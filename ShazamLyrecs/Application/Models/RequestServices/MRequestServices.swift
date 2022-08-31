//
//  MRequestServices.swift
//  SodexoUI
//
//  Created by Reinner Daza Leiva on 6/08/22.
//

import Foundation


struct MRequestServices{
  public var methodHTTP: MethodsHttps
  public var baseURL: String
  public var endPoint: String
  public var headers: [String:String] = [:]
  public var query: String
  public var body: Any?
  public var requestURL: String {
    get {
    
      return (self.baseURL + self.endPoint + self.query).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
  }
  
  public var description: String {
    return "\n******************** REQUESET ********************\nMethodHTTP: \(self.methodHTTP), \nBaseURL: \(self.baseURL), \nEndPoing: \(self.endPoint), \nHeaders: \(String(describing: self.headers)), \nQuery: \(self.query), \nBody: \(String(describing: self.body)) \nFullURL: \(self.requestURL)\n******************** ********************"
  }

  public static var MOCK_REQUEST = MRequestServices(
    methodHTTP: .GET,
    baseURL: "https://my-json-server.typicode.com",
    endPoint: "/typicode/demo/posts",
    headers: [
      "Content-Type":"application/json"
    ],
    query: "?id=1", body: nil)
}
