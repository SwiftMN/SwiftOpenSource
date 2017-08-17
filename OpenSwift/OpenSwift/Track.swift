//
//  Track.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 8/16/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import RealmSwift
import ObjectMapper

final class Track: Object, Mappable {
  dynamic var name = ""
  dynamic var previewString = ""
  dynamic var mp3Data: Data? = nil

  required convenience init?(map: Map) {
    self.init()
  }

  func mapping(map: Map) {
    name             <- map["name"]
    previewString    <- map["preview_url"]
  }
}
