//
// Created by Eugene Kazaev on 16/01/2018.
//

import Foundation
import UIKit
import RouteComposer

class ProductURLTranslator: ExampleURLTranslator {

    func destination(from url: URL) -> AnyDestination? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = urlComponents.queryItems,
              let item = queryItems.first(where: { $0.name == "product" }),
              let productIdValue = item.value else {
            return nil
        }

        return Destination(to: ProductConfiguration.productScreen, with: ProductContext(productId: productIdValue, productURL: url)).unwrapped()
    }

}
