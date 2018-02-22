//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation
import UIKit

public enum FactoryBuildResult {

    /** Factory successfully build view controller */
    case success(UIViewController)

    /** Factory was not able to build a view controller. Routing should not continue */
    case failure(String?)

}
