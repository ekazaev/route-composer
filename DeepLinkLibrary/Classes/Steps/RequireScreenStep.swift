//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public typealias RequiredScreenProvider = (() -> DeepLinkableScreen?)

public class RequireScreenStep: ChainableStep {

    let screenProvider: RequiredScreenProvider

    override public var prevStep: Step? {
        guard let screen = screenProvider() else {
            return nil
        }

        return screen.step
    }

    public init(screenProvider: @escaping RequiredScreenProvider) {
        self.screenProvider = screenProvider
        super.init()
    }

    override func previous(continue presenter: Step) {
        fatalError("RequireScreenPresenter cant have any further steps chains. Steps will be build from required target")
    }

}
