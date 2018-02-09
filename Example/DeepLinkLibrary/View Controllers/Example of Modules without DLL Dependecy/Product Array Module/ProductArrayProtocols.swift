//
// Created by Eugene Kazaev on 09/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation

protocol ProductArrayProductFetching {
    func fetch(categoryId: String, withCompletion completion: @escaping ([ProductArrayProductProtocol]) -> Void)
}

public protocol ProductArrayProductProtocol {
    var id: String { get }

    var name: String { get }
    var price: String { get }
}

struct Product: ProductArrayProductProtocol {
    var id: String

    var name: String
    var price: String
}
