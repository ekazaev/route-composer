//
// RouteComposer
// AnyPostRoutingTask.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

protocol AnyPostRoutingTask {

    func perform<Context>(on viewController: UIViewController,
                          with context: Context,
                          routingStack: [UIViewController]) throws

}

#endif
