//
// Created by Eugene Kazaev on 23/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public class CustomContainerController: UIViewController {

    @IBOutlet private var containerView: UIView!

    public weak var delegate: CustomViewControllerDelegate?

    public var rootViewController: UIViewController? {
        didSet {
            presentRootController()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Custom Container View Controller"
        presentRootController()
    }

    @IBAction func doneTapped() {
        delegate?.dismissCustomContainer(controller: self)
    }

    private func presentRootController() {
        guard isViewLoaded else {
            return
        }

        let currentViewController = childViewControllers.first
        currentViewController?.willMove(toParentViewController: nil)
        currentViewController?.removeFromParentViewController()
        currentViewController?.view.removeFromSuperview()
        currentViewController?.didMove(toParentViewController: nil)

        guard let rootViewController = rootViewController else {
            return
        }

        rootViewController.willMove(toParentViewController: self)
        self.addChildViewController(rootViewController)
        containerView.addSubview(rootViewController.view)
        rootViewController.view.translatesAutoresizingMaskIntoConstraints = false
        rootViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        rootViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        rootViewController.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        rootViewController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true

        rootViewController.didMove(toParentViewController: self)
    }

}
