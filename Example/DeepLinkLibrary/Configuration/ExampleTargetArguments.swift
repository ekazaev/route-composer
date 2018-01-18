//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import DeepLinkLibrary

enum Argument {
    case color
    case cityId
    case productId
}

struct ExampleTargetArguments {

    let originalUrl: URL?

    var arguments: [Argument: Any] = [:]

    init(originalUrl: URL? = nil, arguments: [Argument: Any]? = nil) {
        self.originalUrl = originalUrl
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

struct ExampleDestination: DeepLinkDestination {
    typealias A = ExampleTargetArguments

    let screen: DeepLinkableScreen

    let arguments: A?
}
