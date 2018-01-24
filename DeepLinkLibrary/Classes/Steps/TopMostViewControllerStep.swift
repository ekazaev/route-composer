//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// - getPresentationViewController: Returns topmost presented view controller.
public class TopMostViewControllerStep: ChainableStep {

    public init() {
        super.init()
    }

    public override func perform(with arguments: Any?) -> StepResult {
        let window = UIWindow.key
        return StepResult(window?.topmostViewController)
    }
}

