//
// RouteComposer
// KeyWindowProvider.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

/// Returns key `UIWindow`
public struct KeyWindowProvider: WindowProvider {

    // MARK: Properties
    
    public static let appWindowTag = 9999

    /// `UIWindow` instance  /// returns the window with the appWindowTag
    public var window: UIWindow? {
        let keyWindow: UIWindow?
        if #available(iOS 13, *) {
            let taggedWindow = UIApplication.shared.windows.first { $0.tag == KeyWindowProvider.appWindowTag }
            if taggedWindow == nil {
                keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            } else {
                keyWindow = taggedWindow
            }
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
        guard let window = keyWindow else {
            //assertionFailure("Application does not have a key window.")
            return nil
        }
        return window
    }
    
    public var keyWindow: UIWindow? {
        let keyWindow: UIWindow?
        if #available(iOS 13, *) {
            keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
        guard let window = keyWindow else {
            //assertionFailure("Application does not have a key window.")
            return nil
        }
        return window
    }

    // MARK: Methods

    /// Constructor
    public init() {}

}

#endif
