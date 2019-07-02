//
// Created by Eugene Kazaev on 2019-04-23.
//

import Foundation

/// Provides universal properties and methods of the `ContainerViewController` instance.
public protocol ConcreteContainerAdapter: ContainerAdapter {

    /// Type of `ContainerViewController`
    associatedtype Container: ContainerViewController

    /// Constructor
    init(with viewController: Container)

}
