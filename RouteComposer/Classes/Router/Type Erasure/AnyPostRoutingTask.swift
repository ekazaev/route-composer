//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

protocol AnyPostRoutingTask {

    func execute(on viewController: UIViewController,
                 with context: Any?,
                 routingStack: [UIViewController]) throws

}
