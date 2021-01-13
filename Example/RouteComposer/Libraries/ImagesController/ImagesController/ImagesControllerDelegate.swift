//
// RouteComposer
// ImagesControllerDelegate.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

import Foundation

public protocol ImagesControllerDelegate: AnyObject {

    func didSelect(imageID: String, in controller: ImagesViewController)

}
