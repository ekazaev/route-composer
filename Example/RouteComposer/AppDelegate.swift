//
//  AppDelegate.swift
//  CircumferenceKit
//
//  Created by Eugene Kazaev on 18/12/2017.
//  Copyright © 2017 HBC Tech. All rights reserved.
//

import UIKit
import RouteComposer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        ExampleConfiguration.wireframe = ExampleWireframeImpl()

        // Try in mobile Safari:
        //
        // dll://colors?color=AABBCC
        // dll://products?product=01
        // dll://cities?city=01
        ExampleUniversalLinksManager.configure()

        return true
    }

    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        guard let destination = ExampleUniversalLinksManager.destination(for: url) else {
            return false
        }

        return DefaultRouter(logger: nil).navigate(to: destination) == .handled
    }

}
