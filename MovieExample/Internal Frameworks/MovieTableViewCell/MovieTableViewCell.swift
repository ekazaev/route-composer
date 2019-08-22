//
// Created by Eugene Kazaev on 25/08/2019.
// Copyright (c) 2019 Eugene Kazaev. All rights reserved.
//

import Foundation
import UIKit
import Models
import UpdatableTableViewController
import ImageClient
import MoviePoster

public class MovieTableViewCell: UITableViewCell, UpdatableTableViewCell {

    @IBOutlet private var posterImage: UIImageView!

    @IBOutlet private var title: UILabel!

    @IBOutlet private var releaseDate: UILabel!

    @IBOutlet private var shortDescription: UILabel!

    public static var reusableIdentifier: String = "MovieTableViewCell"

    private let imageManager = ImageManager()

    private var movie: Movie?

    public override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImage.image = nil
    }

    public func setup(with movie: Movie) {
        self.movie = movie
        title.text = movie.title
        releaseDate.text = movie.release_date
        shortDescription.text = movie.overview
        guard let posterPath = movie.poster_path else {
            return
        }
        let url = MoviePosterUrl.small.path(poster: posterPath)
        imageManager.fetchImage(for: url, completion: { [weak self] result in
            guard let self = self,
                  self.movie?.id == movie.id,
                  let image = try? result.get() else {
                return
            }
            self.posterImage.image = image
        })
    }

    public class func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: Bundle(for: MovieTableViewCell.self)), forCellReuseIdentifier: reusableIdentifier)
    }

}
