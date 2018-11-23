//
//  PerformableStepResult.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

enum PerformableStepResult {

    case success(UIViewController)

    case build(AnyFactory)

    case none

}
