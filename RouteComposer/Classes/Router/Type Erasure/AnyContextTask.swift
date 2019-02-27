//
//  AnyContextTask.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

protocol AnyContextTask {

    mutating func prepare(with context: Any?) throws

    func apply(on viewController: UIViewController, with context: Any?) throws

}
