//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// Base router step implementation that handles all step protocols.
public class ContainerStep<Container: ContainerViewController>: BaseStep {

    /// Creates a instance of the routing step that produces container view controller.
    ///
    /// - Parameters:
    ///   - finder: UIViewController finder.
    ///   - factory: UIViewController factory.
    public init<F: Finder, FC: Factory>(finder: F, factory: FC) where F.ViewController == FC.ViewController, F.Context == FC.Context, FC.ViewController == Container {
        super.init(finder: finder, factory: factory)
    }

}
