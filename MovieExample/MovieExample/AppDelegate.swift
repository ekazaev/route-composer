//
//  AppDelegate.swift
//  MovieExample
//
//  Created by Eugene Kazaev on 21/08/2019.
//  Copyright © 2019 Eugene Kazaev. All rights reserved.
//

import UIKit
import UpdatableTableViewController
import CustomTabViewController
import MovieTableViewCell
import MovieListController
import MovieSearchResultUpdater
import MovieDetailViewController
import RouteComposer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let searchResultUpdater = MovieSearchResultUpdater()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let detailController = try! StoryboardFactory<MovieDetailViewController, Any?>(name: "MovieDetailViewController", bundle: Bundle(for: MovieDetailViewController.self)).execute()

        let tabBarController = CustomTabViewController(nibName: "CustomTabViewController", bundle: Bundle(for: CustomTabViewController.self))
        let tableViewController = UpdatableTableViewController<MovieListController, MovieTableViewCell>()
        tableViewController.controller = MovieListController(type: .popular)
        let tableViewController1 = UpdatableTableViewController<MovieListController, MovieTableViewCell>()
        tableViewController1.controller = MovieListController(type: .upcoming)
        tabBarController.viewControllers = [tableViewController, tableViewController1, detailController]
        let navigationController = UINavigationController(rootViewController: tabBarController)

        let searchResultsViewController = UpdatableTableViewController<MovieSearchResultController, MovieTableViewCell>()
        let movieSearchResultController = MovieSearchResultController()
        searchResultsViewController.controller = movieSearchResultController

        let searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchResultUpdater.delegate = movieSearchResultController
        searchController.searchResultsUpdater = searchResultUpdater

        tabBarController.navigationItem.searchController = searchController
        tabBarController.definesPresentationContext = true
        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

