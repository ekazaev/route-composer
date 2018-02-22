//
//  FinderFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

/// Assembly uses finder result as a factory result. Used with things that do not have actual
/// factories like UIViewControllers that were build as a result of storyboard loading.
public class FinderFactory<F: Finder>: Factory {

    public typealias V = F.V

    public typealias C = F.C

    public var action: Action

    let finder: F?

    var context: C?

    public init(finder: F?, action: Action = NilAction()) {
        self.finder = finder
        self.action = action
    }

    public func prepare(with context: C?, logger: Logger?) -> RoutingResult {
        self.context = context
        return .handled
    }

    public func build(logger: Logger?) -> V? {
        return finder?.findViewController(with: context)
    }

}
