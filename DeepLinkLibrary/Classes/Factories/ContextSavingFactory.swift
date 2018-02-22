//
//  ContextSavingFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 09/02/2018.
//

import Foundation
import UIKit

public protocol ContextSavingFactory: Factory {

    var context: C? { get set }

}

public extension ContextSavingFactory {

    public func prepare(with context: C?, logger: Logger?) -> RoutingResult {
        guard let context = context else {
            return .unhandled
        }
        self.context = context
        return .handled
    }

}