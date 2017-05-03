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

  // ViewModel
  private let viewModel = LandingViewModel()

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    Authorize.shared.authorize(from: self)
  }
}
