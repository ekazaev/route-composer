//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public typealias RequiredScreenProvider = (() -> DeepLinkableScreen?)

public class RequireScreenStep: ChainableStep {

    let screen: DeepLinkableScreen

    override public var prevStep: Step? {
        return screen.step
    }

    public init(screen: DeepLinkableScreen) {
        self.screen = screen
        super.init()
    }

    override func previous(continue presenter: Step) {
        fatalError("RequireScreenStep cant have any further step chains. Next steps will be build from required target")
    }

}
