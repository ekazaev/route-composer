//
// Created by Eugene Kazaev on 18/06/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class GlobalContextTask: ContextTask {

    func apply(on viewController: UIViewController, with context: Any?) {
        print("Applied \(context ?? "empty context") on \(viewController)")
    }

}
