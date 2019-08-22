//
// Created by Eugene Kazaev on 2019-09-01.
// Copyright (c) 2019 Eugene Kazaev. All rights reserved.
//

import Foundation

public enum MoviePosterUrl {

    case small

    case medium

    case cast

    case original

    public func path(poster: String) -> URL {
        var urlString: String
        switch self {
        case .small:
            urlString = "https://image.tmdb.org/t/p/w154/"
        case .medium:
            urlString = "https://image.tmdb.org/t/p/w500/"
        case .cast:
            urlString = "https://image.tmdb.org/t/p/w185/"
        case .original:
            urlString = "https://image.tmdb.org/t/p/original/"
        }
        return URL(string: urlString)!.appendingPathComponent(poster)
    }

}
