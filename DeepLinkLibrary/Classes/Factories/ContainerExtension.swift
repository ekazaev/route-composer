//
// Created by Eugene Kazaev on 25/02/2018.
//

import Foundation
import UIKit

public extension Container where Self: Factory {

    /// This function contains default implementation how Container should create it's children view controller
    /// before built them in to itself.
    func buildChildrenViewControllers(from factories: [AnyFactory], with context: Self.Context?) throws -> [UIViewController] {
        var childrenViewControllers: [UIViewController] = []
        for factory in factories {
            let viewController = try factory.build(with: context)
            factory.action.performMerged(viewController: viewController, containerViewControllers: &childrenViewControllers)
        }
        return  childrenViewControllers
    }

}