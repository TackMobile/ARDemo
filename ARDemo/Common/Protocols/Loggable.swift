//
//  Loggable.swift
//  ARDemo
//
//  Created by Kelvin Kosbab on 12/26/17.
//  Copyright © 2017 Tack Mobile. All rights reserved.
//

import Foundation

struct Log : Loggable {
  private init() {}
}

protocol Loggable {}
extension Loggable {
  
  // MARK: - Static
  
  static func log(_ message: String, file: String = #file, line: Int = #line, function: String = #function) {
    print("\(self.stackCallerClassAndMethodString(file: file, line: line, function: function)) - \(message)")
  }
  
  static func extendedLog(_ message: String, file: String = #file, line: Int = #line, function: String = #function) {
    print("\n<<< ✅✅✅ \(self.stackCallerClassAndMethodString(file: file, line: line, function: function)) : \(message) ✅✅✅ >>>\n")
  }
  
  static func logMethodExecution(file: String = #file, line: Int = #line, function: String = #function) {
    print("\n<<< ✅✅✅ \(self.stackCallerClassAndMethodString(file: file, line: line, function: function)) ✅✅✅ >>>\n")
  }
  
  static func logMethodExecution(emoji: String, file: String = #file, line: Int = #line, function: String = #function) {
    print("\n<<< \(emoji) \(self.stackCallerClassAndMethodString(file: file, line: line, function: function)) \(emoji) >>>\n")
  }
  
  static func logFullStackData() {
    let sourceString = Thread.callStackSymbols[1]
    let separatorSet = CharacterSet.init(charactersIn: " -[]+?.,")
    let array = sourceString.components(separatedBy: separatorSet)
    
    print("****** Stack: \(array[0])")
    print("****** Framework: \(array[1])")
    print("****** Memory address: \(array[2])")
    print("****** Class caller: \(array[3])")
    print("****** Function caller: \(array[4])")
    print("****** Line caller: \(array[5])")
  }
  
  private static func stackCallerClassAndMethodString(file: String, line: Int, function: String) -> String {
    let lastPathComponent = (file as NSString).lastPathComponent
    return "\(lastPathComponent):\(line) : \(function)"
  }
}
