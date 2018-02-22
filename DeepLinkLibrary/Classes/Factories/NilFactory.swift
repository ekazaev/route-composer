//
//  NilFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

public class NilFactory<VV: UIViewController, CC>: Factory {

    public typealias V = VV

    public typealias C = CC

    public let action: Action

    public init() {
        self.action = NilAction()
    }

    public func build(logger: Logger?) -> V? {
        return nil
    }
    
}
