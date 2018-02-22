//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation
import UIKit

// Mostly for internal use but can be useful outside of the library in combination with FinderFactory
public class NilAction: Action {

    public init() {
    }

    public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
        completion(.continueRouting)
    }
}
