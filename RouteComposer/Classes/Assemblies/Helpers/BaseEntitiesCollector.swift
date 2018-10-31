//
// Created by Eugene Kazaev on 2018-10-31.
//

import Foundation
import UIKit

struct BaseEntitiesCollector<FactoryBoxer: AnyFactoryBox, ActionBoxer: AnyActionBox> {

    private let factory: AnyFactory?

    private let finder: AnyFinder?

    init<F: Finder>(finder: F, factory: FactoryBoxer.FactoryType, action: ActionBoxer.ActionType)
            where F.ViewController == FactoryBoxer.FactoryType.ViewController, F.Context == FactoryBoxer.FactoryType.Context {
        self.finder = FinderBox(finder)

        if let factoryBox = FactoryBoxer(factory, action: ActionBoxer(action)) {
            self.factory = factoryBox
        } else if let finderFactory = FinderFactory(finder: finder) {
            self.factory = FactoryBox(finderFactory, action: ActionBoxer(action))
        } else {
            self.factory = nil
        }
    }

    func getFinderBoxed() -> AnyFinder? {
        return finder
    }

    func getFactoryBoxed() -> AnyFactory? {
        return factory
    }

}
