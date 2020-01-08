//
//  PerformableStepResult.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 23/01/2018.
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
