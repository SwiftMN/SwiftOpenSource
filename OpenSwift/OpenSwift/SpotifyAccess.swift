//
//  SpotifyAccess.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 4/10/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class SpotifyAccess: Object, Mappable {

  dynamic var expires: Date!
  dynamic var refreshToken: String!
  dynamic var tokenType: String!
  dynamic var accessToken: String!

  var authorizationHeader: String {
    return "\(tokenType!) \(accessToken!)"
  }

  required convenience init?(map: Map) {
    self.init()
  }

  func mapping(map: Map) {
    let transform = transformer()
    expires         <- (map["expires_in"], transform)
    refreshToken    <- map["refresh_token"]
    tokenType       <- map["token_type"]
    accessToken     <- map["access_token"]
  }

  private func transformer() -> TransformOf<Date, Double> {
    let transform = TransformOf<Date, Double>(fromJSON: { value -> Date? in
      guard let seconds = value, let total = Int(exactly: seconds) else { return nil }
      return Calendar.current.date(byAdding: .second, value: total, to: Date())
    }) { date -> Double? in
      guard let date = date else { return nil }
      return abs(date.timeIntervalSinceNow)
    }

    return transform
  }
}
