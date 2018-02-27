//
// Created by Eugene Kazaev on 17/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

// I do not want to create login service for demo so it is just a variable
var isLoggedIn: Bool = false

class LoginInterceptor: RouterInterceptor {

    typealias Context = Any

    func execute(with context: Context?, completion: @escaping (_: InterceptorResult) -> Void) {
        guard !isLoggedIn else {
            completion(.success)
            return
        }

        // Using router and finder in interceptor like this is recommended technic because application can be already on
        // login screen then he will receive a deep linking to some part which requires a login screen.
        // It will help to avoid opening of another login view controller and will help you not to have your own
        // boilerplate code that will help you to avoid this rare, but possible situation.
        let destination = LoginConfiguration.login()
        let result = DefaultRouter(logger: DefaultLogger(.warnings)).deepLinkTo(destination: destination) { success in
            guard success, let viewController = LoginViewControllerFinder().findViewController(with: nil) else {
                completion(.failure("LoginViewController not found."))
                return
            }

            viewController.interceptorCompletionBlock = completion
        }

        if result == .unhandled {
            completion(.failure(nil))
        }
    }

}

class LoginViewControllerFinder: FinderWithPolicy {

    typealias ViewController = LoginViewController

    typealias Context = Any

    let policy: FinderPolicy

    init(policy: FinderPolicy = .allStackUp) {
        self.policy = policy
    }

    func isTarget(viewController: ViewController, context: Context?) -> Bool {
        return true
    }

}

class LoginViewController: UIViewController, ExampleAnalyticsSupport {

    let analyticParameters = ExampleAnalyticsParameters(source: .login)

    @IBOutlet private var loginTextField: UITextField!

    @IBOutlet private var passwordTextField: UITextField!

    @IBOutlet private var loginButton: UIButton!

    var interceptorCompletionBlock: ((_: InterceptorResult) -> Void)? {
        // This will help to handle the rare situation that user is in the middle of deeplinking to the login restricted,
        // area and he taps on another deeplink to another restricted area. Interceptor will replace this completion block
        // without dismissing a view controller. By a contract interceptor implementation MUST call completion block
        // always. It means that we must call previous completion block if it was here to help router to know that
        // previous login interceptor did not succeed.
        willSet {
            guard let completion = interceptorCompletionBlock else {
                return
            }

            completion(.failure("New completion block was set. Previous routing should not continue."))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginTapped() {
        guard let login = loginTextField.text, let password = passwordTextField.text else {
            return
        }

        if login == "abc", password == "abc" {
            loginTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            loginButton.isEnabled = false
            let mainQueue = DispatchQueue.main
            let deadline = DispatchTime.now() + .seconds(2)
            mainQueue.asyncAfter(deadline: deadline) {
                self.loginButton.isEnabled = true
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
            self.present(alertController, animated: true)
        }
    }

    @IBAction func closeTapped() {
        interceptorCompletionBlock?(.failure("User tapped close button."))
        self.dismiss(animated: true)
    }

}
