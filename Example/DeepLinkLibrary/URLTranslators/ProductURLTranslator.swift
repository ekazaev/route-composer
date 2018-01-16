//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation

class ProductURLTranslator: ExampleURLTranslator {

    func arguments(from url: URL) -> ExampleTargetArguments? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = urlComponents.queryItems,
              let item = queryItems.first(where: { $0.name == "product" }),
              let productIdValue = item.value else {
            return nil
        }

        return ExampleTargetArguments(originalUrl: url, arguments: [Argument.productId: productIdValue])
    }

}
