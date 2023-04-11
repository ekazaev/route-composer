//
// RouteComposer
// PostRoutingTaskBox.swift
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

struct PostRoutingTaskBox<PT: PostRoutingTask>: AnyPostRoutingTask, MainThreadChecking, CustomStringConvertible {

    let postRoutingTask: PT

    init(_ postRoutingTask: PT) {
        self.postRoutingTask = postRoutingTask
    }

    func perform(on viewController: UIViewController,
                 with context: AnyContext,
                 routingStack: [UIViewController]) throws {
        guard let typedViewController = viewController as? PT.ViewController else {
            throw RoutingError.typeMismatch(type: type(of: viewController),
                                            expectedType: PT.ViewController.self,
                                            .init("\(String(describing: postRoutingTask.self)) does not support \(String(describing: viewController.self))."))
        }
        let typedDestination: PT.Context = try context.value()
        assertIfNotMainThread()
        postRoutingTask.perform(on: typedViewController, with: typedDestination, routingStack: routingStack)
    }

    var description: String {
        String(describing: postRoutingTask)
    }

}
