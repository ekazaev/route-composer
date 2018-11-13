//
//  PerformableStepResult.swift
//  RouteComposer
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation
import UIKit

enum PerformableStepResult {

    case success(UIViewController)

    case build(AnyFactory)

    case none

}
