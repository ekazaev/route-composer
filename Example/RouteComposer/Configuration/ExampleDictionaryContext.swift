//
// Created by Eugene Kazaev on 13/03/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

enum Argument {
    case color
}

class ExampleDictionaryContext {

    var arguments: [Argument: Any] = [:]

    init(arguments: [Argument: Any]? = nil) {
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
