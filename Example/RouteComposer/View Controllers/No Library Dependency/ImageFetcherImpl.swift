//
// RouteComposer
// ImageFetcherImpl.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

import Foundation
import ImagesController

class ImageFetcherImpl: ImagesFetcher {

    func loadImages(completion: @escaping ([String]) -> Void) {
        completion(["first", "second", "star"])
    }

}
