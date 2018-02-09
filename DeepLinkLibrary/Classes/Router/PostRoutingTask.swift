//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation
import UIKit

/// PostRoutingTask
/// The task to be executed after deep linking happened.
public protocol PostRoutingTask {

    func execute(on viewController: UIViewController, with arguments: Any?, routingStack: [UIViewController])

}