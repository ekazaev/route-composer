//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation

class ProductURLTranslator: ExampleURLTranslator {

    let config: ExampleConfiguration

    init(_ config: ExampleConfiguration) {
        self.config = config
    }

    func destination(from url: URL) -> ExampleDestination? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = urlComponents.queryItems,
              let item = queryItems.first(where: { $0.name == "product" }),
              let productIdValue = item.value,
              let screen = config.screen(for: ExampleTarget.product) else {
            return nil
        }

        return ExampleDestination(screen: screen,
                arguments: ExampleDictionaryArguments(originalUrl: url, arguments: [Argument.productId: productIdValue]))
    }

}
