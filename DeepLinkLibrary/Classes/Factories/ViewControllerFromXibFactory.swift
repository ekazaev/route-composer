//
//  ViewControllerFromXibFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 09/02/2018.
//

import Foundation
import UIKit

public class ViewControllerFromXibFactory<VV: UIViewController, CC>: Factory {

    public typealias V = VV

    public typealias C = CC

    public let action: Action

    private let nibName: String?
    public let bundle: Bundle?

    public init(nibName: String? = nil, bundle: Bundle? = nil, action: Action) {
        self.action = action
        self.nibName = nibName
        self.bundle = bundle
    }

    public func build(logger: Logger?) -> V? {
        let viewController = VV(nibName: nibName, bundle: bundle)
        return viewController
    }

}
