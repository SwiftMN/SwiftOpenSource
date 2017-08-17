//
//  LandingViewModel.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 5/2/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import RxSwift

final class LandingViewModel {
  private let disposableBag = DisposeBag()
  private let service: SpotifyService

  // Output
  private(set) var topArtists = Variable<[Artist]>([])

  init(service: SpotifyService) {
    self.service = service

    bindings()
  }

  private func bindings() {
    let authorized = API.client
      .authorized
      .asObservable()
      .filter { $0 == true }

    let artists = authorized.flatMap { _ in
      return self.service.fetchTopArtists()
    }

    artists.subscribe(onNext: { json in
      let artists = json["items"].arrayValue
      var tempArtists = [Artist]()
      for artistJSON in artists {
        if let jsonDictionary = artistJSON.dictionaryObject, let parsedArtist = Artist(JSON: jsonDictionary) {
          tempArtists.append(parsedArtist)
        }
      }

      if tempArtists.count > 0 {
        self.topArtists.value = tempArtists
      }
    }).addDisposableTo(disposableBag)
  }
}
