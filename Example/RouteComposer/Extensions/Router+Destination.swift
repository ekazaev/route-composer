//
// Created by Eugene Kazaev on 2018-10-10.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

/// Simple extension to support `Destination` instance directly by the `Router`.
extension Router {

    func navigate<VC: UIViewController, C>(to destination: Destination<VC, C>, animated: Bool = true, completion: ((_: RoutingResult) -> Void)? = nil) throws {
        try self.navigate(to: destination.step, with: destination.context, animated: animated, completion: completion)
    }

    func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>, with context: Context) throws {
        try self.navigate(to: step, with: context, animated: true, completion: nil)
    }

}
