//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class NavigationContainerStep: ChainableStep {

    public init(factory: Factory? = nil, action: ViewControllerAction? = nil) {
        super.init(factory: factory ?? NavigationControllerFactory(action: action))
    }

}
