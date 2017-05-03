//
//  API.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 5/2/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import RxSwift

final class API {

  // Custom Headers
  private var headers = [String : Any]()

  // Observable
  var authorized = Variable(false)

  // Singleton
  static let client = API()
  private init() {  }

  func configureHeaders(spotify: SpotifyAccess) {
    headers["Accept"] = "application/json"
    headers["Authorization"] = spotify.authorizationHeader

    authorized.value = true
  }
}
