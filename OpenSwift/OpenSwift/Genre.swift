//
//  Genre.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 5/4/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import RealmSwift

final class Genere: Object {
  dynamic var title = ""

  override static func indexedProperties() -> [String] {
    return ["title"]
  }

  override static func primaryKey() -> String? {
    return "title"
  }
}
