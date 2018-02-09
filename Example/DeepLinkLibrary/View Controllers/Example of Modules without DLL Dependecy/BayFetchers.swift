//
// Created by Eugene Kazaev on 09/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation

class CategoriesFetcher: CategoriesFetching {
    func fetch(completion: @escaping ([CategoryProtocol]) -> Void) {
        let categories = (0..<5).map { Category(id: "\($0)", name: "Category \($0)") }
        completion(categories)
    }
}

class PAProductFetcher: ProductArrayProductFetching {
    func fetch(categoryId: String, withCompletion completion: @escaping ([ProductArrayProductProtocol]) -> Void) {
        let products = (0..<100).map {
            return Product(id: "\($0)", name: "Product(cat:\(categoryId) \($0)", price: "\($0).00 $")
        }
        completion(products)
    }
}