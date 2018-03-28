//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// Default implementation of the unique view controller finder, where view controller can be found by name.
/// (Example: Home, account, login, etc supposed to be in the view stack just once)
public class ClassFinder<VC:UIViewController, C>: StackIteratingFinder {

    public typealias ViewController = VC

    public typealias Context = C

    public let options: SearchOptions

    public init(options: SearchOptions = .currentAndUp) {
        self.options = options
    }

    public func isWanted(target viewController: ViewController, with context: Context) -> Bool {
        return true
    }

}
