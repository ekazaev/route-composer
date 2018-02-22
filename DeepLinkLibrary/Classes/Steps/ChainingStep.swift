//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation

public protocol ChainingStep: RoutingStep {

    func from(_ step: RoutingStep)

}