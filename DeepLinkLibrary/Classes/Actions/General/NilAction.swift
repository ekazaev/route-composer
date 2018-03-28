//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation
import UIKit

public extension GeneralAction {

    /// Dummy action class mostly for internal use, but can be useful outside of the library in combination with Factories
    /// which view controllers, do not have to be integrated in to a view controller's stack.
    public class NilAction: Action {

        public init() {
        }

        public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
            completion(.continueRouting)
        }

    }

}