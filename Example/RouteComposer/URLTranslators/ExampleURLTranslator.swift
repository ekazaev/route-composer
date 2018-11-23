//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

protocol ExampleURLTranslator {

    func destination(from url: URL) -> ExampleDestination<UIViewController, Any?>?

}
