//
//  RouterRulesViewController.swift
//  DeepLinkLibrary
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation
import UIKit

/// UIViewController's protocol exposed outside of the library. .
/// UIViewController that conforms to this protocol may overtake the control of the view controllers stack and
/// forbid the router to dismiss or cover it with another view controller.
/// Return false if the view controller can be dismissed.

@objc public  protocol RouterRulesViewController where Self: UIViewController {
    
    /// returns true: if a view controller can be dismissed or covered by the Router, false otherwise.
    var canBeDismissed: Bool { get }
}
