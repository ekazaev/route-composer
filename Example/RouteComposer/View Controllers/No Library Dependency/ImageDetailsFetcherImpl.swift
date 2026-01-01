//
// RouteComposer
// ImageDetailsFetcherImpl.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2026.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import ImageDetailsController
import UIKit

class ImageDetailsFetcherImpl: ImageDetailsFetcher {

    func details(for imageID: String, completion: @escaping (UIImage?) -> Void) {
        guard let image = UIImage(named: imageID) else {
            completion(nil)
            return
        }

        completion(image)
    }

}
