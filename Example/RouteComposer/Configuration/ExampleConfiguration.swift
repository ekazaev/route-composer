//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import RouteComposer

class ExampleConfiguration {

    private static var screens: [AnyHashable: RoutingStep] = [:]

    static func step<T: Hashable>(for target: T) -> RoutingStep? {
        return screens[target]
    }

    static func register<T: Hashable>(screen: RoutingStep, for target: T) {
        screens[target] = screen
    }

    static func destination<T: Hashable>(for target: T, context: ExampleDictionaryContext? = nil) -> ExampleDestination? {
        guard let assembly = step(for: target) else {
            return nil
        }

        return ExampleDestination(finalStep: assembly, context: context ?? ExampleDictionaryContext())
    }
}
