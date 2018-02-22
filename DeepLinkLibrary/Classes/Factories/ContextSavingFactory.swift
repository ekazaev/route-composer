//
//  ContextSavingFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 09/02/2018.
//

import Foundation
import UIKit

public protocol ContextSavingFactory: Factory {

    var context: Context? { get set }

}

public extension ContextSavingFactory {

    public func prepare(with context: Context?) -> FactoryPreparationResult {
        guard let context = context else {
            return .failure("Unable to prepare factory \(String(describing: self)) for routing as provided context is nil.")
        }
        self.context = context
        return .success
    }

}