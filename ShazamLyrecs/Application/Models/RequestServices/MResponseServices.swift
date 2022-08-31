//
//  MResponseServices.swift
//  SodexoUI
//
//  Created by Reinner Daza Leiva on 6/08/22.
//

import Foundation


struct MResponseServices{
  
  public var code: Int?
  public var data: Data?
  public var error: Error?
  public var status: Bool
  public var json: [String : Any]?
  
  
  public var description: String {
    return "\n******************** RESPONSE ********************\n Code: \(self.code ?? -1), Data: \(String(describing: self.data)), Error: \(String(describing: self.error)), Status: \(status), Json: \(String(describing: self.json))"
  }
  
  init(code: Int?, data: Data?, error: Error?, status: Bool) {
    self.code = code
    self.data = data
    self.error = error
    self.status = status
    if let jsonData = data {
      self.json =  try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
    }
  }
}
