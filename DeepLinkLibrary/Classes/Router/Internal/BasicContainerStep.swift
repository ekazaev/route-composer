//
//  StepResult.swift
//  DeepLinkLibrary
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation
import UIKit

/// Base class for steps that produces basic container steps.
public class BasicContainerStep<F: Finder, FC: Factory, Container: ContainerViewController>: BasicStep<F, FC> where F.ViewController == FC.ViewController, F.Context == FC.Context, FC.ViewController == Container{

    /// Creates a instance of the routing step that produces container view controller.
    ///
    /// - Parameters:
    ///   - finder: UIViewController finder.
    ///   - factory: UIViewController factory.
    override init(finder: F, factory: FC) {
        super.init(finder: finder, factory: factory)
    }

}
