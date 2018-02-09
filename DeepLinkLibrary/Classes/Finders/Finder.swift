//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// Finder to be used by Router to find out if this UIViewController is in view controller stack
public protocol Finder {
    associatedtype V: UIViewController
    associatedtype A

    /// Method to be extended to implement Finder functionality.
    ///
    /// - Parameter arguments: Arguments passed to the router to be presented in a final destination.
    /// - Returns: UIViewController instance that Router is looking for if it has already been built in to
    ///   view controller stack, nil otherwise.
    func findViewController(with arguments: A?) -> V?

}

protocol AnyFinder {
    func findViewController(with arguments: Any?) -> UIViewController?
}

class FinderBox<F: Finder>: AnyFinder {

    let finder: F

    init(_ finder: F) {
        self.finder = finder
    }

    func findViewController(with arguments: Any?) -> UIViewController? {
        guard let typedArguments = arguments as? F.A? else {
            print("\(String(describing:finder)) does not accept \(String(describing: arguments)) as a parameter.")
            return nil
        }
        return finder.findViewController(with: typedArguments)
    }

}