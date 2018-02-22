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

    let finder: F

    var context: Context?

    public init(finder: F, action: Action = NilAction()) {
        self.finder = finder
        self.action = action
    }

    public func prepare(with context: Context?) -> RoutingResult {
        self.context = context
        return .handled
    }

    public func build() -> FactoryBuildResult {
        if let viewController = finder.findViewController(with: context) {
            return .success(viewController)
        }
        return .failure("Finder \(String(describing: finder)) not found its view controller in stack.")
    }

}
