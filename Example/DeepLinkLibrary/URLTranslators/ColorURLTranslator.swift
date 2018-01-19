//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation

class ColorURLTranslator: ExampleURLTranslator {

    let config: ExampleConfiguration

    init(_ config: ExampleConfiguration) {
        self.config = config
    }

    func destination(from url: URL) -> ExampleDestination? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = urlComponents.queryItems,
              let colorItem = queryItems.first(where: { $0.name == "color" }),
              let colorValue = colorItem.value,
              let screen = config.screen(for: ExampleTarget.color) else {
            return nil
        }

        return ExampleDestination(screen: screen,
                arguments: ExampleDictionaryArguments(originalUrl: url, arguments: [Argument.color: colorValue]))
    }

}
