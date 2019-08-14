//
// Created by Eugene Kazaev on 2019-04-22.
//

import Foundation
import UIKit

/// Default `ContainerAdapter` for `UISplitViewController`
public struct SplitControllerAdapter<VC: UISplitViewController>: ConcreteContainerAdapter {

    // MARK: Properties

    weak var splitViewController: VC?

    // MARK: Methods

    public init(with splitViewController: VC) {
        self.splitViewController = splitViewController
    }

    public var containedViewControllers: [UIViewController] {
        return splitViewController?.viewControllers ?? []
    }

    /// ###NB
    /// `UISplitViewController` does not support showing primary view controller overlay programmatically out of the box in `primaryOverlay`
    /// mode. So all the contained view controllers are considered as visible in the default implementation.
    public var visibleViewControllers: [UIViewController] {
        return containedViewControllers
    }

    /// ###NB
    /// `UISplitViewController` does not support showing primary view controller overlay programmatically out of the box in `primaryOverlay`
    /// mode, so default implementation of `makeVisible` method wont be able to serve it.
    public func makeVisible(_ viewController: UIViewController, animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
        guard splitViewController != nil else {
            return completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: VC.self)) has been deallocated"))))
        }
        guard contains(viewController) else {
            completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: splitViewController)) does not contain \(String(describing: viewController))"))))
            return
        }
        completion(.success)
    }

    /// Replacing of the child view controllers is not fully supported by the implementation of `UISplitViewController`.
    /// Only some common cases are covered by this method.
    ///
    /// ###NB
    /// [https://developer.apple.com/documentation/uikit/uisplitviewcontroller](https://developer.apple.com/documentation/uikit/uisplitviewcontroller):
    /// **Quote:** When designing your split view interface, it is best to install primary and secondary view controllers that do not change.
    /// A common technique is to install navigation controllers in both positions and then push and pop new content as needed.
    public func setContainedViewControllers(_ containedViewControllers: [UIViewController], animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
        guard let splitViewController = splitViewController else {
            return completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: VC.self)) has been deallocated"))))
        }
        if containedViewControllers.count > 1,
           let primaryViewController = self.containedViewControllers.first,
           primaryViewController === containedViewControllers.first,
           let detailsViewController = containedViewControllers.last {
            splitViewController.showDetailViewController(detailsViewController, sender: self)
        } else {
            splitViewController.viewControllers = containedViewControllers
        }
        completion(.success)
    }

}
