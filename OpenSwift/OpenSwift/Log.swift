//
//  Log.swift
//
//  Created by Steven Vlaminck on 8/18/16.
//

import Foundation

enum LogLevel {
  case Custom(String)
  case Debug
  case Warn
  case Error

  var intValue: Int {
    switch self {
    case .Custom(_): return 0
    case .Debug: return 1
    case .Warn: return 2
    case .Error: return 3
    }
  }
}

extension LogLevel: Comparable {}

func ==(lhs: LogLevel, rhs: LogLevel) -> Bool {
  return lhs.intValue == rhs.intValue
}
func >(lhs: LogLevel, rhs: LogLevel) -> Bool  {
  return lhs.intValue > rhs.intValue
}
func <(lhs: LogLevel, rhs: LogLevel) -> Bool  {
  return lhs.intValue < rhs.intValue
}

var logLevel: LogLevel = .Debug

struct Log {
  static func custom(_ message: Any) {
    guard case .Custom(let level) = logLevel else { return }
    print("[\(level)] \(message)")
  }
  static func debug(_ message: Any) {
    guard logLevel <= LogLevel.Debug else { return }
    print("🐛 [DEBUG] \(message)")
  }
  static func warn(_ message: Any) {
    guard logLevel <= LogLevel.Warn else { return }
    print("💥 [WARN]  \(message)")
  }
  static func error(_ message: Any) {
    guard logLevel <= LogLevel.Error else { return }
    print("💩 [ERROR] \(message)")
  }
}

func 🐛(_ message: Any) {
  Log.debug(message)
}
func 💥(_ message: Any) {
  Log.warn(message)
}
func 💩(_ message: Any) {
  Log.error(message)
}
