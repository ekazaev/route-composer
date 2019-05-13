//
//  ContainerProviderTests.swift
//  RouteComposer_Tests
//
//  Created by Eugene Kazaev on 12/05/2019.
//  Copyright © 2019 HBC Digital. All rights reserved.
//

import XCTest
import UIKit
@testable import RouteComposer

class ContainerProviderTests: XCTestCase {

    class TestContainerController: UIViewController, CustomContainerViewController {

        lazy var adapter: ContainerAdapter = TestContainerAdapter(with: self)

        let canBeDismissed: Bool = true

    }

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
        let provider = DefaultContainerAdapterProvider()
        XCTAssertTrue(((try? provider.getAdapter(for: UINavigationController())) as? NavigationControllerAdapter<UINavigationController>) != nil)
        XCTAssertTrue(((try? provider.getAdapter(for: UITabBarController())) as? TabBarControllerAdapter<UITabBarController>) != nil)
        XCTAssertTrue(((try? provider.getAdapter(for: UISplitViewController())) as? SplitControllerAdapter<UISplitViewController>) != nil)
        XCTAssertTrue(((try? provider.getAdapter(for: ExtensionsTest.FakePresentingNavigationController())) as? NavigationControllerAdapter<UINavigationController>) != nil)
        XCTAssertTrue(((try? provider.getAdapter(for: TestContainerController())) as? TestContainerAdapter<TestContainerController>) != nil)
    }

}
