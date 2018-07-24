//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation
import UIKit

public extension GeneralAction {

    /// Dummy `Action` class mostly for internal use, but can be useful outside of the library in combination with Factories
    /// which view controllers, do not have to be integrated into the view controller's stack.
    public struct NilAction: Action {

        /// Constructor
        public init() {
        }

        public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
            completion(.continueRouting)
        }

    }

}
