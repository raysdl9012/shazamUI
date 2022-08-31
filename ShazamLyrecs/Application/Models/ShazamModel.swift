//
//  MShazam.swift
//  ShazamLyrecs
//
//  Created by Reinner Daza Leiva on 24/08/22.
//

import Foundation


struct ShazamModel:Decodable {
  
  let title: String?
  let artist: String?
  var album: URL?
    
}
