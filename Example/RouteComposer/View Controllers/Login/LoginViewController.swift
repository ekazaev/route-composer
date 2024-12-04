//
// RouteComposer
// LoginViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

// I do not want to create login service for demo so it is just a variable
@MainActor var isLoggedIn: Bool = false

@MainActor class LoginInterceptor<C>: RoutingInterceptor {

    typealias Context = C

    func perform(with context: Context, completion: @escaping (_: RoutingResult) -> Void) {
        guard !isLoggedIn else {
            completion(.success)
            return
        }

        // Using the router and the  finder in interceptor like this is the recommended technique because the application can already be on
        // the login screen when it will receive a command to navigate to some part of the app that requires a login screen.
        // This technique will help to avoid opening of another login view controller.
        let destination = LoginConfiguration.login()
        do {
            try UIViewController.router.navigate(to: destination) { routingResult in
                guard routingResult.isSuccessful,
                      let viewController = ClassFinder<LoginViewController, Any?>().getViewController() else {
                    completion(.failure(RoutingError.compositionFailed(.init("LoginViewController was not found."))))
                    return
                }

                viewController.interceptorCompletionBlock = completion
            }
        } catch {
            completion(.failure(RoutingError.compositionFailed(.init("Could not present login view controller", underlyingError: error))))
        }
    }

}

class LoginViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.login

    @IBOutlet private var loginTextField: UITextField!

    @IBOutlet private var passwordTextField: UITextField!

    @IBOutlet private var loginButton: UIButton!

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    var interceptorCompletionBlock: ((_: RoutingResult) -> Void)? {
        // This will help to handle the rare situation that user is in the middle of deep linking to the login restricted,
        // area and he taps on another link to another restricted area. Interceptor will replace this completion block
        // without dismissing a view controller. By a contract interceptor implementation MUST call completion block
        // always. It means that we must call previous completion block if it was here to help router to know that
        // previous login interceptor did not succeed.
        willSet {
            guard let completion = interceptorCompletionBlock else {
                return
            }

            completion(.failure(RoutingError.generic(.init("New completion block was set. " +
                    "Previous navigation process should be halted."))))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
    }

    @IBAction func loginTapped() {
        guard let login = loginTextField.text, let password = passwordTextField.text else {
            return
        }

        if login == "abc", password == "abc" {
            loginTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            loginButton.isEnabled = false
            let deadline = DispatchTime.now() + .seconds(2)
            activityIndicator.startAnimating()
            Task { @MainActor in
                try await Task.sleep(nanoseconds: deadline.uptimeNanoseconds)
                self.loginButton.isEnabled = true
                self.activityIndicator.stopAnimating()
                isLoggedIn = true
                self.dismiss(animated: true) {
                    self.interceptorCompletionBlock?(.success)
                }
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Login/password pair is invalid!", preferredStyle: .alert)
            alertController.addAction(
                UIAlertAction(title: "Ok", style: .default) { _ in
                    alertController.dismiss(animated: true)
                }
            )
            present(alertController, animated: true)
        }
    }

    @IBAction func closeTapped() {
        interceptorCompletionBlock?(.failure(FailingRouterIgnoreError(underlyingError: RoutingError.generic(.init("User tapped close button.")))))
        dismiss(animated: true)
    }

}
