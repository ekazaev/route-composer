//
// Created by Eugene Kazaev on 20/02/2018.
//

import Foundation

protocol PerformableStep: RoutingStep {

    /// - Parameter context: Context object that Router has started with.
    /// - Returns: StepResult enum value, which may contain a view controller in case of .found scenario.
    func perform<D: RoutingDestination>(for destination: D) -> StepResult

}