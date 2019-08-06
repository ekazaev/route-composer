//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

///  The `ContainerFactory` that creates a `UITabBarController` instance.
public struct TabBarControllerFactory<VC: UITabBarController, C>: ContainerFactory {

    public typealias ViewController = VC

    public typealias Context = C

    /// A Xib file name
    public let nibName: String?

    /// A `Bundle` instance
    public let bundle: Bundle?

    /// `UITabBarControllerDelegate` reference
    private(set) public weak var delegate: UITabBarControllerDelegate?

    /// The additional configuration block
    public let configuration: ((_: VC) -> Void)?

    /// Constructor
    public init(nibName nibNameOrNil: String? = nil,
                bundle nibBundleOrNil: Bundle? = nil,
                delegate: UITabBarControllerDelegate? = nil,
                configuration: ((_: VC) -> Void)? = nil) {
        self.nibName = nibNameOrNil
        self.bundle = nibBundleOrNil
        self.delegate = delegate
        self.configuration = configuration
    }

    public func build(with context: C, integrating coordinator: ChildCoordinator<C>) throws -> VC {
        let tabBarController = VC(nibName: nibName, bundle: bundle)
        if let delegate = delegate {
            tabBarController.delegate = delegate
        }
        if let configuration = configuration {
            configuration(tabBarController)
        }
        if !coordinator.isEmpty {
            tabBarController.viewControllers = try coordinator.build(with: context, integrating: tabBarController.viewControllers ?? [])
        }
        return tabBarController
    }

}
