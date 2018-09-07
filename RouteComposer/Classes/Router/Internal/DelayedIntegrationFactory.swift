//
//  DelayedIntegrationFactory.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 03/03/2018.
//

import Foundation
import UIKit

struct DelayedIntegrationFactory<Context>: CustomStringConvertible {

    let factory: AnyFactory

    init(_ factory: AnyFactory) {
        self.factory = factory
    }

    func build(with context: Context, in childViewControllers: inout [UIViewController]) throws {
        let viewController = try factory.build(with: context)
        factory.action.perform(embedding: viewController, in: &childViewControllers)
    }

    public var description: String {
        return String(describing: factory)
    }

}
