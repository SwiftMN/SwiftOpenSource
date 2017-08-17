//
//  Weather.swift
//  AnotherWeatherApp
//
//  Created by Adam Ahrens on 8/17/17.
//  Copyright © 2017 SwiftMN. All rights reserved.
//

import Foundation

struct Weather {
  let cityName: String
  let temperature: Int
  let humidity: Int
  let weatherDescription: String
  let icon: String

  static let empty = Weather(
    cityName: "Unknown",
    temperature: -1000,
    humidity: 0,
    weatherDescription: "unknown",
    icon: "e"
  )

  func characterIcon() -> String {
    return iconNameToChar(icon: icon)
  }

  private func iconNameToChar(icon: String) -> String {
    switch icon {
    case "01d":
      return "\u{f11b}"
    case "01n":
      return "\u{f110}"
    case "02d":
      return "\u{f112}"
    case "02n":
      return "\u{f104}"
    case "03d", "03n":
      return "\u{f111}"
    case "04d", "04n":
      return "\u{f111}"
    case "09d", "09n":
      return "\u{f116}"
    case "10d", "10n":
      return "\u{f113}"
    case "11d", "11n":
      return "\u{f10d}"
    case "13d", "13n":
      return "\u{f119}"
    case "50d", "50n":
      return "\u{f10e}"
    default:
      return "E"
    }
  }
}
