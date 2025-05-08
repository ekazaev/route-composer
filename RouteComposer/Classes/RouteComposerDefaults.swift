//
// RouteComposer
// RouteComposerDefaults.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

/// Default configuration for all the instances in `RouteComposer`.
///
/// **NB:** If you are going to provide your own defaults, make sure that `RouteComposerDefaults.configureWith(...)` is called
/// before the instantiation of any other `RouteComposer`'s instances. `AppDelegate` is probably the best place for it.
@MainActor
public final class RouteComposerDefaults {

    // MARK: Properties

    /// Singleton access.
    @MainActor
    public static let shared: RouteComposerDefaults = {
        switch configurationStorage {
        case let .some(configurationStorage):
            return configurationStorage
        case .none:
            let buildInDefaults = RouteComposerDefaults()
            configurationStorage = buildInDefaults
            return buildInDefaults
        }
    }()

    /// Default `Logger` instance.
    public let logger: Logger?

    /// Default `ContainerAdapterLocator` instance.
    public let containerAdapterLocator: ContainerAdapterLocator

    /// Default `StackIterator` instance.
    public let stackIterator: StackIterator

    /// Default `WindowProvider` instance.
    public let windowProvider: WindowProvider

    @MainActor
    private static var configurationStorage: RouteComposerDefaults?

    // MARK: Methods

    /// Default configuration for all the instances in `RouteComposer`.
    ///
    /// **NB:** If you are going to provide your own defaults, make sure that `RouteComposerDefaults.configureWith(...)` is called
    /// before the instantiation of any other `RouteComposer`'s instances. `AppDelegate` is probably the best place for it.
    /// - Parameters:
    ///   - logger: Default `Logger` instance.
    ///   - windowProvider: Default `WindowProvider` instance.
    ///   - containerAdapterLocator: Default `ContainerAdapterLocator` instance.
    ///   - stackIterator: Default `StackIterator` instance.
    @MainActor
    public static func configureWith(logger: Logger? = DefaultLogger(.warnings),
                                     windowProvider: WindowProvider = KeyWindowProvider(),
                                     containerAdapterLocator: ContainerAdapterLocator = DefaultContainerAdapterLocator(),
                                     stackIterator: StackIterator? = nil) {
        guard configurationStorage == nil else {
            assertionFailure("Default values were initialised once. \(#function) must be called before any RouteComposer instantiation!")
            return
        }
        configurationStorage = RouteComposerDefaults(logger: logger,
                                                     windowProvider: windowProvider,
                                                     containerAdapterLocator: containerAdapterLocator,
                                                     stackIterator: stackIterator)
    }

    @MainActor
    private init(logger: Logger? = DefaultLogger(.warnings),
                 windowProvider: WindowProvider = KeyWindowProvider(),
                 containerAdapterLocator: ContainerAdapterLocator = DefaultContainerAdapterLocator(),
                 stackIterator: StackIterator? = nil) {
        self.logger = logger
        self.windowProvider = windowProvider
        self.containerAdapterLocator = containerAdapterLocator
        self.stackIterator = stackIterator ?? DefaultStackIterator(windowProvider: windowProvider, containerAdapterLocator: containerAdapterLocator)
    }

    private func logInstantiation() {
        guard let logger else {
            return
        }
        logger.log(.info("""
        Initialised defaults values with:
            Logger: \(logger)
            WindowProvider: \(windowProvider)
            ContainerAdapterLocator: \(containerAdapterLocator)
            StackIterator:\(stackIterator)
        """))
    }

}
