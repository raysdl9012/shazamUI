//
//  AudioRecordProvider.swift
//  ShazamLyrecs
//
//  Created by Reinner Daza Leiva on 24/08/22.
//

import AVKit

protocol AudioRecordProviderProtocol{
  var audioSession: AVAudioSession {get set}
  var audioEngine: AVAudioEngine {get set}
  
  func stopAudioRecording()
  func isAudioRecordingRunning() -> Bool
  func requestPermissionAudioDevice(onCompletion: @escaping  (_ status:Bool)->Void)
  func starAudioRecording(onCompletion:  @escaping (_ buffer: AVAudioPCMBuffer?, _ status: Bool) -> Void)
}

class AudioRecordProvider: AudioRecordProviderProtocol{
  
  internal var audioSession: AVAudioSession
  internal var audioEngine: AVAudioEngine
  
  init(){
    self.audioSession = AVAudioSession.sharedInstance()
    self.audioEngine = AVAudioEngine()
  }
  
  public func requestPermissionAudioDevice(onCompletion: @escaping (_ status:Bool)->Void){
    self.audioSession.requestRecordPermission { status in
      Logs.logs(operation: "\(AudioRecordProvider.self)", message: "Request permission Audio is \(status)")
      onCompletion(status)
    }
  }
  
  public func starAudioRecording(onCompletion:  @escaping (_ buffer: AVAudioPCMBuffer?, _ status: Bool) -> Void) {
    Logs.logs(operation: "\(AudioRecordProvider.self)", message: "Config Audio Recording")
    try? self.audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    let inputNode = self.audioEngine.inputNode
    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.removeTap(onBus: .zero)
    inputNode.installTap(onBus: .zero, bufferSize: 1024, format: recordingFormat) { buffer, audio in
      onCompletion(buffer, true)
    }
    self.audioEngine.prepare()
    do{
      Logs.logs(operation: "\(AudioRecordProvider.self)", message: "Start Audio Recording")
      try self.audioEngine.start()
    }catch let error as NSError {
      onCompletion(nil, false)
      Logs.logs(operation: "\(AudioRecordProvider.self)", message: "Error scand audio \(error.localizedDescription)", isError: true)
    }
  }
  
  public func stopAudioRecording() {
    Logs.logs(operation: "\(AudioRecordProvider.self)", message: "Stop Audio Recording")
    self.audioEngine.stop()
  }
  
  public func isAudioRecordingRunning() -> Bool {
    Logs.logs(operation: "\(AudioRecordProvider.self)", message: "Audio Recording running is: \(self.audioEngine.isRunning) ")
    return self.audioEngine.isRunning
  }
  
}
