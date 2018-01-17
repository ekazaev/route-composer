//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

public protocol DeepLinkableScreen {

    var step: Step { get }

}

public class Screen: DeepLinkableScreen {

    let originalStep: Step

    public var step: Step {
        get {
            if let finder = finder {
                return FinderStep(finder: finder, prevStep: originalStep, factory: factory)
            } else if let factory = factory {
                return FactoryStep(prevStep: originalStep, factory: factory)
            }
            return originalStep
        }
    }

    let finder: DeepLinkFinder?

    let factory: Factory?

    public init(finder: DeepLinkFinder? = nil, factory: Factory? = nil, step: Step) {
        self.originalStep = step
        self.finder = finder
        self.factory = factory
    }

}

class FactoryStep: Step {

    let factory: Factory?

    let prevStep: Step?

    init(prevStep: Step?, factory: Factory) {
        self.prevStep = prevStep
        self.factory = factory
    }

    func getPresentationViewController(with arguments: Any?) -> UIViewController? {
        return nil
    }
}

class FinderStep: Step {

    class FinderFactory: Factory, PreparableFactory {

        var action: Action? = nil

        let finder: DeepLinkFinder

        var arguments: Any?

        init(finder: DeepLinkFinder) {
            self.finder = finder
        }

        func prepare(with arguments: Any?) -> DeepLinkResult {
            self.arguments = arguments
            return .handled
        }

        func build() -> UIViewController? {
            return finder.findViewController(with: arguments)
        }
    }

    let factory: Factory?

    let prevStep: Step?

    let finder: DeepLinkFinder

    init(finder: DeepLinkFinder, prevStep: Step?, factory: Factory?) {
        self.finder = finder
        self.prevStep = prevStep
        self.factory = factory ?? FinderFactory(finder: finder)
    }

    func getPresentationViewController(with arguments: Any?) -> UIViewController? {
        return finder.findViewController(with: arguments)
    }
}

