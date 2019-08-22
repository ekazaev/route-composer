//
// Created by Eugene Kazaev on 24/08/2019.
// Copyright (c) 2019 Eugene Kazaev. All rights reserved.
//

import Foundation
import UIKit

public class CustomTabViewController: UIViewController {

    @IBOutlet private var segmentedControl: UISegmentedControl!

    @IBOutlet private var containerView: UIView!

    public var selectedIndex: Int = 0

    public weak var delegate: CustomTabViewControllerDelegate?
    
    public var viewControllers: [UIViewController] = [] {
        didSet {
            updateSegmentedController()
        }
    }

    private weak var currentView: UIView?

    private var observers: [UIViewController: NSKeyValueObservation] = [:]

    public override func viewDidLoad() {
        super.viewDidLoad()
        updateSegmentedController()
        updateContainerView()
    }

    public var currentViewController: UIViewController? {
        guard !viewControllers.isEmpty else {
            return nil
        }
        return viewControllers[selectedIndex]
    }

    @IBAction func segmentValueChanged() {
        selectedIndex = segmentedControl.selectedSegmentIndex
        updateContainerView()
        if let currentViewController = currentViewController {
            delegate?.customTabViewController?(self, didSelect: currentViewController)
        }
    }

    private func updateSegmentedController() {
        guard isViewLoaded else {
            return
        }
        segmentedControl.removeAllSegments()
        guard !viewControllers.isEmpty else {
            segmentedControl.isHidden = true
            currentView?.removeFromSuperview()
            return
        }
        segmentedControl.isHidden = false
        children.filter({ !viewControllers.contains($0) }).forEach({
            $0.removeFromParent()
            observers.removeValue(forKey: $0)
        })
        let newSelectedIndex = selectedIndex < viewControllers.count ? selectedIndex : 0
        viewControllers.enumerated().forEach({ (index, viewController: UIViewController) in
            segmentedControl.insertSegment(withTitle: viewController.title, at: index, animated: false)
            if viewController.parent != self {
                if viewController.parent != nil {
                    viewController.willMove(toParent: nil)
                    viewController.removeFromParent()
                    viewController.didMove(toParent: nil)
                }
                viewController.willMove(toParent: self)
                addChild(viewController)
                if index == newSelectedIndex {
                    addToContentView(viewController: viewController)
                }
                viewController.didMove(toParent: self)
                let observer = viewController.observe(\.title, options: [.new], changeHandler: { viewController, change in
                    guard let index = self.viewControllers.firstIndex(of: viewController) else {
                        return
                    }
                    self.segmentedControl.setTitle(viewController.title, forSegmentAt: index)
                })
                observers[viewController] = observer
            }
        })
        segmentedControl.selectedSegmentIndex = newSelectedIndex
        selectedIndex = newSelectedIndex
    }

    private func updateContainerView() {
        guard isViewLoaded else {
            return
        }
        guard !viewControllers.isEmpty else {
            currentView?.removeFromSuperview()
            return
        }
        let currentViewController = viewControllers[selectedIndex]
        guard currentView != currentViewController.view else {
            return
        }
        addToContentView(viewController: currentViewController)
    }

    private func addToContentView(viewController: UIViewController) {
        guard isViewLoaded else {
            return
        }
        guard currentView != viewController.view else {
            return
        }
        currentView?.removeFromSuperview()
        containerView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.frame = containerView.bounds
        viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        currentView = viewController.view
        title = viewController.title
    }

}
