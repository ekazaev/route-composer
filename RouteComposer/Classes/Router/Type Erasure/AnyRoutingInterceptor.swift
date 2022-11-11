//
// RouteComposer
// AnyRoutingInterceptor.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
import UIKit

protocol AnyRoutingInterceptor {

    mutating func prepare(with context: Any?) throws

    func perform(with context: Any?, completion: @escaping (_: RoutingResult) -> Void)

}
