//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class ViewControllerFromStoryboard<VV: UIViewController, CC>: Factory {

    public typealias V = VV

    public typealias C = CC

    public let action: Action

    private let storyboardName: String

    private let viewControllerID: String?

    public init(storyboardName: String, viewControllerID: String? = nil, action: Action) {
        self.action = action
        self.storyboardName = storyboardName
        self.viewControllerID = viewControllerID
    }

    public func build(logger: Logger?) -> V? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let viewControllerID = viewControllerID {
            guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerID) as? VV else {
                return nil
            }
            return viewController
        } else {
            guard let abstractViewController = storyboard.instantiateInitialViewController() else {
                logger?.log(.error("Unable to instantiate initial UIViewController in \(storyboardName) storyboard"))
                return nil
            }
            guard let viewController = abstractViewController as? V else {
                logger?.log(.error("Unable to instantiate initial UIViewController in \(storyboardName) storyboard as \(String(describing: type(of: V.self))), got \(String(describing: abstractViewController)) instead."))
                return nil
            }

            return viewController
        }
    }

}

