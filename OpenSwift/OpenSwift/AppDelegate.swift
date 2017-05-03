//
//  AppDelegate.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 4/6/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    return true
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    if (url.host == "oauth-callback") {
      OAuthSwift.handle(url: url)
    }

    return true
  }
}
