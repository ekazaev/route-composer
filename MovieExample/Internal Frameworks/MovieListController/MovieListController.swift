//
// Created by Eugene Kazaev on 2019-08-21.
// Copyright (c) 2019 Eugene Kazaev. All rights reserved.
//

import Foundation
import APIClient
import UpdatableTableViewController
import Models

public class MovieListController: ListController {
    
    public var delegate: ListControllerDelegate?
    
    public private(set) var items: [Movie] = []
    
    private(set) var page: Int = 1
    
    public let type: ListType
    
    public var title: String {
        return type.title
    }
    
    public init(type: ListType) {
        self.type = type
    }
    
    public func loadNextPage() {
        NetworkingManager.shared.GET(endpoint: type.endpoint,
                                     params: ["page": "\(page)", "region": Locale.current.regionCode ?? "US"],
                                     completionHandler: { [weak self](result: Result<PaginatedResponse<Movie>, NetworkingManager.APIError>) in
                                        guard let self = self else {
                                            return
                                        }
                                        switch result {
                                        case .success(let response):
                                            self.page += 1
                                            self.items.append(contentsOf: response.results)
                                            self.delegate?.reloadData()
                                        case .failure:
                                            return
                                        }
        })
    }
}

extension ListType {

    var endpoint: NetworkingManager.Endpoint {
        switch self {
        case .popular:
            return .popular
        case .topRated:
            return .topRated
        case .upcoming:
            return .upcoming
        case .nowPlaying:
            return .nowPlaying
        case .trending:
            return .trending
        }
    }

    var title: String {
        switch self {
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        case .upcoming:
            return "Upcoming"
        case .nowPlaying:
            return "Now Playing"
        case .trending:
            return "Trending"
        }
    }

}
