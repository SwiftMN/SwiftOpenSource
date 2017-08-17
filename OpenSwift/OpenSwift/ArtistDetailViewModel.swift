//
//  ArtistDetailViewModel.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 8/16/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import RxSwift

final class ArtistDetailViewModel {
  // Private
  private let service: SpotifyService
  private let disposableBag = DisposeBag()

  // Input
  var artist = Variable<Artist?>(nil)
  
  // Outputs
  private(set) var image = Variable<UIImage?>(nil)
  private(set) var sampleTrack = Variable<Track?>(nil)

  // Dependency Injection
  init(service: SpotifyService) {
    self.service = service

    bindings()
  }

  private func bindings() {
    artist.asObservable()
    .filterNil()
    .flatMap {
      return self.service.fetchArtistImage(url: $0.imageString)
    }.subscribe(onNext: { [weak self] data in
      self?.image.value = data
    }).disposed(by: disposableBag)

    artist.asObservable()
      .filterNil().flatMap {
        return self.service.fetchTopTracks(artistID: $0.spotifyId)
      }.map { json -> Track? in
        let tracks = json["tracks"].arrayValue
        for tracksJSON in tracks {
          if let jsonDictionary = tracksJSON.dictionaryObject, let track = Track(JSON: jsonDictionary) {
            return track
          }
        }

        return nil
      }.filterNil()
       .flatMap {
        return self.service.fetchMp3Preview(track: $0)
      }.subscribe(onNext: { track in
        self.sampleTrack.value = track
      }).disposed(by: disposableBag)
  }
}
