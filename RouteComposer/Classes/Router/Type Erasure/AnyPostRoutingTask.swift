//
// Created by Eugene Kazaev on 14/02/2018.
//

#if os(iOS)

import Foundation
import UIKit

protocol AnyPostRoutingTask {

    func perform<Context>(on viewController: UIViewController,
                          with context: Context,
                          routingStack: [UIViewController]) throws

}

#endif
