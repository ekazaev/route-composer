//
// Created by Eugene Kazaev on 10/07/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

struct ExampleGenericContextTask<VC: UIViewController, C>: ContextTask {
    typealias ViewController = VC
    typealias Context = C
    func apply(on viewController: ViewController, with context: Context) throws {
        print("View controller name is \(String(describing: viewController))")
    }

}
