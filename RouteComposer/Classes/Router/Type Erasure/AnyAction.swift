//
// RouteComposer
// AnyAction.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

protocol PostponedActionIntegrationHandler: AnyObject {

    var containerViewController: ContainerViewController? { get }

    var postponedViewControllers: [UIViewController] { get }

    func update(containerViewController: ContainerViewController, animated: Bool, completion: @escaping (_: RoutingResult) -> Void)

    func update(postponedViewControllers: [UIViewController])

    func purge(animated: Bool, completion: @escaping (_: RoutingResult) -> Void)

}

protocol AnyAction {

    func perform(with viewController: UIViewController,
                 on existingController: UIViewController,
                 with postponedIntegrationHandler: PostponedActionIntegrationHandler,
                 nextAction: AnyAction?,
                 animated: Bool,
                 completion: @escaping (_: RoutingResult) -> Void)

    func perform(embedding viewController: UIViewController,
                 in childViewControllers: inout [UIViewController]) throws

    func isEmbeddable(to container: ContainerViewController.Type) -> Bool

}
