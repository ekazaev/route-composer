//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Chainable step.
/// Identifies that the step can be a part of the chain,
/// e.g. when it comes to the presentation of multiple view controllers to reach destination.
protocol ChainableStep: RoutingStep {

    /// Step to be made by a router before getting to this step.
    var previousStep: RoutingStep? { get }

}
