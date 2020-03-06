//
// RouteComposer
// CustomViewControllerDelegate.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

import Foundation

public protocol CustomViewControllerDelegate: AnyObject {

    func dismissCustomContainer(controller: CustomContainerController)

}
