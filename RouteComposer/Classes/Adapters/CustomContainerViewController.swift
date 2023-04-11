//
// RouteComposer
// CustomContainerViewController.swift
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

/// Custom `ContainerViewController`s created outside of the library should extend this protocol, so `DefaultContainerAdapterLocator`
/// could provide their `ContainerAdapter` to the `DefaultRouter` and other library's instances when needed.
///
/// **NB:** If you want to substitute the `ContainerAdapter` for the container view controllers that are handled by library such as
/// `UINavigationController` you may create the extensions for such container view controllers in your project.
/// ```swift
///  public extension UINavigationController: CustomContainerViewController {
///
///      var adapter: ContainerAdapter {
///          return CustomNavigationAdapter(with: self)
///      }
///
///  }
/// ```
public protocol CustomContainerViewController: ContainerViewController {

    // MARK: Properties to implement

    /// `ContainerAdapter` to be provided by `DefaultContainerAdapterLocator`
    var adapter: ContainerAdapter { get }

}
