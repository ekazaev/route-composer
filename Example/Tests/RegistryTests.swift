//
//  RegistryTests.swift
//  RouteComposer_Tests
//
//  Created by Eugene Kazaev on 12/05/2019.
//  Copyright © 2019 HBC Digital. All rights reserved.
//

import XCTest
import UIKit
@testable import RouteComposer

class RegistryTests: XCTestCase {

    struct TestContainerAdapter<VC: ContainerViewController>: ConcreteContainerAdapter {

        init(with viewController: VC) {
        }

        let containedViewControllers: [UIViewController] = []

        let visibleViewControllers: [UIViewController] = []

        func makeVisible(_ viewController: UIViewController, animated: Bool) throws {
        }

        func setContainedViewControllers(_ containedViewControllers: [UIViewController], animated: Bool, completion: @escaping () -> Void) throws {
        }

    }

    func testDefaultAdaptersResults() {
        let registry = ContainerAdapterRegistry()
        XCTAssertTrue(((try? registry.getAdapter(for: UINavigationController())) as? NavigationControllerAdapter<UINavigationController>) != nil)
        XCTAssertTrue(((try? registry.getAdapter(for: UITabBarController())) as? TabBarControllerAdapter<UITabBarController>) != nil)
        XCTAssertTrue(((try? registry.getAdapter(for: UISplitViewController())) as? SplitControllerAdapter<UISplitViewController>) != nil)
        XCTAssertTrue(((try? registry.getAdapter(for: ExtensionsTest.FakePresentingNavigationController())) as? NavigationControllerAdapter<UINavigationController>) != nil)
    }

    func testRegisteredAdaptersResults() {
        let registry = ContainerAdapterRegistry()
        registry.register(adapterType: NavigationControllerAdapter<ExtensionsTest.FakePresentingNavigationController>.self)
        XCTAssertTrue(((try? registry.getAdapter(for: UINavigationController())) as? NavigationControllerAdapter<UINavigationController>) != nil)
        XCTAssertTrue(((try? registry.getAdapter(for: ExtensionsTest.FakePresentingNavigationController())) as?
                NavigationControllerAdapter<ExtensionsTest.FakePresentingNavigationController>) != nil)
        XCTAssertTrue(((try? registry.getAdapter(for: UISplitViewController())) as? SplitControllerAdapter<UISplitViewController>) != nil)
    }

    func testDefaultAdapterOverrideResult() {
        let registry = ContainerAdapterRegistry()
        registry.register(adapterType: TestContainerAdapter<UINavigationController>.self)
        XCTAssertTrue(((try? registry.getAdapter(for: UINavigationController())) as? TestContainerAdapter<UINavigationController>) != nil)
        XCTAssertTrue(((try? registry.getAdapter(for: UITabBarController())) as? TabBarControllerAdapter<UITabBarController>) != nil)
        XCTAssertTrue(((try? registry.getAdapter(for: ExtensionsTest.FakePresentingNavigationController())) as? NavigationControllerAdapter<UINavigationController>) != nil)

        registry.register(adapterType: TestContainerAdapter<UITabBarController>.self)
        XCTAssertTrue(((try? registry.getAdapter(for: UINavigationController())) as? TestContainerAdapter<UINavigationController>) != nil)
        XCTAssertTrue(((try? registry.getAdapter(for: UITabBarController())) as? TestContainerAdapter<UITabBarController>) != nil)
        XCTAssertTrue(((try? registry.getAdapter(for: ExtensionsTest.FakePresentingNavigationController())) as? NavigationControllerAdapter<UINavigationController>) != nil)
    }

}
