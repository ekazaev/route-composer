//
// Created by Eugene Kazaev on 15/01/2018.
//

import Foundation
import UIKit
import RouteComposer

class ColorURLTranslator: ExampleURLTranslator {

    func destination(from url: URL) -> AnyDestination? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = urlComponents.queryItems,
              let colorItem = queryItems.first(where: { $0.name == "color" }),
              let colorValue = colorItem.value else {
            return nil
        }

        return Destination(to: ConfigurationHolder.configuration.colorScreen, with: colorValue).unwrapped()
    }

}
