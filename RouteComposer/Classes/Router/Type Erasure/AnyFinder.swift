//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

protocol AnyFinder {

    func findViewController(with context: Any?) throws -> UIViewController?

}
