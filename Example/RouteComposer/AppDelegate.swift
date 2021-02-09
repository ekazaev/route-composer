//
// RouteComposer
// AppDelegate.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

import OSLog
import RouteComposer
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        RouteComposerDefaults.configureWith(logger: DefaultLogger(.verbose, osLog: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Router")))
        ConfigurationHolder.configuration = ExampleConfiguration()

        // Try in mobile Safari to test the deep linking to the app:
        // Try it when you are on any screen in the app to check that you will always land where you have to be
        // depending on the configuration provided.
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

        do {
            try UIViewController.router.navigate(to: destination)
            return true
        } catch {
            return false
        }
    }

}
