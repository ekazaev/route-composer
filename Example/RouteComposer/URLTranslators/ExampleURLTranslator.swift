//
// RouteComposer
// ExampleURLTranslator.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

import Foundation
import RouteComposer
import UIKit

protocol ExampleURLTranslator {

    func destination(from url: URL) -> AnyDestination?

}
