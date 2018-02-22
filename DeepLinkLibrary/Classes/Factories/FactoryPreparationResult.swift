//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation

public enum FactoryPreparationResult {

    /** Factory will be able to build its view controller with a context provided. */
    case success

    /** Factory will not be able to build view controller with a context provided. Routing should not continue */
    case failure(String?)

}
