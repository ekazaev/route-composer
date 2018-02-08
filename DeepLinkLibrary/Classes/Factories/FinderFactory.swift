//
//  FinderFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

// Mostly for internal use but can be useful outside of the library in combination with FinderFactory
public class NilAction: Action {
    public init() {
        
    }
    
    public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, logger: Logger?, completion: @escaping (ActionResult) -> Void) {
        completion(.continueRouting)
    }
}

/// Assembly uses finder result as a factory result. Used with things that do not have actual
/// factories like UIViewControllers that were build as a result of storyboard loading.
public class FinderFactory<F: Finder>: Factory {

    public typealias V = F.V
    public typealias A = F.A

    public var action: Action

    let finder: F?

    var arguments: A?

    public init(finder: F?, action: Action = NilAction()) {
        self.finder = finder
        self.action = action
    }

    public func prepare(with arguments: A?) -> RoutingResult {
        self.arguments = arguments
        return .handled
    }

    public func build(with logger: Logger?) -> V? {
        return finder?.findViewController(with: arguments)
    }
}
