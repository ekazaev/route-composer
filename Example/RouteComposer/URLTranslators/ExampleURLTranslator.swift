//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

protocol ExampleURLTranslator {

    func destination(from url: URL) -> ExampleDestination<UIViewController, Any?>?

}
