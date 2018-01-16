//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class TopMostViewControllerStep: ChainableStep {

    public init() {
        super.init()
    }

    public override func getPresentationViewController(with arguments: Any?) -> UIViewController? {
        let window = UIWindow.key
        return window?.topmostViewController
    }
}

