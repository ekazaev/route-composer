//
// Created by Eugene Kazaev on 2019-09-01.
// Copyright (c) 2019 Eugene Kazaev. All rights reserved.
//

import Foundation
import UIKit
import UpdatableTableViewController
import Models
import APIClient

public protocol MovieSearchResultUpdaterDelegate: AnyObject {

    func search(for query: String)

}

public class MovieSearchResultUpdater: NSObject, UISearchResultsUpdating {

    public weak var delegate: MovieSearchResultUpdaterDelegate?

    private var previousQuery = ""

    public func updateSearchResults(for searchController: UISearchController) {
        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + .seconds(1)
        mainQueue.asyncAfter(deadline: deadline) { [weak self] in
            guard let self = self,
                  let delegate = self.delegate,
                  let query = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces),
                  query != self.previousQuery else {
                return
            }
            self.previousQuery = query
            delegate.search(for: query)
        }
    }

}

public class MovieSearchResultController: ListController, MovieSearchResultUpdaterDelegate {

    public var delegate: ListControllerDelegate? = nil

    public private(set) var items: [Movie] = []

    public private(set) var title: String = ""

    public private(set) var query: String = ""

    private(set) var page: Int = 1

    public init() {
    }

    public func search(for query: String) {
        self.query = query
        items = []
        page = 1
        loadNextPage()
    }

    public func loadNextPage() {
        guard !query.isEmpty else {
            return
        }
        NetworkingManager.shared.GET(endpoint: .searchMovie,
                params: ["query": query, "page": "\(page)"],
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