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

    @MainActor var containerViewController: ContainerViewController? { get }

    @MainActor var postponedViewControllers: [UIViewController] { get }

    @MainActor func update(containerViewController: ContainerViewController, animated: Bool, completion: @escaping (_: RoutingResult) -> Void)

    @MainActor func update(postponedViewControllers: [UIViewController])

    @MainActor func purge(animated: Bool, completion: @escaping (_: RoutingResult) -> Void)

}

protocol AnyAction {

    @MainActor func perform(with viewController: UIViewController,
                            on existingController: UIViewController,
                            with postponedIntegrationHandler: PostponedActionIntegrationHandler,
                            nextAction: AnyAction?,
                            animated: Bool,
                            completion: @escaping (_: RoutingResult) -> Void)

    @MainActor func perform(embedding viewController: UIViewController,
                            in childViewControllers: inout [UIViewController]) throws

    @MainActor func isEmbeddable(to container: ContainerViewController.Type) -> Bool

}
