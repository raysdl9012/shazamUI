//
//  LyricsController.swift
//  ShazamLyrecs
//
//  Created by Reinner Daza Leiva on 24/08/22.
//

import Foundation

protocol LyricsControllerProtocol{
  var services: LyricsServicesProtocol {set get}
  func fetchLyricsByArtist(item: ShazamModel)
}

//@MainActor
class LyricsController:NSObject, LyricsControllerProtocol, ObservableObject{
  
  @Published var lyricsModel = LyricsModel(lyrics: "", error: "")
  
  internal var services: LyricsServicesProtocol
  
  override init() {
    let excecute = ExecuteRequestServices()
    self.services =  LyricsServices(execute: excecute)
  }
  
  
  public func fetchLyricsByArtist(item: ShazamModel) {
    self.services.requestItemsContentStack(item: item) { response in
      print(response)
    }
  }
}
