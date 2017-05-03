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

  init() {
    API.client.authorized.asObservable().filter { $0 == true }.subscribe(onNext: { _ in
      print("")
    }).addDisposableTo(disposableBag)
  }
}
