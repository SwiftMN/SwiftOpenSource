//
//  API.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 5/2/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import RxSwift
import Alamofire
import SwiftyJSON

final class API {

  // Custom Headers
  private var headers = [String : String]()

  // Observable
  private(set) var authorized = Variable<Bool>(false)

  // Singleton
  static let client = API()
  private init() {  }

  func configureHeaders(spotify: SpotifyAccess) {
    headers["Accept"] = "application/json"
    headers["Authorization"] = spotify.authorizationHeader
    authorized.value = true
  }

  func get(path: String, parameters: [String: Any]? = nil, headers: [String : String]? = nil) -> Observable<JSON> {
    return Observable.create({ [weak self] observer in
      let mergedHeaders = self?.combinedHeaders(headers: headers)
      Alamofire.request(path, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: mergedHeaders).responseJSON { response in
        🐛("Request time (s): \(response.timeline.requestDuration)")

        if let jsonData = response.result.value {
          🐛("JSON: \(jsonData)")
          let json = JSON(jsonData)
          observer.onNext(json)
          observer.onCompleted()
        }

        if let error = response.error {
          💩("Error: \(error)")
          observer.onError(error)
        }
      }
      
      return Disposables.create()
    })
  }

  private func combinedHeaders(headers: [String : String]?) -> [String : String] {
    guard let headers = headers else { return self.headers }
    var mergedHeaders = self.headers
    headers.forEach { key, value in mergedHeaders[key] = value }
    return mergedHeaders
  }
}
