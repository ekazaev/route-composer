//
//  NilFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

/// Dummy class to be provided to an assembly to show that this step should not have any factories
/// The only purpose it exist is to provide type safety checks for ScreenStepAssembly.
///
/// For example UIViewController of this step was already loaded and integrated in to a stack by a storyboard.
public class NilFactory<VC: UIViewController, C>: Factory {

    public typealias ViewController = VC

    public typealias Context = C

    public let action: Action

    public init() {
        self.action = NilAction()
    }

    public func build(with context: Context?) throws -> ViewController {
        throw RoutingError.message("This factory should never reach router.")
    }

}
