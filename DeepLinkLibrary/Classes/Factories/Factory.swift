//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Factory
/// action: router applies action to integrate view controller created by build() in the existing view controller stack
/// build(): builds a view controller that will be pushed to the viw stack
public protocol Factory: class {

    var action: Action { get }

    func build(with logger: Logger?) -> UIViewController?

}
