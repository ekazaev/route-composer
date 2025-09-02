//
// RouteComposer
// StepAssembly+Shorthands.swift
// https://github.com/ekazaev/route-composer
//
// Copyright (c) 2018-2025 Eugene Kazaev.
// Distributed under the MIT License.
//
// Modified in a fork by Savva Shuliatev
// https://github.com/Savva-Shuliatev
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

// MARK: ViewControllerActions shorthands

public extension StepAssembly where FC: Factory {
    /// Enables shorthand `.using(.present(...))` by providing a concrete expected type.
    final func using(_ action: ViewControllerActions.PresentModallyAction) -> StepChainAssembly<ViewController, Context> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.replaceRoot(...))`
    final func using(_ action: ViewControllerActions.ReplaceRootAction) -> StepChainAssembly<ViewController, Context> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.nilAction)`
    final func using(_ action: ViewControllerActions.NilAction) -> StepChainAssembly<ViewController, Context> {
        usingAction(action)
    }
}

public extension StepAssembly where FC: ContainerFactory {
    /// Enables shorthand `.using(.presentModally(...))` by providing a concrete expected type.
    final func using(_ action: ViewControllerActions.PresentModallyAction) -> StepChainAssembly<ViewController, Context> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.replaceRoot(...))`
    final func using(_ action: ViewControllerActions.ReplaceRootAction) -> StepChainAssembly<ViewController, Context> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.nilAction)`
    final func using(_ action: ViewControllerActions.NilAction) -> StepChainAssembly<ViewController, Context> {
        usingAction(action)
    }
}

// MARK: NavigationControllerActions shorthands

public extension StepAssembly where FC: Factory {
    /// Enables shorthand `.using(.push)` by providing a concrete expected type.
    final func using(_ action: NavigationControllerActions.PushAction<UINavigationController>) -> ContainerStepChainAssembly<UINavigationController, ViewController, Context> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.pushAsRoot)`
    final func using(_ action: NavigationControllerActions.PushAsRootAction<UINavigationController>)
        -> ContainerStepChainAssembly<UINavigationController, ViewController, Context> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.pushReplacingLast)`
    final func using(_ action: NavigationControllerActions.PushReplacingLastAction<UINavigationController>)
        -> ContainerStepChainAssembly<UINavigationController, ViewController, Context> {
        usingAction(action)
    }
}

public extension StepAssembly where FC: ContainerFactory {
    /// Enables shorthand `.using(.push)` by providing a concrete expected type.
    final func using(_ action: NavigationControllerActions.PushAction<UINavigationController>) -> ContainerStepChainAssembly<UINavigationController, ViewController, Context> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.pushAsRoot)`
    final func using(_ action: NavigationControllerActions.PushAsRootAction<UINavigationController>)
        -> ContainerStepChainAssembly<UINavigationController, ViewController, Context> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.pushReplacingLast)`
    final func using(_ action: NavigationControllerActions.PushReplacingLastAction<UINavigationController>)
        -> ContainerStepChainAssembly<UINavigationController, ViewController, Context> {
        usingAction(action)
    }
}

// MARK: TabBarControllerActions shorthands

public extension StepAssembly where FC: Factory {
    /// Enables shorthand `.using(.addTab)` by providing a concrete expected type.
    final func using(_ action: TabBarControllerActions.AddTabAction<UITabBarController>) -> ContainerStepChainAssembly<UITabBarController, ViewController, Context> {
        usingAction(action)
    }
}

public extension StepAssembly where FC: ContainerFactory {
    /// Enables shorthand `.using(.addTab)` by providing a concrete expected type.
    final func using(_ action: TabBarControllerActions.AddTabAction<UITabBarController>) -> ContainerStepChainAssembly<UITabBarController, ViewController, Context> {
        usingAction(action)
  }
}

// MARK: SplitViewControllerActions shorthands

public extension StepAssembly where FC: Factory {
    /// Enables shorthand `.using(.setAsMaster)` by providing a concrete expected type.
    final func using(_ action: SplitViewControllerActions.SetAsMasterAction<UISplitViewController>) -> ContainerStepChainAssembly<UISplitViewController, ViewController, Context> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.pushToDetails)`
    final func using(_ action: SplitViewControllerActions.PushToDetailsAction<UISplitViewController>)
        -> ContainerStepChainAssembly<UISplitViewController, ViewController, Context> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.pushOnToDetails)`
    final func using(_ action: SplitViewControllerActions.PushOnToDetailsAction<UISplitViewController>)
        -> ContainerStepChainAssembly<UISplitViewController, ViewController, Context> {
        usingAction(action)
    }
}

public extension StepAssembly where FC: ContainerFactory {
    /// Enables shorthand `.using(.push)` by providing a concrete expected type.
    final func using(_ action: SplitViewControllerActions.SetAsMasterAction<UISplitViewController>) -> ContainerStepChainAssembly<UISplitViewController, ViewController, Context> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.pushToDetails)`
    final func using(_ action: SplitViewControllerActions.PushToDetailsAction<UISplitViewController>)
        -> ContainerStepChainAssembly<UISplitViewController, ViewController, Context> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.pushOnToDetails)`
    final func using(_ action: SplitViewControllerActions.PushOnToDetailsAction<UISplitViewController>)
        -> ContainerStepChainAssembly<UISplitViewController, ViewController, Context> {
        usingAction(action)
    }
}
