//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

extension UIViewController {

    var configuration: ExampleConfiguration {
        get {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                  let config = appDelegate.config else {
                fatalError("Configuration in the app is not set")
            }

            return config
        }
    }
}
