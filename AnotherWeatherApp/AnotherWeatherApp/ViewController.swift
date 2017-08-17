//
//  ViewController.swift
//  AnotherWeatherApp
//
//  Created by Adam Ahrens on 8/17/17.
//  Copyright © 2017 SwiftMN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
  //MARK: IBOutlets
  @IBOutlet weak var cityNameTextField: UITextField!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var weatherIconLabel: UILabel!
  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var weatherDescriptionLabel: UILabel!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

  //MARK: RX
  private let disposableBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    bindings()
  }

  private func bindings() {
    // Lets perform a search
    // Control Event
    // Map
    // Filter valid text


    // Make the request via WeatherApi w/ flatMap

    // Drive all UI elements with result
    // Why Use drive? Main Thread

    // UI looks odd with dummy data. Lets Hide stuff until a search is performed
    // Take textSearch, map to false, startWith true, asDriver

    // UI Labels drive isHidden property
  }
}

