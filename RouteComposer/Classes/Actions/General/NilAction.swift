//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation
import UIKit

public extension GeneralAction {

    /// The dummy `Action` instance mostly for the internal use, but can be useful outside of the library
    /// in combination with the factories that produces the view controllers that should not have to be integrated into the
    /// view controller's stack.
    public struct NilAction: Action, NilEntity {

        /// Constructor
        public init() {
        }

    }

}
