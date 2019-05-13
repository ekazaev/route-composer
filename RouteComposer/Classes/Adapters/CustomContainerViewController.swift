//
// Created by Eugene Kazaev on 2019-05-13.
//

import Foundation
import UIKit

/// Custom `ContainerViewController`s created outside of the library should extend this protocol, so `DefaultContainerAdapterProvider`
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

    /// `ContainerAdapter` to be provided by `DefaultContainerAdapterProvider`
    var adapter: ContainerAdapter { get }

}
