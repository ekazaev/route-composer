//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation

public enum FactoryResult {

    /** Factory will be able to build its view controller with a context provided. */
    case continueRouting

    /** Factory will not be able to build view controller with a context provided. Routing should not continue */
    case failure

}
