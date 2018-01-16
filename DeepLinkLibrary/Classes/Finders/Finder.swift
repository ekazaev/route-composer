//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

public protocol DeepLinkFinder {

    func findViewController(with arguments: Any?) -> UIViewController?

}
