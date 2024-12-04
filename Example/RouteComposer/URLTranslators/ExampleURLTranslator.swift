//
// RouteComposer
// ExampleURLTranslator.swift
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

protocol ExampleURLTranslator {

    @MainActor func destination(from url: URL) -> AnyDestination?

}
