//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import DeepLinkLibrary

class ExampleConfiguration {

    private var screens: [AnyHashable: DeepLinkableScreen] = [:]

    func screen<T: Hashable>(for target: T) -> DeepLinkableScreen? {
        return screens[target]
    }

    func register<T: Hashable>(screen: DeepLinkableScreen, for target: T) {
        screens[target] = screen
    }


    func destination<T: Hashable>(for target: T, arguments: ExampleDictionaryArguments? = nil) -> ExampleDestination? {
        guard let screen = screen(for: target) else {
            return nil
        }

        return ExampleDestination(screen: screen, arguments: arguments ?? ExampleDictionaryArguments())
    }
}



