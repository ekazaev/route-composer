//
//  ContextTaskMultiplexer.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

class ContextTaskMultiplexer: AnyContextTask, CustomStringConvertible {

    private let tasks: [AnyContextTask]

    init(_ tasks: [AnyContextTask]) {
        self.tasks = tasks
    }

    func prepare(with context: Any?) throws {
        try self.tasks.forEach({ try $0.prepare(with: context) })
    }

    func apply(on viewController: UIViewController, with context: Any?) {
        self.tasks.forEach({ $0.apply(on: viewController, with: context) })
    }

    var description: String {
        return String(describing: tasks)
    }

}
