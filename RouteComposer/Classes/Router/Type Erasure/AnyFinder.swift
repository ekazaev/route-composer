//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

protocol AnyFinder {

    func findViewController<Context>(with context: Context) throws -> UIViewController?

}
