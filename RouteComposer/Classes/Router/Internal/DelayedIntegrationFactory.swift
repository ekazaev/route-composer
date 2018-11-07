//
//  DelayedIntegrationFactory.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 03/03/2018.
//

import Foundation
import UIKit

struct DelayedIntegrationFactory<Context>: CustomStringConvertible {

    var factory: AnyFactory

    init(_ factory: AnyFactory, isPrepared: Bool = false) {
        self.factory = factory
    }

    mutating func prepare(with context: Context) throws {
        try factory.prepare(with: context)
    }

    func build(with context: Context, in childViewControllers: inout [UIViewController]) throws {
        let viewController = try factory.build(with: context)
        try factory.action.perform(embedding: viewController, in: &childViewControllers)
    }

    public var description: String {
        return String(describing: factory)
    }

}
