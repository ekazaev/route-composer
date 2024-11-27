//
// RouteComposer
// ImageDetailsFetcher.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2024.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

public protocol ImageDetailsFetcher {
    func details(for imageID: String, completion: @escaping (_: UIImage?) -> Void)
}
