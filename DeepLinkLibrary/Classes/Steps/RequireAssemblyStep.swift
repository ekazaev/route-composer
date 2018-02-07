//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Default step that builds a dependency from another screen assembly
public class RequireAssemblyStep: ChainableStep {

    let assembly: RoutingStep

    override public var previousStep: RoutingStep? {
        return assembly
    }

    /// Default constructor
    ///
    /// - Parameter assembly: The screen assebly required to execute this step.
    public init(assembly: RoutingStep) {
        self.assembly = assembly
        super.init()
    }

    /// Required step can not be chained. It will provide previous step itself based on required assembly.
    ///
    /// - Parameter step: Previous step that to be executed by Router.
    override func from(_ step: RoutingStep) {
        fatalError("RequireScreenStep can't have any further step chains. Next steps will be build from the required target")
    }

}
