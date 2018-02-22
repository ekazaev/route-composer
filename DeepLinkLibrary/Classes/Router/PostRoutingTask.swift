//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation
import UIKit

/// PostRoutingTask
/// The task to be executed after deep linking happened.
public protocol PostRoutingTask {

    associatedtype V: UIViewController

    associatedtype A

    func execute(on viewController: V, with arguments: A?, routingStack: [UIViewController])

}