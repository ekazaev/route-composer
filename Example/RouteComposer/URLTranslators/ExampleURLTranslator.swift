//
// Created by Eugene Kazaev on 15/01/2018.
//

import Foundation
import UIKit
import RouteComposer

protocol ExampleURLTranslator {

    func destination(from url: URL) -> AnyDestination?

}
