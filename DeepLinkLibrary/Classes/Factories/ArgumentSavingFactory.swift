//
//  ArgumentSavingFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 09/02/2018.
//

import Foundation
import UIKit

public protocol ArgumentSavingFactory: Factory {

    var arguments: A? { get set }

}

public extension ArgumentSavingFactory {

    public func prepare(with arguments: A?) -> RoutingResult {
        guard let arguments = arguments else {
            return .unhandled
        }
        self.arguments = arguments
        return .handled
    }

}