//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class ViewControllerFromStoryboard: Factory {

    public let action: Action

    private let storyboardName: String

    private let viewControllerID: String

    public init(storyboardName: String, viewControllerID: String, action: Action = NilAction()) {
        self.action = action
        self.storyboardName = storyboardName
        self.viewControllerID = viewControllerID
    }

    public func build() -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        return viewController
    }

}

