//
// Created by Eugene Kazaev on 2019-08-21.
//

import UIKit

/// Default implementation of `StackPresentationHandler`
public struct DefaultStackPresentationHandler: StackPresentationHandler {

    // MARK: Properties

    /// `Logger` instance to be used by `DefaultRouter`.
    public let logger: Logger?

    /// `ContainerAdapter` instance.
    public let containerAdapterLocator: ContainerAdapterLocator

    // MARK: Methods

    /// Constructor
    ///
    /// Parameters
    ///   - logger: A `Logger` instance to be used by the `DefaultRouter`.
    ///   - containerAdapterLocator: A `ContainerAdapterLocator` instance to be used by the `DefaultRouter`.
    public init(logger: Logger? = DefaultLogger(.warnings),
                containerAdapterLocator: ContainerAdapterLocator = DefaultContainerAdapterLocator()) {
        self.logger = logger
        self.containerAdapterLocator = containerAdapterLocator
    }

    /// Dismisses all the `UIViewController`s presented on top of the provided `UIViewController` and makes it visible in
    /// the enclosing containers.
    ///
    /// - Parameters:
    ///   - viewController: `UIViewController` to make active.
    ///   - animated: Update stack with animation where possible.
    ///   - completion: Completion block
    public func makeActive(_ viewController: UIViewController, animated: Bool, completion: @escaping (RoutingResult) -> Void) {
        dismissPresented(from: viewController, animated: animated) { result in
            guard result.isSuccessful else {
                return completion(result)
            }

            self.makeVisibleInParentContainer(viewController, animated: animated, completion: completion)
        }
    }

    private func dismissPresented(from viewController: UIViewController, animated: Bool, completion: @escaping ((_: RoutingResult) -> Void)) {
        if let presentedController = viewController.presentedViewController {
            if !presentedController.isBeingDismissed {
                viewController.dismiss(animated: animated) {
                    self.logger?.log(.info("Dismissed all the view controllers presented from \(String(describing: viewController))"))
                    completion(.success)
                }
            } else {
                completion(.failure(RoutingError.compositionFailed(.init("Attempt to dismiss \(String(describing: presentedController)) while it is being dismissed"))))
            }
        } else {
            completion(.success)
        }
    }

    private func makeVisibleInParentContainer(_ viewController: UIViewController,
                                              animated: Bool,
                                              completion: @escaping (RoutingResult) -> Void) {
        var parentViewControllers = viewController.allParents

        func makeVisible(viewController: UIViewController, completion: @escaping (RoutingResult) -> Void) {
            guard !parentViewControllers.isEmpty else {
                completion(.success)
                return
            }
            do {
                let parentViewController = parentViewControllers.removeFirst()
                if let container = parentViewController as? ContainerViewController {
                    let containerAdapter = try containerAdapterLocator.getAdapter(for: container)
                    containerAdapter.makeVisible(viewController, animated: animated, completion: { result in
                        guard result.isSuccessful else {
                            completion(result)
                            return
                        }
                        self.logger?.log(.info("Made \(String(describing: viewController)) visible in \(String(describing: container))"))
                        makeVisible(viewController: parentViewController, completion: completion)
                    })
                } else {
                    makeVisible(viewController: parentViewController, completion: completion)
                }
            } catch {
                completion(.failure(error))
            }
        }

        makeVisible(viewController: viewController, completion: completion)
    }

}
