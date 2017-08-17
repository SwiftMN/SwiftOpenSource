//
//  SpotifyService.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 5/2/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import SwiftyDrop

enum Spotify {
  case authorize
  case token
  case topArtists
  case artistTopTracks(String)

  var URLString: String {
    switch self {
    case .authorize :
      return "https://accounts.spotify.com/en/authorize"
    case .token :
      return "https://accounts.spotify.com/api/token"
    case .topArtists :
      return "https://api.spotify.com/v1/me/top/artists"
    case .artistTopTracks(let id) :
      return "https://api.spotify.com/v1/artists/\(id)/top-tracks"
    }
  }

  var URLSpotify: URL {
    switch self {
    case .authorize :
      return URL(string: "https://accounts.spotify.com/en/authorize")!
    case .token :
      return URL(string: "https://accounts.spotify.com/api/token")!
    case .topArtists :
      return URL(string: "https://api.spotify.com/v1/me/top/artists")!
    case .artistTopTracks(let id) :
      return URL(string: "https://api.spotify.com/v1/artists/\(id)/top-tracks")!
    }
  }
}

final class SpotifyService {

  private let disposableBag = DisposeBag()

  func fetchTopArtists() -> Observable<JSON> {
    return API.client.get(path: Spotify.topArtists.URLString)
  }

  func fetchArtistImage(url: String) -> Observable<UIImage> {
    return API.client.download(path: url)
  }
}
