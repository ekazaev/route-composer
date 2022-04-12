//
// RouteComposer
// AnyFinder.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
import UIKit

protocol AnyFinder {

    func findViewController<Context>(with context: Context) throws -> UIViewController?

}
