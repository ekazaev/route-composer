//
// Created by Eugene Kazaev on 2018-09-18.
//

import Foundation
import UIKit

// MARK: Actions for UISplitViewController

public extension ContainerViewController where Self: UISplitViewController {

    /// Presents a view controller as a master in the `UISplitViewController`
    static func setAsMaster() -> SplitViewControllerActions.SetAsMasterAction<Self> {
        return SplitViewControllerActions.SetAsMasterAction()
    }

    /// Presents a view controller as a detail in the `UISplitViewController`, *replacing* the previous detail.
    static func pushToDetails() -> SplitViewControllerActions.PushToDetailsAction<Self> {
        return SplitViewControllerActions.PushToDetailsAction()
    }

    /// Pushes a view controller *onto* the detail stack in the `UISplitViewController`
    static func pushOnToDetails() -> RouteComposer.SplitViewControllerActions.PushOnToDetailsAction<Self> {
      return SplitViewControllerActions.PushOnToDetailsAction()
    }
}

/// Actions for `UISplitViewController`
public struct SplitViewControllerActions {

    /// Presents a master view controller in the `UISplitViewController`
    public struct SetAsMasterAction<ViewController: UISplitViewController>: ContainerAction {

        /// Constructor
        init() {
        }

        public func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) throws {
            integrate(viewController: viewController, in: &childViewControllers)
        }

        public func perform(with viewController: UIViewController,
                            on splitViewController: ViewController,
                            animated: Bool,
                            completion: @escaping (_: RoutingResult) -> Void) {
            integrate(viewController: viewController, in: &splitViewController.viewControllers)
            completion(.success)
        }

        private func integrate(viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
            if childViewControllers.isEmpty {
                childViewControllers.append(viewController)
            } else {
                childViewControllers[0] = viewController
            }
        }

    }

    /// Presents a detail view controller in the `UISplitViewController`, *replacing* the previous detail.
    public struct PushToDetailsAction<ViewController: UISplitViewController>: ContainerAction {

        /// Constructor
        init() {
        }

        public func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) throws {
            guard !childViewControllers.isEmpty else {
                throw RoutingError.compositionFailed(.init("Master view controller is not set in " +
                        "UISplitViewController to present a detail view controller \(viewController)."))
            }
            childViewControllers.append(viewController)
        }

        public func perform(with viewController: UIViewController,
                            on splitViewController: ViewController,
                            animated: Bool,
                            completion: @escaping (_: RoutingResult) -> Void) {
            guard !splitViewController.viewControllers.isEmpty else {
                completion(.failure(RoutingError.compositionFailed(.init("Master view controller is not set in " +
                        "\(splitViewController) to present a detail view controller \(viewController)."))))
                return
            }

            splitViewController.showDetailViewController(viewController, sender: nil)
            completion(.success)
        }
    }

    /// Pushes a view controller *onto* the detail stack in the `UISplitViewController`, where the detail is a `UINavigationController`
    public struct PushOnToDetailsAction<ViewController: UISplitViewController>: ContainerAction {

      /// Constructor
      init() {
      }

      public func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) throws {
        guard !childViewControllers.isEmpty else {
          throw RoutingError.compositionFailed(.init("Master view controller is not set in " +
            "UISplitViewController to push on a detail view controller \(viewController)."))
        }
        childViewControllers.append(viewController)
      }

      public func perform(with viewController: UIViewController,
                          on splitViewController: ViewController,
                          animated: Bool,
                          completion: @escaping (_: RoutingResult) -> Void) {
        guard !splitViewController.viewControllers.isEmpty else {
          completion(.failure(RoutingError.compositionFailed(.init("Master view controller is not set in " +
            "\(splitViewController) to push on a detail view controller \(viewController)."))))
          return
        }

        guard let navController = (splitViewController.viewControllers.last as? UINavigationController) else {
          completion(.failure(RoutingError.compositionFailed(.init("Detail navigation controller is not set in " +
            "\(splitViewController) to push on a detail view controller \(viewController)."))))
          return
        }

        navController.pushViewController(viewController, animated: animated)
        completion(.success)
      }
    }

}

