//
//  AnyContextTask.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

protocol AnyContextTask {

    func apply(on viewController: UIViewController, with context: Any)

}

class ContextTaskBox<CT: ContextTask>: AnyContextTask {

    let contextTask: CT

    init(_ contextTask: CT) {
        self.contextTask = contextTask
    }

    func apply(on viewController: UIViewController, with context: Any) {
        guard let typedViewController = viewController as? CT.ViewController,
              let typedContext = context as? CT.Context else {
            return
        }
        contextTask.apply(on: typedViewController, with: typedContext)
    }

}
