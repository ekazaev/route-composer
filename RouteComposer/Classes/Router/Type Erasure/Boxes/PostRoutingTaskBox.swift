//
// RouteComposer
// PostRoutingTaskBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

struct PostRoutingTaskBox<PT: PostRoutingTask>: AnyPostRoutingTask, MainThreadChecking, CustomStringConvertible {

    let postRoutingTask: PT

    init(_ postRoutingTask: PT) {
        self.postRoutingTask = postRoutingTask
    }

    func perform<Context>(on viewController: UIViewController,
                          with context: Context,
                          routingStack: [UIViewController]) throws {
        guard let typedViewController = viewController as? PT.ViewController else {
            throw RoutingError.typeMismatch(type: type(of: viewController),
                                            expectedType: PT.ViewController.self,
                                            .init("\(String(describing: postRoutingTask.self)) does not support \(String(describing: viewController.self))."))
        }
        guard let typedDestination = Any?.some(context as Any) as? PT.Context else {
            throw RoutingError.typeMismatch(type: type(of: context),
                                            expectedType: PT.Context.self,
                                            .init("\(String(describing: postRoutingTask.self)) does not accept \(String(describing: context.self)) as a context."))
        }
        assertIfNotMainThread()
        postRoutingTask.perform(on: typedViewController, with: typedDestination, routingStack: routingStack)
    }

    var description: String {
        String(describing: postRoutingTask)
    }

}

#endif
