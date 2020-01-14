//
// Created by Eugene Kazaev on 10/07/2018.
//

import Foundation
import RouteComposer
import UIKit

struct ExampleGenericContextTask<VC: UIViewController, C>: ContextTask {

    func perform(on viewController: VC, with context: C) throws {
        print("View controller name is \(String(describing: viewController))")
    }

}
