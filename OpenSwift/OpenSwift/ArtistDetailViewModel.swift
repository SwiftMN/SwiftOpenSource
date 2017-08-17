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

  // Dependency Injection
  init(service: SpotifyService) {
    self.service = service

    bindings()
  }

  private func bindings() {
    let validArtist = artist.asObservable().filterNil()

    validArtist.flatMap {
      return self.service.fetchArtistImage(url: $0.imageString)
    }.subscribe(onNext: { [weak self] data in
      self?.image.value = data
    }).disposed(by: disposableBag)
  }
}
