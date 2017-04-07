//
//  AppDelegate.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 4/6/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import UIKit
import Yaml

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {


    do {
      if let file = Bundle.main.path(forResource: "secrets", ofType: "yml") {
        let fileContents = try String(contentsOfFile: file)
        let secrets = try Yaml.load(fileContents)
        let spotifyClientId = secrets["development"]["spotify_client_id"].string!
        let spotifyClientSecret = secrets["development"]["spotify_client_secret"].string!
        🐛("Spotify Client ID = \(spotifyClientId)")
        🐛("Spotify Client Secret = \(spotifyClientSecret)")
      }
    } catch let error {
      💩(error.localizedDescription)
    }

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {

  }

  func applicationDidEnterBackground(_ application: UIApplication) {

  }

  func applicationWillEnterForeground(_ application: UIApplication) {

  }

  func applicationDidBecomeActive(_ application: UIApplication) {

  }

  func applicationWillTerminate(_ application: UIApplication) {

  }
}
