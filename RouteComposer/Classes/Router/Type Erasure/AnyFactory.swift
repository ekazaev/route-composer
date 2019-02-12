//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

protocol AnyFactory {

    var action: AnyAction { get set }

    mutating func prepare(with context: Any?) throws

    func build(with context: Any?) throws -> UIViewController

    mutating func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory]

}

protocol AnyFactoryBox: AnyFactory {

    associatedtype FactoryType: AbstractFactory

    var factory: FactoryType { get set }

    init?(_ factory: FactoryType, action: AnyAction)

}

protocol PreparableAnyFactory: AnyFactory, AnyPreparableEntity {

    var isPrepared: Bool { get set }

}

extension AnyFactoryBox where Self: AnyFactory {

    mutating func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory] {
        return factories
    }

}

extension AnyFactoryBox where Self: PreparableAnyFactory, Self: MainThreadChecking {

    mutating func prepare(with context: Any?) throws {
        assertIfNotMainThread()
        guard let typedContext = Any?.some(context as Any) as? FactoryType.Context else {
            throw RoutingError.typeMismatch(FactoryType.Context.self, RoutingError.Context("\(String(describing: factory.self)) does " +
                    "not accept \(String(describing: context.self)) as a context."))
        }
        try factory.prepare(with: typedContext)
        isPrepared = true
    }

}

extension AnyFactory where Self: CustomStringConvertible & AnyFactoryBox {

    var description: String {
        return String(describing: factory)
    }

}

struct FactoryBox<F: Factory>: PreparableAnyFactory, AnyFactoryBox, MainThreadChecking, CustomStringConvertible {

    typealias FactoryType = F

    var factory: F

    var action: AnyAction

    var isPrepared = false

    init?(_ factory: F, action: AnyAction) {
        guard !(factory is NilEntity) else {
            return nil
        }
        self.factory = factory
        self.action = action
    }

    func build(with context: Any?) throws -> UIViewController {
        guard let typedContext = Any?.some(context as Any) as? FactoryType.Context else {
            throw RoutingError.typeMismatch(FactoryType.Context.self, RoutingError.Context("\(String(describing: factory.self)) does " +
                    "not accept \(String(describing: context.self)) as a context."))
        }
        assertIfNotMainThread()
        assertIfNotPrepared()
        return try factory.build(with: typedContext)
    }

}

struct ContainerFactoryBox<F: ContainerFactory>: PreparableAnyFactory, AnyFactoryBox, MainThreadChecking, CustomStringConvertible {

    typealias FactoryType = F

    var factory: FactoryType

    var action: AnyAction

    var children: [DelayedIntegrationFactory<FactoryType.Context>] = []

    var isPrepared = false

    init?(_ factory: FactoryType, action: AnyAction) {
        guard !(factory is NilEntity) else {
            return nil
        }
        self.factory = factory
        self.action = action
    }

    mutating func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory] {
        var otherFactories: [AnyFactory] = []
        var isNonEmbeddableFound = false
        self.children = factories.compactMap({ child -> DelayedIntegrationFactory<FactoryType.Context>? in
            guard !isNonEmbeddableFound, child.action.isEmbeddable(to: FactoryType.ViewController.self) else {
                otherFactories.append(child)
                isNonEmbeddableFound = true
                return nil
            }
            return DelayedIntegrationFactory(child)
        })
        return otherFactories
    }

    func build(with context: Any?) throws -> UIViewController {
        guard let typedContext = Any?.some(context as Any) as? FactoryType.Context else {
            throw RoutingError.typeMismatch(FactoryType.Context.self, RoutingError.Context("\(String(describing: factory.self)) does " +
                    "not accept \(String(describing: context.self)) as a context."))
        }
        assertIfNotMainThread()
        assertIfNotPrepared()
        return try factory.build(with: typedContext, integrating: ChildCoordinator(childFactories: children))
    }

}

//struct ExistingContainerFactoryBox: AnyFactory, PreparableAnyFactory, MainThreadChecking, CustomStringConvertible {
//
//    class ExistingContainerActionBox: AnyAction {
//
//        var nestedActionHelper: NestedActionHelper?
//
//        let containerViewController: ContainerViewController & UIViewController
//
//        var viewControllersToIntegrate: [UIViewController] = []
//
//        init(containerViewController: ContainerViewController & UIViewController) {
//            self.containerViewController = containerViewController
//        }
//
//        func perform(with viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
//            guard !viewControllersToIntegrate.isEmpty else {
//                completion(.continueRouting)
//                return
//            }
//            containerViewController.replace(containedViewControllers: viewControllersToIntegrate, animated: animated, completion: {
//                completion(.continueRouting)
//            })
//        }
//
//        func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) throws {
//        }
//
//        func isEmbeddable(to container: ContainerViewController.Type) -> Bool {
//            return false
//        }
//
//    }
//
//    var isPrepared: Bool = false
//
//    var action: AnyAction {
//        return existingContainerAction
//    }
//
//    var children: [DelayedIntegrationFactory<Any?>] = []
//
//    let containerViewController: ContainerViewController & UIViewController
//
//    let existingContainerAction: ExistingContainerActionBox
//
//    init(containerViewController: ContainerViewController & UIViewController) {
//        self.containerViewController = containerViewController
//        self.existingContainerAction = ExistingContainerActionBox(containerViewController: containerViewController)
//    }
//
//    mutating func prepare(with context: Any?) throws {
//        isPrepared = true
//    }
//
//    func build(with context: Any?) throws -> UIViewController {
//        assertIfNotMainThread()
//        assertIfNotPrepared()
//        if !children.isEmpty {
//            let viewControllers = try ChildCoordinator(childFactories: children).build(with: context, integrating: containerViewController.containedViewControllers)
//            existingContainerAction.viewControllersToIntegrate = viewControllers
//            if let lastIntegratedVC = viewControllers.last {
//                return lastIntegratedVC
//            }
//        }
//        return containerViewController.visibleViewControllers.last!
//    }
//
//    mutating func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory] {
//        var otherFactories: [AnyFactory] = []
//        var isNonEmbeddableFound = false
//        self.children = factories.compactMap({ child -> DelayedIntegrationFactory<Any?>? in
//            guard !isNonEmbeddableFound, child.action.isEmbeddable(to: type(of: containerViewController)) else {
//                otherFactories.append(child)
//                isNonEmbeddableFound = true
//                return nil
//            }
//            return DelayedIntegrationFactory(child)
//        })
//        return otherFactories
//    }
//
//    var description: String {
//        return String(describing: containerViewController)
//    }
//
//}