//
//  Spotify.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 4/6/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import Foundation

enum Spotify {
  case authorize
  case token
  case topArtists
  case topTracks
  case playlists
  case artistTopTracks(String)

  var URLString: String {
    switch self {
      case .authorize :
        return "https://accounts.spotify.com/en/authorize"
      case .token :
        return "https://accounts.spotify.com/api/token"
      case .topArtists :
        return "https://api.spotify.com/v1/me/top/artists"
      case .topTracks :
        return "https://api.spotify.com/v1/me/top/tracks"
      case .playlists :
        return "https://api.spotify.com/v1/me/playlists"
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
    case .topTracks :
      return URL(string: "https://api.spotify.com/v1/me/top/tracks")!
    case .playlists :
      return URL(string: "https://api.spotify.com/v1/me/playlists")!
    case .artistTopTracks(let id) :
      return URL(string: "https://api.spotify.com/v1/artists/\(id)/top-tracks")!
    }
  }
}
