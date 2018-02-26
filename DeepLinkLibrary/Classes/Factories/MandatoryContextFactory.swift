//
//  MandatoryContextFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 09/02/2018.
//

import Foundation
import UIKit

public protocol MandatoryContextFactory: Factory {

    func build(with context: Context) throws -> UIViewController

}

public extension MandatoryContextFactory {

    public func prepare(with context: Context?) throws {
        guard let _ = context else {
            throw RoutingError.message("Context for factory \(String(describing: self)) must be set.")
        }
    }

    public func build(with context: Context?) throws -> UIViewController {
        guard let context = context else {
            throw RoutingError.message("Context for factory \(String(describing: self)) must be set.")
        }

        return try build(with: context)
    }

}