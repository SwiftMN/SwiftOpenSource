//
//  WeatherApi.swift
//  AnotherWeatherApp
//
//  Created by Adam Ahrens on 8/17/17.
//  Copyright © 2017 SwiftMN. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftyJSON

final class WeatherApi {

  // Singleton
  static let shared = WeatherApi()

  // Weather API
  private let baseURL = URL(string: "http://api.openweathermap.org/data/2.5")!
  private let apiKey = "2dfe601965eb2094a3a1e06184ab083a"

  // Public
  func currentWeather(city: String) -> Observable<Weather> {
    return weatherRequest(pathComponent: "weather", params: [("q", city)]).map() { json in

      //SwiftyJSON to pull out data
      let name = json["name"].string ?? "Unknown"
      let temp = json["main"]["temp"].int ?? -1000
      let humid = json["main"]["humidity"].int  ?? 0
      let iconCharacter = json["weather"][0]["icon"].string ?? ""
      let description = json["weather"][0]["description"].string ?? ""

      // Return our Model
      return Weather(cityName: name,
                     temperature: temp,
                     humidity: humid,
                     weatherDescription: description,
                     icon: iconCharacter)
    }
  }

  // Private
  private func weatherRequest(method: String = "GET", pathComponent: String, params: [(String, String)]) -> Observable<JSON> {

    let url = baseURL.appendingPathComponent(pathComponent)
    var request = URLRequest(url: url)
    let keyQueryItem = URLQueryItem(name: "appid", value: apiKey)
    let unitsQueryItem = URLQueryItem(name: "units", value: "metric")
    let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!

    if method == "GET" {
      var queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
      queryItems.append(keyQueryItem)
      queryItems.append(unitsQueryItem)
      urlComponents.queryItems = queryItems
    } else {
      urlComponents.queryItems = [keyQueryItem, unitsQueryItem]

      let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
      request.httpBody = jsonData
    }

    request.url = urlComponents.url!
    request.httpMethod = method
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    return URLSession.shared.rx.data(request: request).map { JSON(data: $0) }
  }
}
