//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Default step that builds a dependency from another screen assembly
public class RequireAssemblyStep: ChainableStep {

    let assembly: DeepLinkableViewControllerAssembly

    override public var prevStep: Step? {
        return assembly.step
    }

    /// Default constructor
    ///
    /// - Parameter assembly: A required screen asseblie to execute this step.
    public init(assembly: DeepLinkableViewControllerAssembly) {
        self.assembly = assembly
        super.init()
    }

    /// Required step can not be chainded. It will provide previous step itself based on required assemblie.
    ///
    /// - Parameter presenter: Previous step to make by Router.
    override func previous(continue presenter: Step) {
        fatalError("RequireScreenStep cant have any further step chains. Next steps will be build from required target")
    }

}
