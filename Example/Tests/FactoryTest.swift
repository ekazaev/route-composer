//
// Created by Eugene Kazaev on 11/09/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
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
        XCTAssertEqual(try factory?.build(with: nil), navigationController)

        struct NothingFinder<VC: UIViewController, C>: Finder {
            func findViewController(with context: C) -> VC? {
                return nil
            }
        }
        let throwsFactory = FinderFactory<NothingFinder<UIViewController, Any?>>(finder: NothingFinder())
        XCTAssertThrowsError(try throwsFactory?.build(with: nil))
    }

    func testNilFactory() {
        var factory = NilFactory<UIViewController, Any?>()
        XCTAssertThrowsError(try factory.prepare())
        XCTAssertThrowsError(try factory.build())
        XCTAssertThrowsError(try factory.buildPrepared())
    }

    func testBuildPreparedFactory() {

        var prepareCount = 0
        var buildCount = 0

        class TestFactory: Factory {

            typealias ViewController = UIViewController

            typealias Context = Any?

            var prepareBlock: () -> Void

            var buildBlock: () -> Void

            init(prepareBlock: @escaping () -> Void, buildBlock: @escaping () -> Void) {
                self.buildBlock = buildBlock
                self.prepareBlock = prepareBlock
            }

            func prepare(with context: Any?) throws {
                prepareBlock()
            }

            func build(with context: Any?) throws -> UIViewController {
                buildBlock()
                return UIViewController()
            }

        }
        let factory = TestFactory(prepareBlock: { prepareCount += 1 }, buildBlock: { buildCount += 1 })
        XCTAssertNoThrow(try factory.buildPrepared(with: nil))
        XCTAssertEqual(prepareCount, 1)
        XCTAssertEqual(buildCount, 1)

        XCTAssertNoThrow(try factory.buildPrepared())
        XCTAssertEqual(prepareCount, 2)
        XCTAssertEqual(buildCount, 2)
    }

    func testDelayedIntegrationFactory() {
        var viewControllerStack: [UIViewController] = []
        let factory = ClassNameFactory<UIViewController, Any?>()
        var delayedFactory = DelayedIntegrationFactory<Any?>(FactoryBox(factory, action: ContainerActionBox(UINavigationController.push()))!)
        XCTAssertNoThrow(try delayedFactory.prepare(with: nil))
        XCTAssertNoThrow(try delayedFactory.build(with: nil, in: &viewControllerStack))
        XCTAssertEqual(viewControllerStack.count, 1)
        XCTAssertEqual(delayedFactory.description, "ClassNameFactory<UIViewController, Optional<Any>>(viewControllerName: nil, nibName: nil, bundle: nil)")
    }

}
