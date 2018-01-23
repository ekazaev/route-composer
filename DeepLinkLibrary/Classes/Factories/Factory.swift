//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Factory's only responcibility is to  build a UIViewController on routers demand and then router uses a
///factory action to integrate UIViewController that has been built by a factory in to existant view controller stack
public protocol Factory: class {

    var action: ViewControllerAction? { get }

    func build(with logger: Logger?) -> UIViewController?

}
