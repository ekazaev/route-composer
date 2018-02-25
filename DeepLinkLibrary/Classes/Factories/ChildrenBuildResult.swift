//
// Created by Eugene Kazaev on 25/02/2018.
//

import Foundation
import UIKit

public enum ChildrenBuildResult {

    /** Method successfully build children view controller */
    case success([UIViewController])

    /** Method was not able to build a view controller. Creation of Container View Controller should not continue */
    case failure(String?)

}

public extension Container where Self: Factory {

    /// This function contains default implementation how Container should create it's children view controller
    /// before built them in to itself.
    func buildChildrenViewControllers(from factories: [AnyFactory], with context: Self.Context?) -> ChildrenBuildResult {
        var childrenViewControllers: [UIViewController] = []
        for factory in factories {
            switch factory.build(with: context) {
            case .success(let viewController):
                factory.action.performMerged(viewController: viewController, containerViewControllers: &childrenViewControllers)
            case .failure(let message):
                guard let message = message else {
                    let message = "\(String(describing: factory)) has not been able to build it's view controller in \(String(describing: self)) container."
                    return .failure(message)
                }
                return .failure(message)
            }

        }
        return .success(childrenViewControllers)
    }

}