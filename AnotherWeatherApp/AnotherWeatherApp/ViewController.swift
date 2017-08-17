//
//  ViewController.swift
//  AnotherWeatherApp
//
//  Created by Adam Ahrens on 8/17/17.
//  Copyright © 2017 SwiftMN. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
  //MARK: IBOutlets
  @IBOutlet weak var cityNameTextField: UITextField!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var weatherIconLabel: UILabel!
  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var weatherDescriptionLabel: UILabel!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var temperatureSegmentedControl: UISegmentedControl!
}

