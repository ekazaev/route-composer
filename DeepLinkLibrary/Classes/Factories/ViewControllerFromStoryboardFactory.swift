//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class ViewControllerFromStoryboard: Factory {

    public let action: ViewControllerAction

    private let storyboardName: String

    private let viewControllerID: String?

    public init(storyboardName: String, viewControllerID: String? = nil, action: ViewControllerAction) {
        self.action = action
        self.storyboardName = storyboardName
        self.viewControllerID = viewControllerID
    }

    public func build(with logger: Logger?) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let viewControllerID = viewControllerID {
            return storyboard.instantiateViewController(withIdentifier: viewControllerID)
        } else {
            let viewController = storyboard.instantiateInitialViewController()
            if viewController == nil {
                logger?.log(.error("Unable to instantiate initial UIViewController in \(storyboardName) storyboard"))
            }
            return viewController
        }
    }

}

