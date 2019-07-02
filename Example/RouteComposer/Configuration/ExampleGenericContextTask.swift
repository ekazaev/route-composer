//
// Created by Eugene Kazaev on 10/07/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

struct ExampleGenericContextTask<VC: UIViewController, C>: ContextTask {

    func perform(on viewController: VC, with context: C) throws {
        print("View controller name is \(String(describing: viewController))")
    }

}
