//
// Created by Eugene Kazaev on 10/07/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

struct ExampleGenericContextTask: ContextTask {
    
    func apply(on viewController: UIViewController, with context: Any?) {
        print("View controller name is \(String(describing: viewController))")
    }
    
}
