//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit
import DeepLinkLibrary

private let appRouter = DefaultRouter()

extension UIViewController {

    var router: Router {
        get {
            return appRouter
        }
    }
}
