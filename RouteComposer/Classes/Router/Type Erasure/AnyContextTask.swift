//
// RouteComposer
// AnyContextTask.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
import UIKit

protocol AnyContextTask {

    mutating func prepare(with context: AnyContext) throws

    func perform(on viewController: UIViewController, with context: AnyContext) throws

}
