//
// Created by Eugene Kazaev on 25/07/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit
import XCTest
@testable import RouteComposer

class ActionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
 
    func testNavReplacingLast() {
        var viewControllerStack:[UIViewController] = []
        NavigationControllerFactory.PushReplacingLast().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
    
        NavigationControllerFactory.PushReplacingLast().perform(embedding: UINavigationController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
        XCTAssert(viewControllerStack.first!.isKind(of: UINavigationController.self))
    }
    
    func testNavPushAsRoot() {
        var viewControllerStack:[UIViewController] = []
        NavigationControllerFactory.PushAsRoot().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
        
        NavigationControllerFactory.PushAsRoot().perform(embedding: UINavigationController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
        XCTAssert(viewControllerStack.first!.isKind(of: UINavigationController.self))
    }

    func testNavPushToNavigation() {
        var viewControllerStack:[UIViewController] = []
        NavigationControllerFactory.PushToNavigation().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
        
        NavigationControllerFactory.PushToNavigation().perform(embedding: UINavigationController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 2)
        XCTAssert(viewControllerStack.last!.isKind(of: UINavigationController.self))
        XCTAssert(viewControllerStack.first!.isKind(of: UIViewController.self))
    }
    
    func testTabAddTab() {
        var viewControllerStack:[UIViewController] = []
        TabBarControllerFactory.AddTab().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
    
        TabBarControllerFactory.AddTab().perform(embedding: UINavigationController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 2)
        XCTAssert(viewControllerStack.first!.isKind(of: UIViewController.self))
        XCTAssert(viewControllerStack.last!.isKind(of: UINavigationController.self))
    }

    func testTabAddTabAt() {
        var viewControllerStack:[UIViewController] = []
        TabBarControllerFactory.AddTab(at: 1).perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
    
        TabBarControllerFactory.AddTab(at: 0).perform(embedding: UINavigationController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 2)
        XCTAssert(viewControllerStack.first!.isKind(of: UINavigationController.self))
        XCTAssert(viewControllerStack.last!.isKind(of: UIViewController.self))
    }
    
    func testTabAddTabReplacing() {
        var viewControllerStack:[UIViewController] = []
        TabBarControllerFactory.AddTab(at: 1, replacing: true).perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
    
        TabBarControllerFactory.AddTab(at: 0, replacing: true).perform(embedding: UINavigationController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
        XCTAssert(viewControllerStack.first!.isKind(of: UINavigationController.self))
    }
    
    func testNilAction() {
        var viewControllerStack:[UIViewController] = []
        GeneralAction.NilAction().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 0)
    }
    
}
