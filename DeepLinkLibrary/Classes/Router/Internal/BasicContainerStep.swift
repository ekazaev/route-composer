//
//  StepResult.swift
//  DeepLinkLibrary
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation
import UIKit

/// Base class for steps that produces basic container steps.
public class BasicContainerStep<Container: ContainerViewController>: BasicStep {

    /// Creates a instance of the routing step that produces container view controller.
    ///
    /// - Parameters:
    ///   - finder: UIViewController finder.
    ///   - factory: UIViewController factory.
    override init<F: Finder, FC: Factory>(finder: F, factory: FC) where F.ViewController == FC.ViewController, F.Context == FC.Context, FC.ViewController == Container {
        super.init(finder: finder, factory: factory)
    }

}
