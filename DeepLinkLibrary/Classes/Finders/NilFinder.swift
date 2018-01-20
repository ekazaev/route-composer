//
// Created by Eugene Kazaev on 20/01/2018.
//

import Foundation
import UIKit

public class NilFinder: DeepLinkFinder {

    public init() {

    }

    public func findViewController(with arguments: Any?) -> UIViewController? {
        return nil
    }

}
