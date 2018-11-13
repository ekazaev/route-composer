//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

protocol EntitiesProvider {

    var finder: AnyFinder? { get }

    var factory: AnyFactory? { get }

}

protocol TaskProvider {

    var interceptor: AnyRoutingInterceptor? { get }

    var contextTask: AnyContextTask? { get }

    var postTask: AnyPostRoutingTask? { get }
}

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

    init(entitiesProvider: EntitiesProvider,
         taskProvider: TaskProvider) {
        self.finder = entitiesProvider.finder
        self.factory = entitiesProvider.factory
        self.interceptor = taskProvider.interceptor
        self.contextTask = taskProvider.contextTask
        self.postTask = taskProvider.postTask
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
