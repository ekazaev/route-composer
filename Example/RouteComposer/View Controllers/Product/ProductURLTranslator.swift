//
// RouteComposer
// ProductURLTranslator.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

import Foundation
import RouteComposer
import UIKit

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
