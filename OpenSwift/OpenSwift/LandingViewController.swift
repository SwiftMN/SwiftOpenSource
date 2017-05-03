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
import RxSwift

final class LandingViewController: UIViewController {

  // ViewModel
  private let viewModel = LandingViewModel()

  private let disposableBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    bindings()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    Authorize.shared.authorize(from: self)
  }

  private func bindings() {
    viewModel.topArtists.asObservable()
      .subscribe(onNext: { artists in
        
      })
      .addDisposableTo(disposableBag)
  }
}
