//
//  ArtistDetailViewController.swift
//  OpenSwift
//
//  Created by Adam Ahrens on 8/16/17.
//  Copyright © 2017 Adam Ahrens. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

final class ArtistDetailViewController: UIViewController {

  //IBOutlets
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var followersLabel: UILabel!
  @IBOutlet weak var popularityLabel: UILabel!
  
  // ViewModel
  private let viewModel = ArtistDetailViewModel(service: SpotifyService())
  private let disposableBag = DisposeBag()

  // Public Input
  var artist: Artist? {
    didSet {
      // Set NavigationBar title
      title = artist?.name

      // Set the ViewModel artist (watch the magic happen)
      viewModel.artist.value = artist
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    bindings()
  }

  private func bindings() {

    // drive is like subscribe, exception it's provided on the UI
    let image = viewModel.image
                         .asObservable()
                         .asDriver(onErrorJustReturn: nil)
    image.drive(imageView.rx.image).disposed(by: disposableBag)

    // Need to update labels
    let artist = viewModel.artist.asObservable().filterNil()

    artist.map { $0.followers }
          .filter { $0 > 0 }
          .map { "\($0) Followers" }
          .asDriver(onErrorJustReturn: "")
          .drive(followersLabel.rx.text)
          .disposed(by: disposableBag)

    artist.map { $0.popularity }
          .filter { $0 > 0 }
          .map { "\($0) Popularity" }
          .asDriver(onErrorJustReturn: "")
          .drive(popularityLabel.rx.text)
          .disposed(by: disposableBag)
  }
}
