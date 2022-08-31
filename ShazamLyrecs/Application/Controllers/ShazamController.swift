//
//  ShazamController.swift
//  ShazamLyrecs
//
//  Created by Reinner Daza Leiva on 24/08/22.
//

import ShazamKit
import SwiftUI
import AVKit

protocol ShazamControllerProtocol{
  
  
  var audioProvider: AudioRecordProviderProtocol! {get set}
  var shazamProvider: ShazamProviderProtocol! {get set}
  
  func showMessageError()
  func createSessionAudio()
  func stopRegconizerMusic()
  func startRegconizerMusic()
  func actionValidateItemHasImage(item: ShazamModel)
  func changeStatusRecording(isRecording: Bool)
}


class ShazamController: NSObject, ShazamControllerProtocol, ObservableObject{
  
  internal var audioProvider: AudioRecordProviderProtocol!
  internal var shazamProvider: ShazamProviderProtocol!
  
  @Published var shazamModel =  ShazamModel(title: "", artist: "", album: nil)
  @Published var isRecordigAudio = false
  @Published var isMessageError = false
  
  
  override init() {
    super.init()
    self.audioProvider = AudioRecordProvider()
    self.shazamProvider = ShazamProvider()
    self.shazamProvider.delegate = self
  }
  
  public func startRegconizerMusic() {
    guard !self.audioProvider.isAudioRecordingRunning() else{
      self.audioProvider.stopAudioRecording()
      self.changeStatusRecording(isRecording: false)
      return
    }
    self.createSessionAudio()
  }
  
  public func createSessionAudio() {
    self.audioProvider.requestPermissionAudioDevice { [weak self] status in
      guard status else { return }
      self?.audioProvider.starAudioRecording { [weak self]  buffer, status in
        self?.changeStatusRecording(isRecording: status)
        guard status, let buffer = buffer else {
          Logs.logs(operation: "\(ShazamControllerProtocol.self)", message: "Error build a buffer" , isError: true)
          return
        }
        self?.shazamProvider.matchStreamingBuffer(buffer: buffer)
      }
    }
  }
  
  public func stopRegconizerMusic() {
    if self.audioProvider.isAudioRecordingRunning() {
      self.audioProvider.stopAudioRecording()
      self.changeStatusRecording(isRecording: false)
    }
  }
  
  public func changeStatusRecording(isRecording: Bool) {
    DispatchQueue.main.async {
      self.isRecordigAudio = isRecording
    }
  }
  
  public func actionValidateItemHasImage(item: ShazamModel) {
    guard let _ = self.shazamModel.album?.isFileURL else{
      return
    }
    self.stopRegconizerMusic()
  }
  
  public func showMessageError(){
    
    DispatchQueue.main.async {
      self.isMessageError.toggle()
      Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { status in
        self.isMessageError.toggle()
      }
    }
  }
}

extension ShazamController: ShazamProviderProtocolActions {
  public func responseMediaFetch(item: SHMatchedMediaItem) {
    DispatchQueue.main.async {
      self.shazamModel = ShazamModel(
        title: item.title,
        artist: item.artist,
        album: item.artworkURL)
      self.actionValidateItemHasImage(item: self.shazamModel)
    }
  }
  
  public func responseWithError() {
    self.stopRegconizerMusic()
    self.showMessageError()
  }
}


