//
//  Authorize.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 5/2/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import UIKit
import Yaml
import OAuthSwift
import RealmSwift

final class Authorize {

  private var oauth: OAuth2Swift!

  static let shared = Authorize()
  private init() {  }
  
  func authorize(from: UIViewController) {
    let realm = try! Realm()
    let all = realm.objects(SpotifyAccess.self)
    let results = all.filter("expires > %@", Date())

    if let access = results.first {
      // Authorized. Configure API Client
      API.client.configureHeaders(spotify: access)
    } else {
      // Get Spotify Secrete Keys
      let secrets = Yaml(fileName: "secrets", fileType: "yml")
      let spotifyClientId = secrets["development"]["spotify_client_id"].string!
      let spotifyClientSecret = secrets["development"]["spotify_client_secret"].string!
      🐛("Spotify Client ID = \(spotifyClientId)")
      🐛("Spotify Client Secret = \(spotifyClientSecret)")

      // Configure OAuth 
      oauth = OAuth2Swift(consumerKey: spotifyClientId, consumerSecret: spotifyClientSecret, authorizeUrl: Spotify.authorize.URLString, accessTokenUrl: Spotify.token.URLString, responseType: "code")
      let handler = SafariURLHandler(viewController: from, oauthSwift: oauth)
      handler.presentCompletion = {
        print("Safari presented")
      }

      handler.dismissCompletion = {
        print("Safari dismissed")
      }
      oauth.authorizeURLHandler = handler
      let _ = oauth.authorize(withCallbackURL: "oauth-swift://oauth-callback/spotify",
                      scope: "user-library-modify user-top-read playlist-read-private user-read-birthdate",
                      state: generateState(withLength: 20),
                      success: { credential, response, parameters in
                        🐛("Credential: \(credential)")
                        🐛("Response: \(String(describing: response))")
                        🐛("Parameters: \(parameters)")

                        // Save to Realm
                        let spotifyAccess = SpotifyAccess(JSON: parameters)!
                        🐛(spotifyAccess.accessToken)
                        🐛(spotifyAccess.tokenType)
                        🐛(spotifyAccess.refreshToken)

                        try! realm.write {
                          realm.delete(all)
                          realm.add(spotifyAccess)
                          API.client.configureHeaders(spotify: spotifyAccess)
                        }
      },
                      failure: { error in
                        💩(error.description)
      })
    }
  }
}
