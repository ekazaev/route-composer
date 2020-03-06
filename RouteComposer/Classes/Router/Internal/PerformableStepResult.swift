//
// RouteComposer
// PerformableStepResult.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

enum PerformableStepResult {

    case success(UIViewController)

    case build(AnyFactory)

    case none

}

#endif
