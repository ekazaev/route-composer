//
// Created by Eugene Kazaev on 09/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation

public protocol CategoriesViewControllerDelegate: class {
    func showCategory(for categoryId:String)
}

struct Category: CategoryProtocol {
    var id: String
    var name: String
}

protocol CategoriesFetching {
    func fetch(completion: @escaping ([CategoryProtocol]) -> Void)
}
