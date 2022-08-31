//
//  LyricsServices.swift
//  ShazamLyrecs
//
//  Created by Reinner Daza Leiva on 24/08/22.
//

import Foundation


protocol LyricsServicesProtocol{
  func requestItemsContentStack(item: ShazamModel, onCompletion: @escaping CompletionResponseHTTPS)
}


class LyricsServices: LyricsServicesProtocol {
  
  private var executeServices: ExecuteRequestServicesProtocol!

  required init(execute: ExecuteRequestServicesProtocol){
    self.executeServices = execute
  }
  
  public func requestItemsContentStack(item: ShazamModel, onCompletion: @escaping CompletionResponseHTTPS) {
    let request = MRequestServices(methodHTTP: .GET,
                                   baseURL: "https://api.lyrics.ovh",
                                   endPoint: "/v1/\(item.artist ?? "" )/\(item.title ?? "")",
                                   headers: [:],
                                   query: "")
    self.executeServices.executeRequest(dataRequest: request) { response in
      onCompletion(response)
    }
  }
}

