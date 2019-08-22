//
// Created by Eugene Kazaev on 15/01/2018.
//

import UIKit

/// The `Factory` that creates a `UIViewController` class by its name
@available(*, deprecated, renamed: "ClassFactory")
public struct ClassNameFactory<VC: UIViewController, C>: Factory {

    // MARK: Associated types

    public typealias ViewController = VC

    public typealias Context = C

    // MARK: Properties

    /// The name of a `UIViewController` class to be built by the `Factory`
    public let viewControllerName: String?

    /// A Xib file name
    public let nibName: String?

    /// A `Bundle` instance
    public let bundle: Bundle?

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameters:
    ///   - viewControllerName: The name of a `UIViewController` class to be built, if not provided - `ViewController`
    ///     type will be used.
    ///   - nibName: A Xib file name
    ///   - bundle: A `Bundle` instance if needed
    public init(viewControllerName: String? = nil, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.viewControllerName = viewControllerName
        self.nibName = nibNameOrNil
        self.bundle = nibBundleOrNil
    }

    public func build(with context: C) throws -> VC {
        guard let viewControllerName = viewControllerName else {
            return VC(nibName: nibName, bundle: bundle)
        }
        guard let customClass = NSClassFromString(viewControllerName) else {
            throw RoutingError.compositionFailed(.init("Can not find \(viewControllerName) in the bundle."))
        }
        guard let customViewControllerClass = customClass as? VC.Type else {
            throw RoutingError.typeMismatch(type: customClass.self, expectedType: VC.self,
                    .init("Unable to instantiate UIViewController as " +
                            "\(String(describing: type(of: VC.self))), got \(String(describing: customClass)) instead."))
        }

        return customViewControllerClass.init(nibName: nibName, bundle: bundle)
    }

}
