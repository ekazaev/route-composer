//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation

class ColorURLTranslator: ExampleURLTranslator {

    func arguments(from url: URL) -> ExampleTargetArguments? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = urlComponents.queryItems,
              let colorItem = queryItems.first(where: { $0.name == "color" }),
              let colorValue = colorItem.value else {
            return nil
        }

        return ExampleTargetArguments(originalUrl: url, arguments: [Argument.color: colorValue])
    }

}
