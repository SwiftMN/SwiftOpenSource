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
import RxCocoa

final class LandingViewController: UIViewController {

  //IBOutlets
  @IBOutlet weak var tableView: UITableView!
  
  // ViewModel
  private let viewModel = LandingViewModel(service: SpotifyService())
  private let disposableBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    bindings()

    // OAuth with Spotify
    Authorize.shared.authorize(from: self)
  }

  private func bindings() {
    // Why would we share?
    let artists = viewModel.topArtists.asObservable().share()

    // Bind Artists to UITableView
    artists
      .bind(to: tableView.rx.items) { (tableView, row, element) in
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell") as! ArtistTableViewCell
        cell.artistNameLabel.text = element.name
        return cell
      }
      .disposed(by: disposableBag)

    // How to combine different Observable types
    let indexPathObservable = tableView.rx.itemSelected.asObservable()
    Observable.combineLatest(indexPathObservable, artists) { indexPath, artists in
        return artists[indexPath.row]
      }.subscribe(onNext: { [weak self] artist in
        if let vc = self?.storyboard?.instantiateViewController(ofType: ArtistDetailViewController.self) {
          vc.artist = artist
          self?.navigationController?.pushViewController(vc, animated: true)
        }
      }).disposed(by: disposableBag)

    // Reuse Observables to perform other tasks. Such as logging.
    artists.subscribe(onNext: { artists in
      artists.forEach { artist in
        print("Top artist of \(artist.name)")
      }
    }).disposed(by: disposableBag)
  }
}
