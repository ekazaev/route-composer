//
// Created by Eugene Kazaev on 20/02/2018.
//

import Foundation

protocol PerformableStep: RoutingStep {

    /// - Parameter arguments: Arguments that Router has started with.
    /// - Returns: StepResult enum value, which may contain a view controller in case of .found scenario.
    func perform(with arguments: Any?) -> StepResult

}