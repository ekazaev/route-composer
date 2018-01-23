//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation
import UIKit

public protocol PostRoutingTask {

    func execute(on viewController: UIViewController, with arguments: Any?)

}