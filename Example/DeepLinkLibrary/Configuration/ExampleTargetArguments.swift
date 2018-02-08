//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import DeepLinkLibrary

enum Argument {
    case color
}

protocol ExampleArguments: class {

    var analyticParameters: ExampleAnalyticsParameters? { set get }

}

class ExampleDictionaryArguments: ExampleArguments {

    var analyticParameters: ExampleAnalyticsParameters?

    var arguments: [Argument: Any] = [:]

    init(arguments: [Argument: Any]? = nil, _ analyticParameters: ExampleAnalyticsParameters? = nil) {
        self.analyticParameters = analyticParameters
        if let arguments = arguments {
            self.arguments.merge(arguments, uniquingKeysWith: { (_, last) in last })
        }
    }

    public subscript(index: Argument) -> Any? {
        get {
            return arguments[index]
        }

        set(newValue) {
            arguments[index] = newValue
        }
    }

}

struct ExampleDestination: RoutingDestination {

    let finalStep: RoutingStep

    let arguments: Any?

}
