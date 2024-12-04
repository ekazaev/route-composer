//
// RouteComposer
// BaseEntitiesCollector.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

struct BaseEntitiesCollector<FactoryBoxer: AnyFactoryBox, ActionBoxer: AnyActionBox>: EntitiesProvider {

    let factory: AnyFactory?

    let finder: AnyFinder?

    init<F: Finder>(finder: F, factory: FactoryBoxer.FactoryType, action: ActionBoxer.ActionType)
        where
        F.ViewController == FactoryBoxer.FactoryType.ViewController, F.Context == FactoryBoxer.FactoryType.Context {
        self.finder = FinderBox(finder)

        if let factoryBox = FactoryBoxer(factory, action: ActionBoxer(action)) {
            self.factory = factoryBox
        } else if let finderFactory = FinderFactory(finder: finder) {
            self.factory = FactoryBox(finderFactory, action: ActionBox(ViewControllerActions.NilAction()))
        } else {
            self.factory = nil
        }
    }

}
