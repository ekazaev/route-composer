//
// Created by Eugene Kazaev on 23/01/2018.
//

#if os(iOS)

import Foundation
import UIKit

struct PostRoutingTaskMultiplexer: AnyPostRoutingTask, CustomStringConvertible {

    private let tasks: [AnyPostRoutingTask]

    init(_ tasks: [AnyPostRoutingTask]) {
        self.tasks = tasks
    }

    func perform<Context>(on viewController: UIViewController, with context: Context, routingStack: [UIViewController]) throws {
        try tasks.forEach { try $0.perform(on: viewController, with: context, routingStack: routingStack) }
    }

    var description: String {
        return String(describing: tasks)
    }

}

#endif
