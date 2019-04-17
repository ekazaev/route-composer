//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

protocol AnyPostRoutingTask {

    func execute<Context>(on viewController: UIViewController,
                          with context: Context,
                          routingStack: [UIViewController]) throws

}
