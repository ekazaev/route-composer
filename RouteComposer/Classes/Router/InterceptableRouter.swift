//
// Created by Eugene Kazaev on 18/06/2018.
//

import Foundation
import UIKit

public protocol InterceptableRouter {

    func execute<D: RoutingDestination>(for destination: D, completion: @escaping (_: InterceptorResult) -> Void)

    func execute<D: RoutingDestination>(on viewController: UIViewController, for destination: D, routingStack: [UIViewController])

}
