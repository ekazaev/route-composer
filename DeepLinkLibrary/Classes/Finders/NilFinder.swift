//
// Created by Eugene Kazaev on 20/01/2018.
//

import Foundation
import UIKit

/// Simple finders for targets that never should be found in a view controller stack and should always be created
/// from scratch.
public class NilFinder<VV: UIViewController, AA>: Finder {
    public typealias V = VV
    public typealias A = AA

    public init() {

    }

    public func findViewController(with arguments: A?) -> V? {
        return nil
    }

}
