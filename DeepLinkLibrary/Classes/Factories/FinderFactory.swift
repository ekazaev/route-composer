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
public class FinderFactory: Factory {

    public var action: Action

    let finder: Finder?

    var arguments: Any?

    public init(finder: Finder?, action: Action = NilAction()) {
        self.finder = finder
        self.action = action
    }

    public func prepare(with arguments: Any?) -> RoutingResult {
        self.arguments = arguments
        return .handled
    }

    public func build(with logger: Logger?) -> UIViewController? {
        return finder?.findViewController(with: arguments)
    }
}
