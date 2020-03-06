//
// RouteComposer
// ExampleGenericContextTask.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

import Foundation
import RouteComposer
import UIKit

struct ExampleGenericContextTask<VC: UIViewController, C>: ContextTask {

    func perform(on viewController: VC, with context: C) throws {
        print("View controller name is \(String(describing: viewController))")
    }

}
