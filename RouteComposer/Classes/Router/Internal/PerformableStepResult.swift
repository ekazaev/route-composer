//
// RouteComposer
// PerformableStepResult.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

enum PerformableStepResult {

    case updateContext(AnyContext)

    case success(UIViewController)

    case build(AnyFactory)

    case none

}
