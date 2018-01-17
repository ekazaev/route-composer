//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public protocol Factory: class {

    var action: Action? { get }

    func build() -> UIViewController?

}

public protocol PreparableFactory {

    func prepare(with arguments: Any?) -> DeepLinkResult

}

public protocol ContainerFactory: Factory {

    func merge(_ screenFactories: [Factory]) -> [Factory]

}
