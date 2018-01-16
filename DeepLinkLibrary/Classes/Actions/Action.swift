//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public protocol Action {

    // If view controller that action should apply to has been merged in Container View Controller,
    // it will call this action instead so Action can apply it action without changing view controller stack.
    // NB: Haven't been implemented yet so possibly will be removed in future.
    func applyMerged(viewController: UIViewController, in existingController: UIViewController)

    // Applies implemented action to the view controller.
    // Calls completion with view controller to apply action if it was successfully build in view controller stack, wit exiction otherwise.
    // NB: completion block is mandatory to be called in implementation.
    func apply(viewController: UIViewController, on existingController: UIViewController, completion: @escaping (_: UIViewController) -> Void)

}


public class NilAction: Action {

    public init() {
        
    }
    
    public func applyMerged(viewController: UIViewController, in existingController: UIViewController) {

    }

    public func apply(viewController: UIViewController, on existingController: UIViewController, completion: @escaping(_: UIViewController) -> Void) {
        return completion(existingController)
    }

}
