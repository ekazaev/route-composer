//
// Created by Eugene Kazaev on 20/01/2018.
//

import Foundation
import UIKit

/// Simple finders for targets that never should be found in a view controller stack and should always be created
/// from scratch.
public class NilFinder<VC: UIViewController, C>: Finder {

    public typealias ViewController = VC

    public typealias Context = C

    public init() {
    }

    public func findViewController(with context: Context?) -> ViewController? {
        return nil
    }

}
