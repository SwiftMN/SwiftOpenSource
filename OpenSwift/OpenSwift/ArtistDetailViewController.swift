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
import AVFoundation

final class ArtistDetailViewController: UIViewController {

  //IBOutlets
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var followersLabel: UILabel!
  @IBOutlet weak var popularityLabel: UILabel!
  @IBOutlet weak var playerViewContainer: UIView!
  @IBOutlet weak var trackNameLabel: UILabel!
  @IBOutlet weak var playTrack: UIButton!

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

  private var player = AVAudioPlayer()

  override func viewDidLoad() {
    super.viewDidLoad()

    configureUI()
    bindings()
  }

  private func configureUI() {
    let blurEffect = UIBlurEffect(style: .light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    playerViewContainer.insertSubview(blurEffectView, at: 0)
  }

  private func bindings() {
    // drive is like subscribe, except it's provided on the UI
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

    // React to getting a track to play
    let track = viewModel.sampleTrack.asObservable().share()
    let visibleDriver = track.map { $0 == nil }
         .asDriver(onErrorJustReturn: true)

    visibleDriver.drive(playerViewContainer.rx.isHidden)
                 .disposed(by: disposableBag)
    visibleDriver.drive(trackNameLabel.rx.isHidden)
      .disposed(by: disposableBag)
    visibleDriver.drive(playTrack.rx.isHidden)
      .disposed(by: disposableBag)

    track.filterNil()
         .map { $0.name }
         .asDriver(onErrorJustReturn: "")
         .drive(trackNameLabel.rx.text)
         .disposed(by: disposableBag)


    // React to play button pressed
    let play = playTrack.rx.tap.asObservable()

    // Need to combine with track
    let trackMp3Data = track.filterNil().map { $0.mp3Data }.filterNil()
    Observable.combineLatest(play, trackMp3Data) { tap, data  in
      return data
      }.observeOn(MainScheduler.instance)
       .subscribe(onNext: { [weak self] data in
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        guard self.player.isPlaying else { return }
        self.player = try! AVAudioPlayer(data: data)
        self.player.prepareToPlay()
        self.player.play()
      }).disposed(by: disposableBag)
  }
}
