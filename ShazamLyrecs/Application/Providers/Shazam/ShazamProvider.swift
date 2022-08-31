//
//  ShazamProvider.swift
//  ShazamLyrecs
//
//  Created by Reinner Daza Leiva on 24/08/22.
//

import ShazamKit

protocol ShazamProviderProtocol{
  var session: SHSession! {get set}
  var signatureGenerator: SHSignatureGenerator! {get set}
  var delegate: ShazamProviderProtocolActions? {get set}
  func matchStreamingBuffer(buffer: AVAudioPCMBuffer)
}

protocol ShazamProviderProtocolActions{
  func responseMediaFetch(item: SHMatchedMediaItem)
  func responseWithError()
}

class ShazamProvider: NSObject, ShazamProviderProtocol{

  internal var session: SHSession!
  internal var signatureGenerator: SHSignatureGenerator!
  
  public var delegate: ShazamProviderProtocolActions?
  
  override init(){
    super.init()
    self.session = SHSession()
    self.signatureGenerator = SHSignatureGenerator()
    self.session.delegate = self
  }
  
  public func matchStreamingBuffer(buffer: AVAudioPCMBuffer) {
    self.session.matchStreamingBuffer(buffer, at: nil)
  }
}

extension ShazamProvider: SHSessionDelegate {
  func session(_ session: SHSession, didFind match: SHMatch) {
    let mediaItems = match.mediaItems
    if let item = mediaItems.first {
      self.delegate?.responseMediaFetch(item: item)
    }
  }
  
  func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
    self.delegate?.responseWithError()
  }
}
