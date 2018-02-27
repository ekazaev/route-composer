//
//  MandatoryContextFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 09/02/2018.
//

import Foundation
import UIKit

/// Helper protocol that covers cases when your factory always need some context to be able to create
/// it's UIViewController. Provides default implementation of  Factory's methods and let you extend
/// its own build method with non-optional Context.
public protocol MandatoryContextFactory: Factory {

    /// Shadow of Factory's build method with non-optional context.
    func build(with context: Context) throws -> ViewController

}

public extension MandatoryContextFactory {

    public func prepare(with context: Context?) throws {
        guard let _ = context else {
            throw RoutingError.message("Context for factory \(String(describing: self)) must be set.")
        }
    }

    public func build(with context: Context?) throws -> ViewController {
        guard let context = context else {
            throw RoutingError.message("Context for factory \(String(describing: self)) must be set.")
        }

        return try build(with: context)
    }

}