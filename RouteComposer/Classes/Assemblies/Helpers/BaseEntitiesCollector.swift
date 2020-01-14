//
// Created by Eugene Kazaev on 2018-10-31.
//

#if os(iOS)

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

#endif
