//
//  RoutingInterceptable.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 23/01/2018.
//
#if os(iOS)

import Foundation
import UIKit

/// `UIViewController` that conforms to this protocol may overtake the control of the view controllers stack and
/// forbid the `Router` to dismiss or cover itself with another view controller.
/// Return false if the view controller can be dismissed.
public protocol RoutingInterceptable where Self: UIViewController {

    // MARK: Properties to implement

    /// true: if a view controller can be dismissed or covered by the `Router`, false otherwise.
    var canBeDismissed: Bool { get }

}

#endif
