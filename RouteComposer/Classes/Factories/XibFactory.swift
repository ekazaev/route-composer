//
//  XibFactory.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 09/02/2018.
//

import Foundation
import UIKit

/// The `Factory` that creates a `UIViewController` from a Xib file.
public struct XibFactory<VC: UIViewController, C>: Factory {

    public typealias ViewController = VC

    public typealias Context = C

    private let nibName: String?

    private let bundle: Bundle?

    /// Constructor
    ///
    /// - Parameters:
    ///   - nibName: Xib file name
    ///   - bundle: Bundle instance if needed
    public init(nibName: String? = nil, bundle: Bundle? = nil) {
        self.nibName = nibName
        self.bundle = bundle
    }

    public func build(with context: Context) throws -> ViewController {
        let viewController = ViewController(nibName: nibName, bundle: bundle)
        return viewController
    }

}
