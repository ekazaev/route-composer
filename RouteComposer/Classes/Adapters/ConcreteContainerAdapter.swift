//
// Created by Eugene Kazaev on 2019-04-23.
//

#if os(iOS)

import Foundation

/// Provides universal properties and methods of the `ContainerViewController` instance.
public protocol ConcreteContainerAdapter: ContainerAdapter {

    // MARK: Associated types

    /// Type of `ContainerViewController`
    associatedtype Container: ContainerViewController

    // MARK: Methods to implement

    /// Constructor
    init(with viewController: Container)

}

#endif
