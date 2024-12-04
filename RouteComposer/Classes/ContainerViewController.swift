//
// RouteComposer
// ContainerViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// All the container view controllers should conform to this protocol.
///
/// All the methods `ContainerViewController` supports are implemented in corresponding `ContainerAdapter`
/// provided by `ContainerAdapterLocator`.
public protocol ContainerViewController: RoutingInterceptable {}
