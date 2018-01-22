//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation

public protocol DeepLinkDestination {

    var assembly: DeepLinkableViewControllerAssembly { get }

    var arguments: Any? { get }

}
