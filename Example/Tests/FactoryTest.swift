//
// Created by Eugene Kazaev on 11/09/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import RouteComposer

class FactoryTest: XCTestCase {

    func testClassNameFactoryByType() {
        let factory = ClassNameFactory<UITabBarController, Any?>()
        let viewController = try? factory.build()
        XCTAssertTrue(viewController != nil)
    }

    func testClassNameFactoryByName() {
        let factory = ClassNameFactory<UITabBarController, Any?>(viewControllerName: "UITabBarController")
        let viewController = try? factory.build()
        XCTAssertTrue(viewController != nil)
    }

    func testClassNameFactoryWrongName() {
        let factory = ClassNameFactory<UIViewController, Any?>(viewControllerName: "NSString")
        XCTAssertThrowsError(try factory.build())
    }

    func testClassNameFactoryWrongType() {
        let factory = ClassNameFactory<UINavigationController, Any?>(viewControllerName: "UITabBarController")
        XCTAssertThrowsError(try factory.build())
    }

    func testFinderFactory() {
        let navigationController = UINavigationController()
        let factory = FinderFactory<RouterTests.FakeClassFinder<UINavigationController, Any?>>(finder: RouterTests.FakeClassFinder(currentViewController: navigationController))
        XCTAssertEqual(try factory.build(with: nil), navigationController)
    }

    func testNilFactory() {
        let factory = NilFactory<UIViewController, Any?>()
        XCTAssertThrowsError(try factory.build())
    }

}
