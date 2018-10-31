//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

struct BaseStep: RoutingStep,
        ChainableStep,
        ChainingStep,
        InterceptableStep,
        PerformableStep,
        CustomStringConvertible {

    private(set) var previousStep: RoutingStep?

    let factory: AnyFactory?

    let finder: AnyFinder?

    let interceptor: AnyRoutingInterceptor?

    let postTask: AnyPostRoutingTask?

    let contextTask: AnyContextTask?

    init(finder: AnyFinder?,
         factory: AnyFactory?,
         interceptor: AnyRoutingInterceptor?,
         contextTask: AnyContextTask?,
         postTask: AnyPostRoutingTask?) {
        self.finder = finder
        self.factory = factory
        self.interceptor = interceptor
        self.contextTask = contextTask
        self.postTask = postTask
    }

    func perform(with context: Any?) throws -> PerformableStepResult {
        guard let viewController = try finder?.findViewController(with: context) else {
            if let factory = factory {
                return .build(factory)
            } else {
                return .none
            }
        }
        return .success(viewController)
    }

    mutating func from(_ step: RoutingStep) {
        previousStep = step
    }

    public var description: String {
        var finderDescription = "None"
        var factoryDescription = "None"
        if let finder = finder {
            finderDescription = String(describing: finder)
        }
        if let factory = factory {
            factoryDescription = String(describing: factory)
        }
        return "BaseStep<\(finderDescription) : \(factoryDescription))>"
    }

}
