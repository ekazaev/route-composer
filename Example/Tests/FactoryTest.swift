//
// RouteComposer
// FactoryTest.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
@testable import RouteComposer
import UIKit
import XCTest

class FactoryTest: XCTestCase {

    func testClassFactoryByType() {
        let factory = ClassFactory<UITabBarController, Any?>(configuration: { viewController in
            viewController.setViewControllers([UIViewController(), UINavigationController()], animated: false)
        })
        let viewController = try? factory.build()
        XCTAssertTrue(viewController != nil)
        XCTAssertEqual(viewController?.viewControllers?.count, 2)
    }

    func testStoryboardFactory() {
        var wasInCompletion = false
        var builtViewController: UIViewController?
        let factory = StoryboardFactory<UIViewController, Any?>(name: "TestStoryboard",
                                                                bundle: Bundle(for: FactoryTest.self),
                                                                identifier: "TestViewController",
                                                                configuration: { viewController in
                                                                    wasInCompletion = true
                                                                    builtViewController = viewController
                                                                })
        XCTAssertEqual(factory.identifier, "TestViewController")
        XCTAssertEqual(factory.name, "TestStoryboard")
        XCTAssertNotNil(factory.configuration)
        XCTAssertNotNil(factory.bundle?.bundleIdentifier)
        XCTAssertEqual(try? factory.build(), builtViewController)
        XCTAssertTrue(wasInCompletion)
    }

    func testStoryboardFactoryWrongType() {
        let factory = StoryboardFactory<UINavigationController, Any?>(name: "TestStoryboard", bundle: Bundle(for: FactoryTest.self))
        XCTAssertThrowsError(try factory.build())
    }

    func testStoryboardFactoryWrongTypeNewConstructor() {
        let factory = StoryboardFactory<UINavigationController, Any?>(name: "TestStoryboard", bundle: Bundle(for: FactoryTest.self))
        XCTAssertThrowsError(try factory.build())
    }

    func testFinderFactory() {
        let navigationController = UINavigationController()
        let factory = FinderFactory<RouterTests.FakeClassFinder<UINavigationController, Any?>>(finder: RouterTests.FakeClassFinder(currentViewController: navigationController),
                                                                                               configuration: { viewController in
                                                                                                   viewController.viewControllers = [UIViewController()]
                                                                                               })
        XCTAssertEqual(try factory?.build(with: nil), navigationController)
        XCTAssertEqual(navigationController.viewControllers.count, 1)

        struct NothingFinder<VC: UIViewController, C>: Finder {
            func findViewController(with context: C) -> VC? {
                nil
            }
        }

        let throwsFactory = FinderFactory<NothingFinder<UIViewController, Any?>>(finder: NothingFinder())
        XCTAssertThrowsError(try throwsFactory?.build(with: nil))
    }

    func testNilFactory() {
        var factory = NilFactory<UIViewController, Any?>()
        XCTAssertThrowsError(try factory.prepare())
        XCTAssertThrowsError(try factory.build())
        XCTAssertThrowsError(try factory.execute())
    }

    func testVoidFactory() {
        struct TestVoidViewControllerFactory: Factory {

            typealias ViewController = UIViewController

            typealias Context = Void

            func build(with context: Void) throws -> UIViewController {
                UIViewController()
            }

        }

        let factory = TestVoidViewControllerFactory()
        XCTAssertNotNil(try factory.execute())
    }

    func testFactoryExecute() {

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
        XCTAssertNoThrow(try factory.execute(with: nil))
        XCTAssertEqual(prepareCount, 1)
        XCTAssertEqual(buildCount, 1)

        XCTAssertNoThrow(try factory.execute())
        XCTAssertEqual(prepareCount, 2)
        XCTAssertEqual(buildCount, 2)
    }

    func testPostponedIntegrationFactory() {
        var viewControllerStack: [UIViewController] = []
        let factory = ClassFactory<UIViewController, Any?>()
        var postponedFactory = PostponedIntegrationFactory(for: FactoryBox(factory, action: ContainerActionBox(UINavigationController.push()))!)
        XCTAssertNoThrow(try postponedFactory.prepare(with: AnyContextBox(nil as Any?)))
        XCTAssertNoThrow(try postponedFactory.build(with: AnyContextBox(nil as Any?), in: &viewControllerStack))
        XCTAssertEqual(viewControllerStack.count, 1)
        XCTAssertEqual(postponedFactory.description, "ClassFactory<UIViewController, Optional<Any>>(nibName: nil, bundle: nil, configuration: nil)")
    }

    func testFactoryExecuteWithAnyOrVoid() {
        class TestFactory<C>: Factory {
            typealias ViewController = UIViewController
            typealias Context = C
            var isPrepared = false
            var isApplied = false

            func build(with context: C) throws -> UIViewController {
                isApplied = true
                return ViewController()
            }

            func prepare(with context: C) throws {
                isPrepared = true
            }
        }

        let tfc = TestFactory<Any?>()
        _ = try? tfc.execute()
        XCTAssertTrue(tfc.isPrepared)
        XCTAssertTrue(tfc.isApplied)

    }

    func testRootStep() {
        let step = GeneralStep.RootViewControllerStep(windowProvider: CustomWindowProvider(window: UIWindow()))
        XCTAssertThrowsError(try step.perform(with: AnyContextBox(nil as Any?)))
    }

    func testSplitControllerStep() {
        let step = SplitControllerStep<UISplitViewController, Any?>()
        XCTAssertNoThrow(try step.factory.build(with: nil, integrating: ChildCoordinator(childFactories: [])))
    }

    func testUIHostingControllerFactory() {
        if #available(iOS 13, *) {
            let viewController = try? UIHostingControllerFactory<TestSwiftUIView, String> { context in
                TestSwiftUIView(with: context)
            }.execute(with: "test")
            XCTAssertNotNil(viewController)
            XCTAssertNotNil(viewController?.rootView.context == "test")
        }
    }

}
