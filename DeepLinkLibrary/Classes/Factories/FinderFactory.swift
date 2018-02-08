//
//  FinderFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

// Mostly for internal use but can be usefull outside of the library in combination with FinderFactory
public class NilAction: ViewControllerAction {
    public init() {
        
    }
    
    public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, logger: Logger?, completion: @escaping (UIViewController) -> Void) {
        completion(viewController)
    }
}

/// Assembly uses finder result as a factory result. Used with things that do not have actual
/// factories like UIViewControllers that were build as a result of storyboard loading.
public class FinderFactory: PreparableFactory {

    public var action: ViewControllerAction

    let finder: DeepLinkFinder?

    var arguments: Any?

    public init(finder: DeepLinkFinder?, action: ViewControllerAction = NilAction()) {
        self.finder = finder
        self.action = action
    }

    public func prepare(with arguments: Any?) -> DeepLinkResult {
        self.arguments = arguments
        return .handled
    }

    public func build(with logger: Logger?) -> UIViewController? {
        return finder?.findViewController(with: arguments)
    }
}
