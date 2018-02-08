//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit
import Foundation

public protocol Router {

    var logger: Logger? { get }

    @discardableResult
    func deepLinkTo<A: RoutingDestination>(destination: A, animated: Bool, completion: ((_: Bool) -> Void)?) -> RoutingResult
}
