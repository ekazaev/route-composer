//
// RouteComposer
// ExampleGenericContextTask.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2024.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

struct ExampleGenericContextTask<VC: UIViewController, C>: ContextTask {

    func perform(on viewController: VC, with context: C) throws {
        print("View controller name is \(String(describing: viewController))")
    }

}
