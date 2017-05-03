//
//  Extensions.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 5/2/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import Yaml

extension Yaml {
  init(fileName: String, fileType: String) {
    let file = Bundle.main.path(forResource: fileName, ofType: fileType)!
    let fileContents = try! String(contentsOfFile: file)
    self = try! Yaml.load(fileContents)
  }
}
