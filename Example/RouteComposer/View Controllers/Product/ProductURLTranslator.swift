//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

class ProductURLTranslator: ExampleURLTranslator {

    func destination(from url: URL) -> ExampleDestination<UIViewController, Any?>? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = urlComponents.queryItems,
              let item = queryItems.first(where: { $0.name == "product" }),
              let productIdValue = item.value else {
            return nil
        }

        return ExampleDestination(step: ProductConfiguration.productScreen, context: ProductContext(productId: productIdValue, productURL: url)).unwrapped()
    }

}
