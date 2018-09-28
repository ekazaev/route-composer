//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

class ColorURLTranslator: ExampleURLTranslator {

    func destination(from url: URL) -> ExampleDestination<UIViewController, Any?>? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = urlComponents.queryItems,
              let colorItem = queryItems.first(where: { $0.name == "color" }),
              let colorValue = colorItem.value else {
            return nil
        }

        return ExampleDestination(step: ConfigurationHolder.configuration.colorScreen, context: colorValue).unsafelyUnwrapped()
    }

}
