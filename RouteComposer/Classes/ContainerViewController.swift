//
//  ContainerViewController.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// All the container view controllers should conform to this protocol.
///
/// All the methods `ContainerViewController` supports are implemented in corresponding `ContainerAdapter`
/// provided by `ContainerAdapterLocator`.
public protocol ContainerViewController: RoutingInterceptable {

}
