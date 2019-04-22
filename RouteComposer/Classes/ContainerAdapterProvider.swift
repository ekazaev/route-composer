//
// Created by Eugene Kazaev on 2019-04-22.
//

import Foundation

/// Provides universal `ContainerAdapter` instance.
public protocol ContainerAdapterProvider {

    /// Returns the `ContainerAdapter` suitable for the `ContainerViewController`
    ///
    /// - Parameter containerViewController: The `ContainerViewController` instance
    /// - Returns: Suitable `ContainerAdapter` instance
    /// - Throws: `RoutingError` if the suitable `ContainerAdapter` can not be provided
    func getAdapter(for containerViewController: ContainerViewController) throws -> ContainerAdapter

}
