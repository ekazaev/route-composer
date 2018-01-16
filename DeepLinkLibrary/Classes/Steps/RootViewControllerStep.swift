//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class RootViewControllerStep: ChainableStep {

    public init() {
        super.init()
    }

    override public func getPresentationViewController(with arguments: Any?) -> UIViewController? {
        return UIWindow.key?.rootViewController
    }

}
