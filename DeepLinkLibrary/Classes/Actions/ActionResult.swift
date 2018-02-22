//
//  ActionResult.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

public enum ActionResult {
    /** Action was able to build view controller in to stack. */
    case continueRouting

    /** Action was able to build view controller in to stack. Routing should not continue */
    case failure(String?)

}