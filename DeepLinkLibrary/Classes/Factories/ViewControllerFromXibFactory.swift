//
//  ViewControllerFromXibFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 09/02/2018.
//

import Foundation
import UIKit

public class ViewControllerFromXibFactory<VV: UIViewController, AA>: Factory {

    public typealias V = VV
    public typealias A = AA

    public let action: Action

    private let nibName: String?
    public let bundle: Bundle?

    public init(nibName: String? = nil, bundle: Bundle? = nil, action: Action) {
        self.action = action
        self.nibName = nibName
        self.bundle = bundle
    }

    public func build(with logger: Logger?) -> V? {
        let viewController = V(nibName: nibName, bundle: bundle)
        return viewController
    }

}
