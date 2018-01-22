//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class RequireAssemblyStep: ChainableStep {

    let assembly: DeepLinkableViewControllerAssembly

    override public var prevStep: Step? {
        return assembly.step
    }

    public init(assembly: DeepLinkableViewControllerAssembly) {
        self.assembly = assembly
        super.init()
    }

    override func previous(continue presenter: Step) {
        fatalError("RequireScreenStep cant have any further step chains. Next steps will be build from required target")
    }

}
