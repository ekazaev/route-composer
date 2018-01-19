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

protocol ExampleArguments {

    var url: URL? { get }

}

struct ExampleDictionaryArguments: ExampleArguments {

    let url: URL?

    var arguments: [Argument: Any] = [:]

    init(originalUrl: URL? = nil, arguments: [Argument: Any]? = nil) {
        self.url = originalUrl
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

    let screen: DeepLinkableScreen

    let arguments: Any?

}
