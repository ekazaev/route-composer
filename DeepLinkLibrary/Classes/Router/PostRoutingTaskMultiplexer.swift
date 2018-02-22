//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

class PostRoutingTaskMultiplexer: AnyPostRoutingTask {

    private let tasks: [AnyPostRoutingTask]

    init(_ tasks: [AnyPostRoutingTask]) {
        self.tasks = tasks
    }

    func execute(on viewController: UIViewController, with context: Any?, routingStack: [UIViewController]) {
        self.tasks.forEach({ $0.execute(on: viewController, with: context, routingStack: routingStack) })
    }
}