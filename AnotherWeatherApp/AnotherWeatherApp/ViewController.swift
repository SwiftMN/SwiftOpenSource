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
    let searchInput = cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
      .asObservable()
      .map { [weak self] in
        //Map to input of the textField
        return self?.cityNameTextField.text ?? ""
      }.filter {
        $0.characters.count > 0
      }

    // Make the request via WeatherApi w/ flatMap
    let textSearch = searchInput.flatMap {
      return WeatherApi.shared.currentWeather(city: $0)
    }

    // Drive all UI elements with result
    let driver = textSearch.asDriver(onErrorJustReturn: Weather.empty)
    driver.map { $0.cityName }.drive(cityNameLabel.rx.text).disposed(by: disposableBag)
    driver.map { "\($0.humidity) %" }.drive(humidityLabel.rx.text).disposed(by: disposableBag)
    driver.map { $0.characterIcon() }.drive(weatherIconLabel.rx.text).disposed(by: disposableBag)
    driver.map { $0.weatherDescription }.drive(weatherDescriptionLabel.rx.text).disposed(by: disposableBag)
    driver.map { "\($0.temperature) °C" }.drive(temperatureLabel.rx.text).disposed(by: disposableBag)

    // UI looks odd with dummy data. Lets Hide stuff until a search is performed
    // Take textSearch, map, skip, drive
    let searching = textSearch.map { _ in false }.asObservable()
      .startWith(true)
      .asDriver(onErrorJustReturn: false)

    // UI Labels
    searching.drive(temperatureLabel.rx.isHidden).disposed(by: disposableBag)
    searching.drive(weatherIconLabel.rx.isHidden).disposed(by: disposableBag)
    searching.drive(weatherDescriptionLabel.rx.isHidden).disposed(by: disposableBag)
    searching.drive(humidityLabel.rx.isHidden).disposed(by: disposableBag)
    searching.drive(cityNameLabel.rx.isHidden).disposed(by: disposableBag)
  }
}

