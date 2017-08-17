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
    let image = viewModel.image
                         .asObservable()
                         .asDriver(onErrorJustReturn: nil)
    image.drive(imageView.rx.image).disposed(by: disposableBag)
  }
}
