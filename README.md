# DeepLinkLibrary

[![CI Status](http://img.shields.io/travis/ekazaev/DeepLinkLibrary.svg?style=flat)](https://travis-ci.org/ekazaev/DeepLinkLibrary)
[![Version](https://img.shields.io/cocoapods/v/DeepLinkLibrary.svg?style=flat)](http://cocoapods.org/pods/DeepLinkLibrary)
[![License](https://img.shields.io/cocoapods/l/DeepLinkLibrary.svg?style=flat)](http://cocoapods.org/pods/DeepLinkLibrary)
[![Platform](https://img.shields.io/cocoapods/p/DeepLinkLibrary.svg?style=flat)](http://cocoapods.org/pods/DeepLinkLibrary)

### License

DeepLinkLibrary is distributed under [the MIT license](https://github.com/saksdirect/DeepLinkLibrary/blob/master/LICENSE).

DeepLinkLibrary is provided for your use—free-of-charge—on an as-is basis. We make no guarantees, promises or apologies. *Caveat developer.*

## Installation

DeepLinkLibrary is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DeepLinkLibrary'
```

And then run `pod install`. 

Once successfully integrated, just add the following statement to any Swift file where you want to use DeepLinkLibrary:

```swift
import DeepLinkLibrary
```

Please, check an Example app, it covers most cases you can come across.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

There are no actual requirements to use a library. But if you are going to implement your custom containers 
and actions you have to be familiar with library concepts and UIKit's view controllers stack laws.

### API documentation

For detailed information on using DeepLinkLibrary, see `Documentation/API` folder.

### Usage

DeepLinkingLibrary uses 3 main entities *(Factory, Finder, Action)* that should be defined by a host application to support it.
also it provides 3 helping (`RouterInterceptor`, `ContextTask`, `PostRoutingTask`) entities that you may implement to handle some default actions during routing process.
Below in the description of each entity 2 main meaning will
be used:
* `ViewController` - Type of view controller. *UINavigationController, CustomViewController, etc.*
* `Context` - Type of context object that is passed to the router from the hosting application that router will pass to view controllers it is going to build.
*Example: if your view controllers requires productID to display it content and product id is a UUID in your app - then type of context is UUID*

### Implementation

#### 1. Factory

Factory explains router **how to create view controller** it has to navigate to. Every factory instance has to extend Protocol factory provided by a library:

```swift
public protocol Factory: class {

    associatedtype ViewController: UIViewController

    associatedtype Context

    var action: Action { get }

    func prepare(with context: Context?) throws

    func build(with context: Context?) throws -> ViewController

}

```

The most important method method here is `build` which should actually create a view controller. For the detailed information see documentation.
Method `prepare` helps router to know that routing can not be handled before it will actually start routing and find out that factory can not build
a view controller without context. It may be handy if you are implementing Universal Links in your application and if routing can not be handled open
provided URL in Safari instead.
*Example: Basic implementation of the factory for some custom *ProductViewController* view controller will look like:*

```swift
class ProductViewControllerFactory: Factory {

    typealias ViewController = ProductViewController

    typealias Context = UUID

    let action: Action

    init(action: Action) {
        self.action = action
    }

    func prepare(with context: Context?) throws {
        guard let _ = context else {
            throw RoutingError.message("Product id must be set to create ProductViewController")
        }
    }

    func build(with context: Context?) throws -> ViewController {
        guard let context = context else {
            throw RoutingError.message("Product id must be set to create ProductViewController")
        }
        let productViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
        productViewController.productID = context // Can be handled by ContextAction, see below:

        return productViewController
    }

}
```

#### 2. Finder

Finder helps router to **find out if a view controller already present** in view controller stack. All the finder instances should extend `Finder` protocol.

```swift
public protocol Finder {

    associatedtype ViewController: UIViewController

    associatedtype Context

    func findViewController(with context: Context?) -> ViewController?

}
```

In some cases you may use default finders provided by a library. In other cases when you can have more then one view controller ot the same type
in the stack you should implement your own finder. There a version of this protocol called `FinderWithPolicy` that helps to solve iteration in view controller stack and handles
it, you just have to implement method `isTarget` to answer if its a view controller router is looking for or not.

*Example of ProductViewController finder that can help router to find a ProductViewController that presents particular product in your view controller
stack:*

```swift
class ProductViewControllerFinder: FinderWithPolicy {

    typealias ViewController = ProductViewController

    typealias Context = UUID

    let policy: FinderPolicy

    init(policy: FinderPolicy = .currentLevel) {
        self.policy = policy
    }

    func isTarget(viewController: ViewController, context: Context?) -> Bool {
        guard let context = context else {
            return false
        }

        return viewController.productID == context
    }

}
```

`FinderPolicy` here is an enum that explains `FinderWithPolicy` how it should iterate through the stack
* `allStackUp` - start to search from `UIWindow`'s root view controller and go up through the stack by all presented view controllers.
* `allStackDown` - start to search from topmost presented view controller and go down through the stack by all presenting view controllers till it reach
`UIWindow`'s root view controller.
* `currentLevel` - start to search in topmost presented view controller and its child view controllers only
* `topMost` - Just test if the topmost presented view controller is the one that router is looking for.

#### 3. Action

`Action` instance explains router **how view controller created by a `Fabric` should be integrated in to a view controller stack**. Most likely you
will not need to implement your own actions because library provides actions for most of default action that can be done in `UIKit` like
(`PresentModallyAction`, `AddTabAction`, `PushAction` etc.) , you may need to implement your own actions if you are implementing something unusual.
Check example app to see custom action implementation.

*Example: As you most likely will not need to implement your own actions, lets look at the implementation of `PresentModallyAction` provided
by a library:*

```swift
class PresentModallyAction: Action {

    init() {}

    func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (_: ActionResult) -> Void) {
        guard existingController.presentedViewController == nil else {
            completion(.failure("\(existingController) has already presented view controller."))
            return
        }

        existingController.present(viewController, animated: animated, completion: {
            completion(.continueRouting)
        })
    }

}
```

#### 4. Router Interceptor

Router interceptor will be **used by router before it will start routing to the target** view controller. For example to navigate to some particular view
controller user should be logged in. You may implement your class that extends `RouterInterceptor` protocol and if user is not logged in it will present
login view controller where user can login and if this process will finish successfully interceptor should inform router and it will continue routing and
stop routing otherwise. See example app for details.

*Example: If user logged router can continue routing and should not continue if not*

```swift
class LoginInterceptor: RouterInterceptor {

    typealias Context = Any // LoginInterceptor can be applied to any view controller with any context

    func execute(with context: Context?, completion: @escaping (_: InterceptorResult) -> Void) {
        guard !LoginManager.sharedInstance.isUserLoggedIn else {
            completion(.failure("User has not been logged in."))
            return
        }
        completion(.success)
    }

}

```

#### 5. Context Action

In case you are using one default `Fabric` and `Finder` implementations provided by a library but you still need to **set data in context to your
view controller** no mater if it already exist in the stack or just going to be created by a `Fabric` or do any other actions at the moment when
router found/created a view controller. Just extend `ContextTask` protocol.

*Example: No mater if `ProductViewController` is present on the screen or it is going to be created you have to set productID to present a product.*

```swift
class ProductViewControllerContentTask: ContextTask {

    typealias ViewController = ProductViewController

    typealias Context = UUID

    func apply(on viewController: ViewController, with context: Context?) {
        guard let context = context else {
            return
        }
        viewController.productID = content
    }

}
```

See example app for the details.

#### 5. Post routing task

Post routing task will be called by a router **after it will successfully finish navigation to the target view controller**. You should extend
`PostRoutingTask` protocol and implement all necessary actions there.

*Example: You need to log in to your analytics an event every time user lands on a product view controller:*

```swift
class ProductViewControllerPostAction: PostRoutingTask {

    typealias ViewController = ProductViewController

    typealias Context = UUID

    let analyticsManager: AnalyticsManager

    init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
    }

    func execute(on viewController: ViewController, with context: Context?, routingStack: [UIViewController]) {
        analyticsManager.trackProductView(productID: viewController.productID)
    }

}
```

### Steps

Everything that router does is configured using `RoutingStep` instance. There is no need to create your own implementation of this protocol, use
`ScreenStepAssembly` provided by a library to configure andy step that router should execute during the routing.

*Example: `ProductViewController` step configuration that explains to router that it should be presented boxed in UINavigationController which should be
presented modally from any currently visible view controller.*

```swift
let colorScreen = ScreenStepAssembly(finder: ProductViewControllerFinder(), factory: ProductViewControllerFactory(action: PushAction()))
        .add(LoginInterceptor())
        .add(ProductViewControllerContentTask())
        .add(ProductViewControllerPostAction(analyticsManager: AnalyticsManager.sharedInstance))
        .from(NavigationContainerStep(action: PresentModallyAction()))
        .from(TopMostViewControllerStep())
        .assemble()
```

This configuration means:

* Use `ProductViewControllerFinder` to **find** view controller in stack and **create** it using `ProductViewControllerFactory` if it has not been found.
* If it was created **push** it in to navigation stack
* Navigation stack should be provided **from** another step `NavigationContainerStep` that will create `UINavigationController` instance
* `UINavigationController` instance should be presented modally **from** any currently visible view controller.
* Before routing run `LoginInterceptor`
* After view controller been created or found run `ProductViewControllerContentTask`
* After successful routing run `ProductViewControllerPostAction`

*See example app to find out different ways to provide and store routing step configurations.*

### Routing

After you implemented all necessary classes and configured routing step you can actually start to use `Router` to navigate. Library provides `DefaultRouter`
which is an instance of `Router` protocol to handle routing based on the configuration explained above. Router accept a destination instance that extends
`RoutingDestination` protocol contains final step use has to land on a context object if its needed that contains data to be provided to a view controllers
on its way.

*Example: User taps on some button and it asks router to navigate user to `ProductViewController`*

```swift
struct Destination: RoutingDestination {

    let finalStep: RoutingStep

    let context: Any?

}

struct Configuration {

    static func productDestination(with productID: UUID) {
        let colorScreen = ScreenStepAssembly(finder: ProductViewControllerFinder(), factory: ProductViewControllerFactory(action: PushAction()))
                .add(LoginInterceptor())
                .add(ProductViewControllerContentTask())
                .add(ProductViewControllerPostAction(analyticsManager: AnalyticsManager.sharedInstance))
                .from(NavigationContainerStep(action: PresentModallyAction()))
                .from(TopMostViewControllerStep())
                .assemble()

        return Destination(finalStep: colorScreen, context: productID)
    }

}

class ProductArrayViewController: UITableViewController {

    let products: [UUID]?

    let router = DefaultRouter()

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let productID = products[indexPath.row] else {
            return
        }
        router.deepLinkTo(destination: Configuration.productDestination(with: productID))
    }

}
```


*Example below shows the same process without use of DeepLinkingLibrary*

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

        // Handled by ProductViewControllerContentTask
        productViewController.productID = productID

        // Handled by NavigationContainerStep and PushAction
        let navigationController = UINavigationController(rootViewController: productViewController)

        // handled by PresentModallyAction
        present(alertController, animated: navigationController) { [weak self]
            // Handled by ProductViewControllerPostAction
            self?.analyticsManager.trackProductView(productID: productID)
        }
    }

}
```

In the example without `DeepLinkingLibrary` code may seem simpler, but everything is hardcoded in the actual method implementation, when `DeepLinkingLibrary`
allows you to split everything in to small reusable pieces and store navigation configuration separately from your view logic. Also, implementation above
will grow dramatically when you'll try to add Universal Links support in to your app especially if you will have to decide should you open
`ProductViewController` from a universal link if it is already present on the screen or not and so on. With library each of your view controller
is deeplinkable by it's nature.

As you can see from the examples above `Router` does not do anything that tweaks `UIKit` basis. It just allows you to break navigation process in to
small reusable pieces and router will call them in a proper order based on the configuration provided.
Library does not break the rules of VIPER or MVVM architectural patterns and can be used in parallel with them.

See example app for other examples of defining routing configurations and instantiating router.

### Contributing

DeepLinkLibrary is in active development, and we welcome your contributions.

If you’d like to contribute to this repo, please read [the contribution guidelines](https://github.com/gilt/Cleanroom#contributing-to-the-cleanroom-project).

## Author

Evgeny Kazaev, ekazaev@gilt.com

