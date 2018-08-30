# RouteComposer

[![CI Status](https://travis-ci.org/saksdirect/route-composer.svg?branch=master&style=flat)](https://travis-ci.org/saksdirect/route-composer)
[![Version](https://img.shields.io/cocoapods/v/RouteComposer.svg?style=flat)](http://cocoapods.org/pods/RouteComposer)
[![License](https://img.shields.io/cocoapods/l/RouteComposer.svg?style=flat)](http://cocoapods.org/pods/RouteComposer)
[![Platform](https://img.shields.io/cocoapods/p/RouteComposer.svg?style=flat)](http://cocoapods.org/pods/RouteComposer)

`RouteComposer` is the protocol oriented, Cocoa UI abstractions based library that helps to handle view controllers composition, routing
and deep linking tasks in the iOS application.

![](https://habrastorage.org/webt/x7/yt/ll/x7ytllwqwgvgxy2rvtmdwj3qkia.png)

## Table of contents

- [Installation](#installation)
- [Example](#example)
- [Requirements](#requirements)
- [Usage](#usage)
    - [Implementation](#implementation)
        - [Factory](#1-factory)
        - [Finder](#2-finder)
        - [Action](#3-action)
        - [Routing Interceptor](#4-routing-interceptor)
        - [Context Task](#5-context-task)
        - [Post Routing Task](#6-post-routing-task)
    - [Configuring Step](#configuring-step)
    - [Routing](#routing)
- [Contributing](#contributing)
- [License](#license)
- [Author](#author)

## Installation

RouteComposer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RouteComposer'
```

And then run `pod install`.

Once successfully integrated, just add the following statement to any Swift file where you want to use RouteComposer:

```swift
import RouteComposer
```

Check out the Example app included, as it covers most of the general use cases.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

There are no actual requirements to use this library. But if you are going to implement your custom containers
and actions you should be familiar with the library concepts and UIKit's view controller navigation stack intricacies.

### API documentation

For detailed information on using RouteComposer, see `Documentation/API` folder.

## Usage

RouteComposer uses 3 main entities (`Factory`, `Finder`, `Action`) that should be defined by a host application to support it.
It also provides 3 helping entities (`RoutingInterceptor`, `ContextTask`, `PostRoutingTask`) that you may implement to handle some
default actions during the routing process. There are 3 main `associatedtype` in the description of each entity below:
* `ViewController` - Type of view controller. *UINavigationController, CustomViewController, etc.*
* `Context` - Type of context object that is passed to the router from the hosting application that router will pass to the view controllers it
is going to build. *String, UUID, Any, etc. Can be optional.*
* `Destination` - Type of destination object that is passed to the router from the hosting application that router will pass
to the helping entities. Should extend `RoutingDestination` protocol.

*Example: if your view controllers require productID to display its content and product id is a UUID in your app - then the type of
context is UUID*

## Implementation

#### 1. Factory

Factory is responsible for **building view controllers**, that the router has to navigate to upon request.
Every Factory instance must implement the `Factory` protocol:

```swift
public protocol Factory {

    associatedtype ViewController: UIViewController

    associatedtype Context

    var action: Action { get }

    func prepare(with context: Context) throws

    func build(with context: Context) throws -> ViewController

}
```

The most important function here is `build` which should actually create the view controller. For detailed information
see the documentation. The `prepare` function provides you with a way of doing something before the routing actually takes place.
For example, you could `throw` from inside this function in order to inform the router that you do not have the data required to
display the view correctly. It may be useful if you are implementing Universal Links in your application and the routing can't be
handled, in which case the application might open the provided URL in Safari instead.

*Example: Basic implementation of the factory for some custom `ProductViewController` view controller might look like:*

```swift
class ProductViewControllerFactory: Factory {

    let action: Action

    init(action: Action) {
        self.action = action
    }

    func build(with productID: UUID) throws -> ProductViewController {
        let productViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
        productViewController.productID = productID // Parameter initialisation can be handled by a ContextAction, see below:

        return productViewController
    }

}
```

#### 2. Finder

Finder helps router to **find out if a particular view controller is already present** in view controller stack. All the finder instances
should extend `Finder` protocol.

```swift
public protocol Finder {

    associatedtype ViewController: UIViewController

    associatedtype Context

    func findViewController(with context: Context) -> ViewController?

}
```

In some cases, you may use default finders provided by the library. In other cases, when you can have more than one view controller of
the same type in the stack, you may implement your own finder. There is an implementation of this protocol included called `StackIteratingFinder`
that helps to solve iterations in view controller stack and handles it. You just have to implement the function `isTarget` to determine if it's the
view controller that you are looking for or not.

*Example of `ProductViewControllerFinder` that can help the router find a `ProductViewController` that presents a particular
product in your view controller stack:*

```swift
class ProductViewControllerFinder: StackIteratingFinder {

    let options: SearchOptions

    init(options: SearchOptions = .currentAndUp) {
        self.options = options
    }

    func isTarget(_ productViewController: ProductViewController, with productID: UUID) -> Bool {
        return productViewController.productID == productID
    }

}
```

`SearchOptions` is an enum that informs `StackIteratingFinder` how to iterate through the stack when searching. See documentation.

#### 3. Action

The `Action` instance explains to the router **how the view controller is created by a `Factory` should be integrated into a view controller stack**.
Most likely, you will not need to implement your own actions because the library provides actions for most of the default actions that can be done in
`UIKit` like (`PresentModally`, `AddTab`, `PushToNavigation` etc.). You may need to implement your own actions if you are
doing something unusual.

Check example app to see a custom action implementation.

*Example: As you most likely will not need to implement your own actions, let's look at the implementation of `PresentModally` provided
by the library:*

```swift
class PresentModally: Action {

    func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (_: ActionResult) -> Void) {
        guard existingController.presentedViewController == nil else {
            completion(.failure("\(existingController) is already presenting a view controller."))
            return
        }

        existingController.present(viewController, animated: animated, completion: {
            completion(.continueRouting)
        })
    }

}
```

#### 4. Routing Interceptor

Routing interceptor will be **used by the router before it will start routing to the target view controller.** For example, to navigate to
some particular view controller, the user might need to be logged in. You may create a class that implements the `RoutingInterceptor` protocol
and if the user is not logged in, it will present a login view controller where the user can log in. If this process finishes successfully,
the interceptor should inform the router and it will continue routing or otherwise stop routing. See example app for details.

*Example: If the user is logged in, router can continue routing. If the user is not logged in, the router should not continue*

```swift
class LoginInterceptor: RoutingInterceptor {

    func execute(for destination: AppDestination, completion: @escaping (_: InterceptorResult) -> Void) {
        guard !LoginManager.sharedInstance.isUserLoggedIn else {
            completion(.failure("User has not been logged in."))
            return
        }
        completion(.success)
    }

}

```

#### 5. Context Task

If you are using one default `Factory` and `Finder` implementation provided by the library, you still need to **set data in
context to your view controller.** You have to do this even if it already exists in the stack, if it's just going to be created by a `Factory` or do any other
actions at the moment when router found/created a view controller. Just implement `ContextTask` protocol.

*Example: Even if `ProductViewController` is present on the screen or it is going to be created you have to set productID to
present a product.*

```swift
class ProductViewControllerContextTask: ContextTask {

    func apply(on productViewController: ProductViewController, with productID: UUID) {
        productViewController.productID = productID
    }

}
```

See example app for the details.

#### 6. Post Routing Task

A post-routing task will be called by the router **after it successfully finishes navigating to the target view controller**.
You should implement `PostRoutingTask` protocol and create all necessary actions there.

*Example: You need to log an event in your analytics every time the user lands on a product view controller:*

```swift
class ProductViewControllerPostTask: PostRoutingTask {

    let analyticsManager: AnalyticsManager

    init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
    }

    func execute(on productViewController: ProductViewController, for destination: AppDestination, routingStack: [UIViewController]) {
        analyticsManager.trackProductView(productID: productViewController.productID)
    }

}
```

### Configuring Step

Everything that the router does is configured using a `RoutingStep` instance. There is no need to create your own implementation of this protocol.
Use `StepAssembly` provided by the library to configure any step that the router should execute during the routing.

*Example: A `ProductViewController` configuration that explains to the router that it should be boxed in UINavigationController
which should be presented modally from any currently visible view controller.*

```swift
let productScreen = StepAssembly(finder: ProductViewControllerFinder(), factory: ProductViewControllerFactory(action: PushToNavigationAction()))
        .add(LoginInterceptor())
        .add(ProductViewControllerContextTask())
        .add(ProductViewControllerPostTask(analyticsManager: AnalyticsManager.sharedInstance))
        .from(NavigationControllerStep(action: DefaultActions.PresentModally()))
        .from(CurrentControllerStep())
        .assemble()
```

This configuration means:

* Use `ProductViewControllerFinder` to potentially **find** an exisiting product view controller in the stack, or **create** it using `ProductViewControllerFactory` if it has not been found.
* If it was created **push** it in to navigation stack
* Navigation stack should be provided from another step `NavigationControllerStep`, that will create a `UINavigationController` instance
* The `UINavigationController` instance should be presented modally from any currently visible view controller.
* Before routing run `LoginInterceptor`
* After view controller been created or found, run `ProductViewControllerContextTask`
* After successful routing run `ProductViewControllerPostTask`

*See example app to find out different ways to provide and store routing step configurations.*

### Routing

After you have implemented all necessary classes and configured a routing step, you can start to use the `Router` to navigate. The library provides
a `DefaultRouter` which is an implementation of the `Router` protocol to handle routing based on the configuration explained above. The Router accepts a
destination instance that extends `RoutingDestination` protocol. The `RoutingDestination` protocol contains the final step the user has to land on. It also contains a context object that has data which is provided to a view controller, if required.

*Example: The user taps on a cell in a `UITableView`. It then asks the router to navigate the user to `ProductViewController`. The user
should be logged in to see the product details.*

```swift
struct AppDestination: RoutingDestination {

    let finalStep: RoutingStep

    let context: Any?

}

struct Configuration {

    static func productDestination(with productID: UUID) -> AppDestination {
        let productScreen = StepAssembly(finder: ProductViewControllerFinder(), factory: ProductViewControllerFactory(action: PushToNavigationAction()))
                .add(LoginInterceptor())
                .add(ProductViewControllerContextTask())
                .add(ProductViewControllerPostTask(analyticsManager: AnalyticsManager.sharedInstance))
                .from(NavigationControllerStep(action: DefaultActions.PresentModally()))
                .from(CurrentViewControllerStep())
                .assemble()

        return AppDestination(finalStep: productScreen, context: productID)
    }

}

class ProductArrayViewController: UITableViewController {

    let products: [UUID]?

    let router = DefaultRouter()

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let productID = products[indexPath.row] else {
            return
        }
        router.navigate(to: Configuration.productDestination(with: productID))
    }

}
```

*Example below shows the same process without the use of RouteComposer*

```swift
class ProductArrayViewController: UITableViewController {

    let products: [UUID]?

    let analyticsManager = AnalyticsManager.sharedInstance

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let productID = products[indexPath.row] else {
            return
        }

        // Handled by LoginInterceptor
        guard !LoginManager.sharedInstance.isUserLoggedIn else {
            return
        }

        // Handled by a ProductViewControllerFactory
        let productViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)

        // Handled by ProductViewControllerContextTask
        productViewController.productID = productID

        // Handled by NavigationControllerStep and PushToNavigationAction
        let navigationController = UINavigationController(rootViewController: productViewController)

        // handled by DefaultActions.PresentModally
        present(alertController, animated: navigationController) { [weak self]
            // Handled by ProductViewControllerPostTask
            self?.analyticsManager.trackProductView(productID: productID)
        }
    }

}
```

In the example without `RouteComposer` the code may seem simpler, however, everything is hardcoded in the actual function implementation. 
`RouteComposer` allows you to split everything into small reusable pieces and store navigation configuration separately from
your view logic. Also, the above implementation will grow dramatically when you try to add Universal Link support to your app.
Especially if you will have to choose from opening `ProductViewController` from a universal link if it is already present on the
screen or not and so on. With the library, each of your view controllers is deep linkable by nature.

As you can see from the examples above the `Router` does not do anything that tweaks `UIKit` basis. It just allows you to break the
navigation process into small reusable pieces. The router will call them in a proper order based on the configuration provided.
The library does not break the rules of VIPER or MVVM architectural patterns and can be used in parallel with them.

See example app for other examples of defining routing configurations and instantiating router.

## Contributing

RouteComposer is in active development, and we welcome your contributions.

If you’d like to contribute to this repo, please
read [the contribution guidelines](https://github.com/gilt/Cleanroom#contributing-to-the-cleanroom-project).

### License

RouteComposer is distributed under [the MIT license](https://github.com/saksdirect/RouteComposer/blob/master/LICENSE).

RouteComposer is provided for your use, free-of-charge, on an as-is basis. We make no guarantees, promises or
apologies. *Caveat developer.*


## Author

Evgeny Kazaev, eugene.kazaev@hbc.com

