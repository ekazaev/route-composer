//
// Created by Eugene Kazaev on 10/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class EmptyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToCircleTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.circle)!)
    }

    @IBAction func goToSquareTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.square)!)
    }

    @IBAction func goToSelfTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.empty)!)
    }

}
