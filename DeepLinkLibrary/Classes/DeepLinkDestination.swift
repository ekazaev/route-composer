//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation

public protocol DeepLinkDestination {

    associatedtype A

    var screen: DeepLinkableScreen { get }

    var arguments: A? { get }

}
