//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Represents a single step for the `Router` to make.
public protocol RoutingStep {

}

public protocol RoutingStepWithContext: RoutingStep {

    associatedtype Context

}

fileprivate class _AnyStepBase<C>: RoutingStepWithContext {
    typealias Context = C
    init() {
        guard type(of: self) != _AnyStepBase.self else {
            fatalError("_AnyStepBase<C> instances can not be created; create a subclass instance instead")
        }
    }
}

fileprivate final class _AnyStepBox<Base: RoutingStepWithContext>: _AnyStepBase<Base.Context> {
    var base: Base
    init(_ base: Base) { self.base = base }
}

final class AnyStep<C>: RoutingStepWithContext {
    typealias Context = C
    private let box: _AnyStepBase<C>
    init<Base: RoutingStepWithContext>(_ base: Base) where Base.Context == C {
        box = _AnyStepBox(base)
    }
}