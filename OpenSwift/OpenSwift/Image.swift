//
//  Image.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 4/11/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import RealmSwift

final class Image: Object {
  dynamic var height = 0
  dynamic var width = 0
  dynamic var URLString = ""
  dynamic var artist: Artist?
}
