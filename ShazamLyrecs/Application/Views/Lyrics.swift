//
//  Lyrics.swift
//  ShazamLyrecs
//
//  Created by Reinner Daza Leiva on 24/08/22.
//

import SwiftUI

struct Lyrics: View {
  
  public var shazamModel: ShazamModel
  
  @StateObject var lyricsControl = LyricsController()
  
  var body: some View {
    
    ScrollView(showsIndicators: true) {
      HStack(alignment:.center, spacing: 15){
        AsyncImage(url: self.shazamModel.album) { image in
          image
            .resizable()
            .scaledToFit()
        } placeholder: {
          ProgressView()
        }
        .frame(width: 100, height: 100)
        
        VStack(alignment: .leading, spacing: 10) {
          Text(self.shazamModel.artist ?? "")
            .font(.title2)
          Text(self.shazamModel.title ?? "")
            .font(.title3)
        }
        Spacer()
      }
    }.task {
      self.lyricsControl.fetchLyricsByArtist(item: self.shazamModel)
    }
    
    

  }
}

struct Lyrics_Previews: PreviewProvider {
  static var previews: some View {
    Lyrics(shazamModel: ShazamModel(title: "one", artist: "Metallica", album: URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b7/Metallica_logo.png")))
  }
}
