//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

public class PostRoutingTaskMultiplexer: PostRoutingTask {

    private let tasks: [PostRoutingTask]

    public init(_ tasks: [PostRoutingTask]) {
        self.tasks = tasks
    }

    public func execute(on viewController: UIViewController, routingStack: [UIViewController], with arguments: Any?) {
        self.tasks.forEach({ $0.execute(on: viewController, routingStack: routingStack, with: arguments) })
    }
}