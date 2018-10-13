//
//  NilFactory.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

struct NilFactory<VC: UIViewController, C>: Factory, NilEntity {

    typealias ViewController = VC

    typealias Context = C

    /// Constructor
    init() {
    }

    func build(with context: Context) throws -> ViewController {
        throw RoutingError.compositionFailed(RoutingError.Context(debugDescription: "This factory should never reach the router."))
    }

}
