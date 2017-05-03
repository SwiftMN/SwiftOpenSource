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
  private let service = SpotifyService()

  // Observable
  private(set) var topArtists = Variable<[Artist]>([])

  init() {
    API.client.authorized.asObservable()
      .filter { $0 == true }
      .subscribe(onNext: { [weak self] _ in
        // API has been authorized. Can request stuff
        self?.service.fetchTopArtists()
    }).addDisposableTo(disposableBag)
  }
}
