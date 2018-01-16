//
//  SquareViewController.swift
//  CircumferenceKit
//
//  Created by Eugene Kazaev on 18/12/2017.
//  Copyright © 2017 Gilt Groupe. All rights reserved.
//

import UIKit
import DeepLinkLibrary

class SquareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToCircleTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.circle)!)
    }

    @IBAction func goToHomeTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.empty)!)
    }

    @IBAction func goToSplitTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.split)!)
    }

}

