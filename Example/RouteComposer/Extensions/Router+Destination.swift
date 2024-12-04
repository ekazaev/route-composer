//
// RouteComposer
// Router+Destination.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

/// Simple extension to support `Destination` instance directly by the `Router`.
extension Router {

    @MainActor func navigate<Context>(to step: DestinationStep<some UIViewController, Context>, with context: Context) throws {
        try navigate(to: step, with: context, animated: true, completion: nil)
    }

}
