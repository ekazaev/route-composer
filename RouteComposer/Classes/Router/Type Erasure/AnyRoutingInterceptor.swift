//
// RouteComposer
// AnyRoutingInterceptor.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

protocol AnyRoutingInterceptor {

    mutating func prepare<Context>(with context: Context) throws

    func perform<Context>(with context: Context, completion: @escaping (_: RoutingResult) -> Void)

}

#endif
