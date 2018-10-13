//
// Created by Eugene Kazaev on 2018-10-13.
//

import Foundation
import UIKit

struct FinderInContainer<VC: ContainerViewController, F: Finder>: Finder {

    typealias ViewController = F.ViewController

    typealias Context = F.Context

    let finder: F

    init(using finder: F) {
        self.finder = finder
    }

    func findViewController(with context: Context) -> ViewController? {
        guard let childViewController = finder.findViewController(with: context),
              UIViewController.findContainer(of: childViewController) as VC? != nil else {
            return nil
        }
        return childViewController
    }

}
