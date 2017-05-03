//
//  Artist.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 4/11/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import RealmSwift

final class Artist: Object {
  dynamic var name = ""
  dynamic var spotifyId = ""
  dynamic var popularity = 0
  dynamic var followers = 0
}
