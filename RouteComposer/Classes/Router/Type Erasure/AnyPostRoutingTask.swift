//
// RouteComposer
// AnyPostRoutingTask.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
import UIKit

protocol AnyPostRoutingTask {

    func perform(on viewController: UIViewController,
                          with context: AnyContext,
                          routingStack: [UIViewController]) throws

}
