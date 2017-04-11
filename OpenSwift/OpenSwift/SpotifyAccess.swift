//
//  SpotifyAccess.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 4/10/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import ObjectMapper

struct SpotifyAccess: Mappable {

  var expires: Double!
  var refreshToken: String!
  var scopes: [String]!
  var tokenType: String!
  var accessToken: String!

  var authorizationHeader: String {
    return "\(tokenType!) \(accessToken!)"
  }

  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    expires         <- map["expires_in"]
    refreshToken    <- map["refresh_token"]
    tokenType       <- map["token_type"]
    accessToken     <- map["access_token"]

    // Transform a single spaced list of strings into a [String]
    // and reverse back
    let transformer = TransformOf<[String],String>(fromJSON: { string in
      guard let scope = string else { return nil }
      return scope.components(separatedBy: " ")
    }) { array in
      guard let scopes = array else { return nil }
      let scope = scopes.reduce("") { previous, next in
        if previous.characters.count == 0 {
          return next
        }

        return previous + " \(next)"
      }

      return scope
    }

    scopes           <- (map["scope"], transformer)
  }
}
