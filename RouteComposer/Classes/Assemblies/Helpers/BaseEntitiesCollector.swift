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
        self.finder = FinderBox.box(for: finder)
        self.factory = FactoryBoxer.box(for: factory, action: ActionBoxer.init(action))
    }

    init<F: Finder>(finder: F, factory: FactoryBoxer.FactoryType, action: ActionBoxer.ActionType)
            where FactoryBoxer.FactoryType: NilEntity, F.ViewController == FactoryBoxer.FactoryType.ViewController, F.Context == FactoryBoxer.FactoryType.Context {
        self.finder = FinderBox.box(for: finder)
        self.factory = FactoryBox.box(for: FinderFactory(finder: finder), action: ActionBoxer.init(action))
    }

    func getFinderBoxed() -> AnyFinder? {
        return finder
    }

    func getFactoryBoxed() -> AnyFactory? {
        return factory
    }

}
