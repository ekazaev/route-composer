//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import DeepLinkLibrary

class ExampleConfiguration {

    private struct Box {
        let screen: DeepLinkableScreen
        let urlTranslator: ExampleURLTranslator?
    }

    private var screens: [AnyHashable: Box] = [:]

    func provider(for target: ExampleTarget) -> RequiredScreenProvider {
        return {
            self.screen(for: target)
        }
    }

    func screen<T: Hashable>(for target: T) -> DeepLinkableScreen? {
        return screens[target]?.screen
    }

    func register<T: Hashable>(screen: DeepLinkableScreen, urlTranslator: ExampleURLTranslator? = nil, for target: T) {
        screens[target] = Box(screen: screen, urlTranslator: urlTranslator)
    }


    func destination<T: Hashable>(for target: T, arguments: ExampleTargetArguments? = nil) -> ExampleDestination? {
        guard let screen = screen(for: target) else {
            return nil
        }

        return ExampleDestination(screen: screen, arguments: arguments)
    }

    func destination(for url: URL) -> ExampleDestination? {
        guard let box = screens.first(where: { $1.urlTranslator?.arguments(from: url) != nil })?.value  else {
            return nil
        }

        return ExampleDestination(screen: box.screen, arguments: box.urlTranslator?.arguments(from: url))
    }
}



