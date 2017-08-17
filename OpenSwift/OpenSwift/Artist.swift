//
//  Artist.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 4/11/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import RealmSwift
import ObjectMapper

final class Artist: Object, Mappable {
  dynamic var name = ""
  dynamic var spotifyId = ""
  dynamic var popularity = 0
  dynamic var followers = 0

  required convenience init?(map: Map) {
    self.init()
  }

  func mapping(map: Map) {
    name             <- map["name"]
    popularity       <- map["popularity"]
    followers        <- map["followers"]["total"]
    spotifyId        <- map["id"]
  }
}
