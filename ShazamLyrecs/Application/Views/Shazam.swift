//
//  Shazam.swift
//  ShazamLyrecs
//
//  Created by Reinner Daza Leiva on 24/08/22.
//

import SwiftUI

struct Shazam: View {
  
  @StateObject private var shazamController =  ShazamController()
  
  var body: some View {
    
    NavigationView{
            
      VStack(spacing: 20){
        
        
        Text(self.shazamController.isRecordigAudio ?
             "Escuchando" :
              "Escuchar")
        .font(Font.title)
        
        Image(systemName: (self.shazamController.isRecordigAudio ?
                           "waveform.and.mic" :
                            "mic.slash.circle.fill"))
        .resizable()
        .frame(width: 100, height: 100)
        .foregroundColor(.accentColor)
        .onTapGesture {
          self.shazamController.startRegconizerMusic()
        }
        
        Spacer()
        
        if self.shazamController.isMessageError {
          Text("No se pudo procesar la cancion")
            .font(.largeTitle)
            .foregroundColor(.yellow)
            .multilineTextAlignment(.center)
          Spacer()
        }
        
        if self.shazamController.isRecordigAudio {
          ProgressView()
          Spacer()
          
        }else{
          if (self.shazamController.shazamModel.album != nil) {
            
            VStack(alignment: .leading, spacing: 20) {
              Text(self.shazamController.shazamModel.artist ?? "")
                .font(.title2)
              Text(self.shazamController.shazamModel.title ?? "")
                .font(.title3)
              
              NavigationLink {
                Lyrics(shazamModel: self.shazamController.shazamModel)
              } label: {
                Text("Ver Lyrics")
                  .font(.title3)
                  
              }

              AsyncImage(url: self.shazamController.shazamModel.album) { image in
                image
                  .resizable()
                  .scaledToFill()
              } placeholder: {
                ProgressView()
              }.onTapGesture {
                
              }
            }
            .padding()
            Spacer()
          }
        }
      }
    }
  }
}

struct Shazam_Previews: PreviewProvider {
  static var previews: some View {
    Shazam()
  }
}
