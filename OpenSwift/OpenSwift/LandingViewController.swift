//
//  LandingViewController.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 4/10/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import UIKit
import Yaml
import OAuthSwift
import Alamofire

final class LandingViewController: UIViewController {

  final var oauth: OAuth2Swift!

    override func viewDidLoad() {
        super.viewDidLoad()

      do {
        if let file = Bundle.main.path(forResource: "secrets", ofType: "yml") {
          let fileContents = try String(contentsOfFile: file)
          let secrets = try Yaml.load(fileContents)
          let spotifyClientId = secrets["development"]["spotify_client_id"].string!
          let spotifyClientSecret = secrets["development"]["spotify_client_secret"].string!
          🐛("Spotify Client ID = \(spotifyClientId)")
          🐛("Spotify Client Secret = \(spotifyClientSecret)")

          oauth = OAuth2Swift(consumerKey: spotifyClientId, consumerSecret: spotifyClientSecret, authorizeUrl: Spotify.AuthorizeURL, accessTokenUrl: Spotify.TokenURL, responseType: "code")
          let state = generateState(withLength: 20)
          let _ = oauth.authorize(
            withCallbackURL: URL(string: "oauth-swift://oauth-callback/spotify")!,
            scope: "user-library-modify user-top-read playlist-read-private user-read-birthdate",
            state: state,
              success: { credential, response, parameters in
                🐛(parameters)
                let spotifyAccess = SpotifyAccess(JSON: parameters)!
                🐛(spotifyAccess.accessToken)
                🐛(spotifyAccess.tokenType)
                🐛(spotifyAccess.refreshToken)

                let headers = [ "Authorization": spotifyAccess.authorizationHeader, "Accept" : "application/json"]

                Alamofire.request(Spotify.TopTracksURL, headers: headers).responseJSON { response in
                  debugPrint(response)
                  if let json = response.result.value {
                    🐛(json)
                  }
                }
            },
              failure: { error in
                💩(error.description)
            }
          )
        }
      } catch let error {
        💩(error.localizedDescription)
      }
    }
}
