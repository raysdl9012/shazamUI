//
//  Logs.swift
//  SodexoUI
//
//  Created by Reinner Daza Leiva on 6/08/22.
//

import Foundation


class Logs {
  public static func logs(operation:String, message: String, isError: Bool = false){
    print("\( isError ? "🧨" : "" ) [\(Date())] Operation: \(operation), Message: \(message)")
  }
}
