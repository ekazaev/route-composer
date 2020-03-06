//
// RouteComposer
// ImagesFetcher.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

import Foundation

public protocol ImagesFetcher {

    func loadImages(completion: @escaping (_: [String]) -> Void)

}
