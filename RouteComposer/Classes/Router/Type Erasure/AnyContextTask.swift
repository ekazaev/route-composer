//
//  AnyContextTask.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

protocol AnyContextTask {

    mutating func prepare<Context>(with context: Context) throws

    func perform<Context>(on viewController: UIViewController, with context: Context) throws

}
