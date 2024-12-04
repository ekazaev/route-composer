//
// RouteComposer
// CustomViewControllerDelegate.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

public protocol CustomViewControllerDelegate: AnyObject {

    @MainActor func dismissCustomContainer(controller: CustomContainerController)

}
