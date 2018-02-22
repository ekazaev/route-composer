//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Returns topmost presented view controller.
public class TopMostViewControllerStep: PerformableStep {

    public init() {
    }

    func perform(with context: Any?) -> StepResult {
        let window = UIWindow.key
        return StepResult(window?.topmostViewController)
    }

}

