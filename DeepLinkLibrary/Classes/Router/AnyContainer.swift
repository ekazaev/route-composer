//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation
import UIKit

public protocol AnyContainer {

    func merge(_ factories: [AnyFactory]) -> [AnyFactory]

}