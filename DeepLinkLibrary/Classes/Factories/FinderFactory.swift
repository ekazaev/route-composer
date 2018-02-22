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

    public typealias ViewController = F.ViewController

    public typealias Context = F.Context

    public var action: Action

    let finder: F?

    var context: Context?

    public init(finder: F?, action: Action = NilAction()) {
        self.finder = finder
        self.action = action
    }

    public func prepare(with context: Context?, logger: Logger?) -> RoutingResult {
        self.context = context
        return .handled
    }

    public func build(logger: Logger?) -> ViewController? {
        return finder?.findViewController(with: context)
    }

}
