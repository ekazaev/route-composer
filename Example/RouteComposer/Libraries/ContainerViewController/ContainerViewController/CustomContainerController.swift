//
// RouteComposer
// CustomContainerController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

import Foundation
import UIKit

public final class CustomContainerController: UIViewController {

    @IBOutlet private var containerView: UIView!

    public weak var delegate: CustomViewControllerDelegate?

    public var rootViewController: UIViewController? {
        didSet {
            presentRootController()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Custom Container View Controller"
        presentRootController()
    }

    @IBAction func doneTapped() {
        delegate?.dismissCustomContainer(controller: self)
    }

    private func presentRootController() {
        guard isViewLoaded else {
            return
        }

        let currentViewController = children.first
        currentViewController?.willMove(toParent: nil)
        currentViewController?.removeFromParent()
        currentViewController?.view.removeFromSuperview()
        currentViewController?.didMove(toParent: nil)

        guard let rootViewController = rootViewController else {
            return
        }

        rootViewController.willMove(toParent: self)
        addChild(rootViewController)
        containerView.addSubview(rootViewController.view)
        rootViewController.view.translatesAutoresizingMaskIntoConstraints = false
        rootViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        rootViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        rootViewController.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        rootViewController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true

        rootViewController.didMove(toParent: self)
    }

}
