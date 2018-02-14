//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Represents step for the router.
public protocol RoutingStep {

    /// Step to be made by a router before getting to this step.
    var previousStep: RoutingStep? { get }

    /// - Parameter arguments: Arguments that Router has started with.
    /// - Returns: StepResult enum value, which may contain a view controller in case of .found scenario.
    func perform(with arguments: Any?) -> StepResult

}
