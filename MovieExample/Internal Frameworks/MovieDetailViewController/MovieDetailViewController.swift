//
// Created by Eugene Kazaev on 2019-09-02.
// Copyright (c) 2019 Eugene Kazaev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Models
import APIClient
import MoviePoster
import ImageClient

public class MovieDetailViewController: UIViewController {

    @IBOutlet private var posterImageView: UIImageView!

    @IBOutlet private var titleLabel: UILabel!

    @IBOutlet private var descriptionLabel: UILabel!

    private let viewModel = MovieDetailViewModel()

    private let disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindModel()
    }

    private func bindModel() {
        viewModel.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.description.bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel.poster.bind(to: posterImageView.rx.image).disposed(by: disposeBag)
    }

}

public class MovieDetailViewModel {

    private let disposeBag = DisposeBag()

    var title: Observable<String?> {
        return titleVariable.asObservable()
    }

    var description: Observable<String?> {
        return descriptionVariable.asObservable()
    }

    var poster: Observable<UIImage?> {
        return posterVariable.asObservable()
    }

    private let titleVariable = BehaviorRelay<String?>(value: nil)

    private let descriptionVariable = BehaviorRelay<String?>(value: nil)

    private let posterVariable = BehaviorRelay<UIImage?>(value: nil)

    private let service = MovieDetailService()

    init() {
        service.details(for: 506574)
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] movie in
                    guard let self = self else {
                        return
                    }
                    self.titleVariable.accept(movie.title)
                    self.descriptionVariable.accept(movie.overview)
                    self.service.poster(for: movie)
                            .observeOn(MainScheduler.instance)
                            .subscribe(onSuccess: { [weak self] image in
                                self?.posterVariable.accept(image)
                            }).disposed(by: self.disposeBag)
                })
                .disposed(by: disposeBag)
    }

}

private class MovieDetailService {

    private let imageManager = ImageManager()

    func poster(for movie: Movie) -> Single<UIImage> {
        guard let posterPath = movie.poster_path else {
            return Single.error(NetworkingManager.APIError.noResponse)
        }
        return Single.create(subscribe: { observer -> Disposable in
            let url = MoviePosterUrl.medium.path(poster: posterPath)
            self.imageManager.fetchImage(for: url, completion: { result in
                switch result {
                case .success(let response):
                    observer(.success(response))
                case .failure(let error):
                    observer(.error(error))
                }
            })
            return Disposables.create()
        })

    }

    func details(for movieId: Int) -> Single<Movie> {
        return Single.create(subscribe: { observer -> Disposable in
            NetworkingManager.shared.GET(endpoint: .movieDetail(movieId: movieId),
                    params: [:],
                    completionHandler: { (result: Result<Movie, NetworkingManager.APIError>) in
                        switch result {
                        case .success(let response):
                            observer(.success(response))
                        case .failure(let error):
                            observer(.error(error))
                        }
                    })

            return Disposables.create()
        })
    }

}
