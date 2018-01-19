//
//  CircleViewController.swift
//  CircumferenceKit
//
//  Created by Eugene Kazaev on 18/12/2017.
//  Copyright © 2017 Gilt Groupe. All rights reserved.
//

import UIKit
import DeepLinkLibrary

class CircleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToSquareTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.square)!)
    }

    @IBAction func goToRandomColorTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.color, arguments: ExampleDictionaryArguments(arguments: [Argument.color: "0000FF"]))!)
    }

    @IBAction func goToDeepModalTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.ruleSupport, arguments: ExampleDictionaryArguments(arguments: [Argument.color: "00FF00"]))!)
    }

    @IBAction func goToSuperModalTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.superModal, arguments: ExampleDictionaryArguments(arguments: [Argument.color: "0000FF"]))!)
    }

    @IBAction func goToProductTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.product, arguments: ExampleDictionaryArguments(arguments: [Argument.productId: "01"]))!)
    }

    @IBAction func goToWelcomeTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.welcome)!)
    }
}

