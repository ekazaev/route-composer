//
// Created by Eugene Kazaev on 15/01/2018.
//

import UIKit

/// Default navigation container step
public final class NavigationControllerStep<VC: UINavigationController, Context>: SingleContainerStep<NilFinder<VC, Context>, NavigationControllerFactory<VC, Context>> {

    // MARK: Methods

    /// Constructor
    public init() {
        super.init(finder: NilFinder(), factory: NavigationControllerFactory<VC, Context>())
    }

}
