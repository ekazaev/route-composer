//
//  MandatoryContextFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 09/02/2018.
//

import Foundation
import UIKit

public protocol MandatoryContextFactory: Factory {

    func build(with context: Context) -> FactoryBuildResult

}

public extension MandatoryContextFactory {

    public func prepare(with context: Context?) -> FactoryPreparationResult {
        guard let _ = context else {
            return .failure("Context for factory \(String(describing: self)) must be set.")
        }
        return .success
    }

    public func build(with context: Context?) -> FactoryBuildResult {
        guard let context = context else {
            return .failure("Context for factory \(String(describing: self)) must be set.")
        }

        return self.build(with: context)
    }

}