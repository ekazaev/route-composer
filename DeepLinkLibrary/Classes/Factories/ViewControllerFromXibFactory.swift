//
//  ViewControllerFromXibFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 09/02/2018.
//

import Foundation
import UIKit

public class ViewControllerFromXibFactory<VC: UIViewController, C>: Factory {

    public typealias ViewController = VC

    public typealias Context = C

    public let action: Action

    private let nibName: String?
    public let bundle: Bundle?

    public init(nibName: String? = nil, bundle: Bundle? = nil, action: Action) {
        self.action = action
        self.nibName = nibName
        self.bundle = bundle
    }

    public func build(with context: Context?) throws -> UIViewController {
        let viewController = ViewController(nibName: nibName, bundle: bundle)
        return viewController
    }

}
