//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation

/// The step that contains implementation how to be attached to the previous one
public protocol ChainingStep {

    /// From method
    ///
    /// - Parameter step: The `RoutingStep` instance to be set as previous one
    func from(_ step: RoutingStep)

}
