//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// - getPresentationViewController: Returns topmost presented view controller.
public class TopMostViewControllerStep: RoutingStep {

    public let interceptor: RouterInterceptor? = nil
    
    public let postTask: PostRoutingTask? = nil
    
    public var previousStep: RoutingStep? = nil
    
    public init() {
    }

    public func perform(with arguments: Any?) -> StepResult {
        let window = UIWindow.key
        return StepResult(window?.topmostViewController)
    }
}

