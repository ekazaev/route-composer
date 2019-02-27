//
// Created by Eugene Kazaev on 08/09/2018.
//

import Foundation
import UIKit

protocol DelayedActionIntegrationHandler: AnyObject {

    var containerViewController: ContainerViewController? { get }

    var delayedViewControllers: [UIViewController] { get }

    func update(containerViewController: ContainerViewController, animated: Bool, completion: @escaping () -> Void)

    func update(delayedViewControllers: [UIViewController])

    func purge(animated: Bool, completion: @escaping () -> Void)

}

protocol AnyAction {

    func perform(with viewController: UIViewController,
                 on existingController: UIViewController,
                 with delayedIntegrationHandler: DelayedActionIntegrationHandler,
                 nextAction: AnyAction?,
                 animated: Bool,
                 completion: @escaping (_: ActionResult) -> Void)

    func perform(embedding viewController: UIViewController,
                 in childViewControllers: inout [UIViewController]) throws

    func isEmbeddable(to container: ContainerViewController.Type) -> Bool

}
