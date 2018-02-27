//
//  ContextTaskMultiplexer.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

class ContextTaskMultiplexer: AnyContextTask {

    private let tasks: [AnyContextTask]

    init(_ tasks: [AnyContextTask]) {
        self.tasks = tasks
    }

    func apply(on viewController: UIViewController, with context: Any) {
        self.tasks.forEach({ $0.apply(on: viewController, with: context) })
    }
}
