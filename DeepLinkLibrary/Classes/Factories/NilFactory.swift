//
//  NilFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

public class NilFactory<VC: UIViewController, C>: Factory {

    public typealias ViewController = VC

    public typealias Context = C

    public let action: Action

    public init() {
        self.action = NilAction()
    }

    public func build() -> FactoryBuildResult {
        return .failure("This factory should never reach router.")
    }
    
}
