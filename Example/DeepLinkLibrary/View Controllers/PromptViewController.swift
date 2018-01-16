//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class PromptViewController: UIViewController {

    @IBAction func goToHomeTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.home)!)
    }

}
