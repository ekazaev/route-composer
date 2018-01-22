//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import DeepLinkLibrary

class ExampleConfiguration {

    private static var assemblies: [AnyHashable: DeepLinkableViewControllerAssembly] = [:]

    static func assembly<T: Hashable>(for target: T) -> DeepLinkableViewControllerAssembly? {
        return assemblies[target]
    }

    static func register<T: Hashable>(assembly: DeepLinkableViewControllerAssembly, for target: T) {
        assemblies[target] = assembly
    }


    static func destination<T: Hashable>(for target: T, arguments: ExampleDictionaryArguments? = nil) -> ExampleDestination? {
        guard let assembly = assembly(for: target) else {
            return nil
        }

        return ExampleDestination(assembly: assembly, arguments: arguments ?? ExampleDictionaryArguments())
    }
}



