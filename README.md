# RouteComposer

[![CI Status](https://travis-ci.org/ekazaev/route-composer.svg?branch=master&style=flat)](https://travis-ci.org/ekazaev/route-composer)
[![Release](https://img.shields.io/github/release/ekazaev/route-composer.svg?style=flat&color=darkcyan)](https://github.com/ekazaev/route-composer/releases)
[![Cocoapods](https://img.shields.io/cocoapods/v/RouteComposer.svg?style=flat)](http://cocoapods.org/pods/RouteComposer)
[![Swift Package Manager](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-compatible-0AB42A.svg?style=flat)](https://developer.apple.com/xcode/swiftui/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BA51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift 5.7](https://img.shields.io/badge/language-Swift5.7-orange.svg?style=flat)](https://developer.apple.com/swift)
[![Platform iOS](https://img.shields.io/badge/platform-iOS%209%20—%20iOS%2016-yellow.svg)](https://www.apple.com/ios)
[![Documentation](https://ekazaev.github.io/route-composer/badge.svg)](https://ekazaev.github.io/route-composer)
[![Code coverage](https://codecov.io/gh/ekazaev/route-composer/branch/master/graphs/badge.svg?style=flat)](https://ekazaev.github.io/route-composer/tests/index.html)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d54c6461dab64cc5a3be79734588de52)](https://app.codacy.com/gh/ekazaev/route-composer?utm_source=github.com&utm_medium=referral&utm_content=ekazaev/route-composer&utm_campaign=Badge_Grade_Settings)
[![MIT License](https://img.shields.io/cocoapods/l/RouteComposer.svg?style=flat)](https://github.com/ekazaev/RouteComposer/blob/master/LICENSE)
[![Twitter](https://img.shields.io/twitter/url/https/github.com/ekazaev/route-composer.svg?style=flat)](https://twitter.com/intent/tweet?text=Check%20it%20out:&url=https%3A%2F%2Fgithub.com%2Fekazaev%2Froute-composer)

`RouteComposer` is the protocol oriented, Cocoa UI abstractions based library that helps to handle view controllers composition, navigation
and deep linking tasks in the iOS application. 

Can be used as the universal replacement for the [Coordinator](https://www.raywenderlich.com/158-coordinator-tutorial-for-ios-getting-started) pattern.

![](https://habrastorage.org/webt/x7/yt/ll/x7ytllwqwgvgxy2rvtmdwj3qkia.png)

## Table of contents

- [Navigation concerns](#navigation-concerns)
- [Installation](#installation)
- [Example](#example)
- [Requirements](#requirements)
- [Testimonials](#testimonials)
- [Sponsor this project](#sponsor-this-project)
- [Usage](#usage)
    - [Implementation](#implementation)
        - [Factory](#1-factory)
        - [Finder](#2-finder)
        - [Action](#3-action)
        - [Routing Interceptor](#4-routing-interceptor)
        - [Context Task](#5-context-task)
        - [Post Routing Task](#6-post-routing-task)
    - [Configuring Step](#configuring-step)
    - [Navigation](#navigation)
    - [Container View Controllers](#container-view-controllers)
    - [Deep-linking](#deep-linking)
    - [Troubleshooting](#troubleshooting)
- [SwiftUI](#swiftui)
- [Advanced Configuration](#advanced-configuration)
- [Contributing](#contributing)
- [License](#license)
- [Articles](#articles)
- [Author](#author)

## Navigation concerns

There are 2 ways of implementing the navigation available in the iOS application:
- Built-in mechanism provided by Apple using storyboards and segues
- Programmatic navigation directly in the code

The downsides of these two solutions:
- Built-in mechanism: navigation in the storyboards is relatively static and often requires the extra navigation code in the 
`UIViewController`s and can lead to a lot of boilerplate code
- Programmatic navigation: forces `UIViewController`s coupling or can be complex depending on the chosen design 
pattern (Router, Coordinator) 

## RouteComposer helps

- Facilitate the cutting of an application into small logical steps of navigation
- Provide the navigation configuration in a declarative way and address the majority of the navigation cases
- Remove navigation code from `UIViewController`s
- Allow the composition of the `UIViewController`s in different ways according to the application state
- Make every `UIViewController` deep-linkable out of the box
- Simplify the creation of the User facing A/B tests with the different navigation and layout patterns
- Able to work side-by-side with any other navigation mechanism that exist in the IOs application: Builtin or custom

## Installation

RouteComposer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RouteComposer'
```

**For Xcode 10.1 / Swift 4.2 Support**

```ruby
pod 'RouteComposer', '~> 1.4'
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

Detailed API documentation can be found [here](https://ekazaev.github.io/route-composer/). 
Test coverage - [here](https://codecov.io/gh/ekazaev/route-composer) 

## Testimonials

#### Viz.ai

> At Viz.ai, the leading synchronised stroke care service, we went into replacing our entire navigation system, and we knew we needed to 
address complex and dynamic navigation scenarios. Coordinators and other flow-control libraries just didn't answer our needs, and 
lead to mixing application logic and navigation, or creating massive coordinator classes.
> RouteComposer was an amazing fit for us, and actually, as the creator of this library states, it *is* the drop in replacement for any 
coordinator code you currently use.
>
> The separation of concerns on this library is absolutely beautiful, and as with anything genius, it all works like magic.
It does have a small learning curve, but one that pays off far more than coordinators and flow controllers, and will save 
you a ton of coding once you implement it.
>
>It makes navigation in the app as simple as saying "go to x with y" and not worrying about the current state or stack.
I wholeheartedly recommend it.
>
>**Elazar Yifrach, Sr iOS Developer @ Viz.ai**

#### Hudson's Bay Company

> In our iOS app we wanted to provide a seamless experience for our users to guarantee that whenever they click on a 
push notification or a link in an email, they will land on the required view in the app seamlessly no matter of the state 
of the app.
>
> We tried a programmatic navigational approach in the code and also tried to rely on a few other libraries. However, 
none of them seemed to do the trick. RouteComposer was not our first choice as originally it looked too complex. Thankfully,
it turned out to be a fantastic and elegant solution. We started to use it not only to handle external deeplinking but 
also to handle our internal navigation within the app.It also turned out to be a great tool for UI A/B tests when you 
have different navigation patterns for different users. It saved us a load of time, and we really like the logic behind it.
>
> The creator of the library is super responsive and helped with all questions that we had. I would thoroughly recommend it!
>
> **Alexandra Mikhailouskaya, Senior lead engineer @ Hudson's Bay Company**

#### B.W.A., 130 year old retail bank.

> We recently performed our fifth and largest app update which involved restructuring the user navigation from scratch. We started with a simple migration of our existing (six-file long) coordinator before one of our senior devs suggested we trial RouteComposer. The proof of concept was challenging, but Eugene Kazaev put himself at my disposal to work through retrofitting the RouteComposer into our existing enterprise-grade codebase and when the pieces all fell into place, the result was simplicity itself.
> 
> Our other devs have embraced the RouteComposer in lieu of segues, unwind segues, manual pushes, pops, and modal drops and the resulting navigtion around our app is delightful.
> 
> Great thanks to Eugene for all his help.
> **skooter Martin, Senior Specialist Mobile Engineer @ B.W.A.**

## Sponsor this project

If you like this library and especially if you are using it in production please consider sponsoring this
project [here](https://github.com/sponsors/ekazaev). I work on `RouteComposer` in my spare time. Sponsorship
will help me to work on this project and continue to contribute to the Open Source community.

## Usage

RouteComposer uses 3 main entities (`Factory`, `Finder`, `Action`) that should be defined by a host application to support it.
It also provides 3 helping entities (`RoutingInterceptor`, `ContextTask`, `PostRoutingTask`) that you may implement to handle some
default actions during the routing process. There are 2 `associatedtype` in the description of each entity below:
* `ViewController` - Type of view controller. *UINavigationController, CustomViewController, etc.*
* `Context` - Type of context object that is passed to the router from the hosting application that router will pass to the view controllers it
is going to build. *String, UUID, Any, etc. Can be optional.*

**NB**

`Context` represents a payload that you need to pass to your `UIViewController` and something that distinguishes it from others.
It is not a View Model or some kind of Presenter. It is the missing piece of information. If your view controller requires a 
`productID` to display its content, and the `productID` is a `UUID`, then the type of `Context` is the `UUID`. The internal logic 
belongs to the view controller. `Context` answers the questions *What to I need to present a ProductViewController* and *Am I 
already presenting a ProductViewController for this product*.

## Implementation

#### 1. Factory

Factory is responsible for **building view controllers**, that the router has to navigate to upon request.
Every Factory instance must implement the `Factory` protocol:

```swift
public protocol Factory {

    associatedtype ViewController: UIViewController

    associatedtype Context

    func build(with context: Context) throws -> ViewController

}
```

The most important function here is `build` which should actually create the view controller. For detailed information
see the [documentation](https://ekazaev.github.io/route-composer/Protocols/Factory.html#/s:13RouteComposer7FactoryP5build4with14ViewControllerQz7ContextQz_tKF). 
The `prepare` function provides you with a way of doing something before the routing actually takes place.
For example, you could `throw` from inside this function in order to inform the router that you do not have the data required to
display the view correctly. It may be useful if you are implementing Universal Links in your application and the routing can't be
handled, in which case the application might open the provided URL in Safari instead.

*Example: Basic implementation of the factory for some custom `ProductViewController` view controller might look like:*

```swift
class ProductViewControllerFactory: Factory {

    func build(with productID: UUID) throws -> ProductViewController {
        let productViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
        productViewController.productID = productID // Parameter initialisation can be handled by a ContextAction, see below:

        return productViewController
    }

}
```
*Important note: Automatic `associatedtype` resolution is broken in Xcode 10.2, you must set associated types manually using `typealias` keyword. 
Swift compiler [bug](https://bugs.swift.org/browse/SR-10186) reported.*

#### 2. Finder

Finder helps router to **find out if a particular view controller is already present** in view controller graph. All the finder instances
should conform to `Finder` protocol.

```swift
public protocol Finder {

    associatedtype ViewController: UIViewController

    associatedtype Context

    func findViewController(with context: Context) throws -> ViewController?

}
```

In some cases, you may use default finders provided by the library. In other cases, when you can have more than one view controller of
the same type in the graph, you may implement your own finder. There is an implementation of this protocol included called `StackIteratingFinder`
that helps to solve iterations in view controller graph and handles it. You just have to implement the function `isTarget` to determine if it's the
view controller that you are looking for or not.

*Example of `ProductViewControllerFinder` that can help the router find a `ProductViewController` that presents a particular
product in your view controller stack:*

```swift
class ProductViewControllerFinder: StackIteratingFinder {

    let iterator: StackIterator = DefaultStackIterator()

    func isTarget(_ productViewController: ProductViewController, with productID: UUID) -> Bool {
        return productViewController.productID == productID
    }

}
```

`SearchOptions` is an enum that informs `StackIteratingFinder` how to iterate through the graph when searching. See [documentation](https://ekazaev.github.io/route-composer/Structs/SearchOptions.html).

#### 3. Action

The `Action` instance explains to the router **how the view controller is created by a `Factory` should be integrated into a view controller stack**.
Most likely, you will not need to implement your own actions because the library provides actions for most of the default actions that can be done in
`UIKit` like (`GeneralAction.presentModally`, `UITabBarController.add`, `UINavigationController.push` etc.). You may need to implement your own actions if you are
doing something unusual.

Check example app to see a custom action implementation.

*Example: As you most likely will not need to implement your own actions, let's look at the implementation of `PresentModally` provided
by the library:*

```swift
class PresentModally: Action {

    func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
        existingController.present(viewController, animated: animated, completion: {
            completion(.success)
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
class LoginInterceptor<C>: RoutingInterceptor {

    func perform(with context: C, completion: @escaping (_: RoutingResult) -> Void) {
        guard !LoginManager.sharedInstance.isUserLoggedIn else {
            completion(.failure("User has not been logged in."))
            return
            // Or present the LoginViewController. See Example app for more information. 
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

    func perform(on productViewController: ProductViewController, with productID: UUID) {
        productViewController.productID = productID
    }

}
```

See example app for the details.

*Or use `ContextSettingTask` provided with the library to avoid extra code.*

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

    func perform(on productViewController: ProductViewController, with productID: UUID, routingStack: [UIViewController]) {
        analyticsManager.trackProductView(productID: productViewController.productID)
    }

}
```

### Configuring Step

Everything that the router does is configured using a `DestinationStep` instance. There is no need to create your own implementation of this protocol.
Use `StepAssembly` provided by the library to configure any step that the router should execute during the routing.

*Example: A `ProductViewController` configuration that explains to the router that it should be boxed in UINavigationController
which should be presented modally from any currently visible view controller.*

```swift
let productScreen = StepAssembly(finder: ProductViewControllerFinder(), factory: ProductViewControllerFactory())
        .add(LoginInterceptor<UUID>()) // Have to specify the context type till https://bugs.swift.org/browse/SR-8719, https://bugs.swift.org/browse/SR-8705 are fixed
        .add(ProductViewControllerContextTask())
        .add(ProductViewControllerPostTask(analyticsManager: AnalyticsManager.sharedInstance))
        .using(UINavigationController.push())
        .from(NavigationControllerStep())
        .using(GeneralActions.presentModally())
        .from(GeneralStep.current())
        .assemble()
```

This configuration means:

* Use `ProductViewControllerFinder` to potentially **find** an existing product view controller in the stack, or **create** it using `ProductViewControllerFactory` if it has not been found.
* If it was created **push** it into a navigation stack
* Navigation stack should be provided from another step `NavigationControllerStep`, that will create a `UINavigationController` instance
* The `UINavigationController` instance should be presented modally from any currently visible view controller.
* Before routing run `LoginInterceptor`
* After view controller been created or found, run `ProductViewControllerContextTask`
* After successful routing run `ProductViewControllerPostTask`

*See example app to find out different ways to provide and store routing step configurations.*

*See advanced `ProductViewController` configuration [here](https://ekazaev.github.io/route-composer/examples.html#the-code-productviewcontroller-code-should-be-pushed-into-any-code-uinavigationcontroller-code-if-it-is-present-on-the-screen-if-not-presented-modally).*

### Navigation

After you have implemented all necessary classes and configured a routing step, you can start to use the `Router` to navigate. The library provides
a `DefaultRouter` which is an implementation of the `Router` protocol to handle routing based on the configuration explained above.

*Example: The user taps on a cell in a `UITableView`. It then asks the router to navigate the user to `ProductViewController`. The user
should be logged into see the product details.*

```swift

struct Configuration {

    static let productScreen = StepAssembly(finder: ProductViewControllerFinder(), factory: ProductViewControllerFactory())
                .add(LoginInterceptor<UUID>())
                .add(ProductViewControllerContextTask())
                .add(ProductViewControllerPostTask(analyticsManager: AnalyticsManager.sharedInstance))
                .using(UINavigationController.push())
                .from(NavigationControllerStep())
                .using(GeneralActions.presentModally())
                .from(GeneralStep.current())
                .assemble()

}

class ProductArrayViewController: UITableViewController {

    let products: [UUID]?

    let router = DefaultRouter()

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let productID = products[indexPath.row] else {
            return
        }
        try? router.navigate(to: Configuration.productScreen, with: productID)
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

        // Handled by NavigationControllerStep and UINavigationController.push
        let navigationController = UINavigationController(rootViewController: productViewController)

        // handled by DefaultActions.PresentModally
        present(navigationController, animated: true) { [weak self] in
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

## Container View Controllers

There are view controllers like `UINavigationController`, `UITabBarController`, `UISplitController` and so on, that can contain 
other view controllers inside them. `RouteComposer` calls one such view controller, `ContainerViewController`s. As each container 
view controller has its own unique methods of interacting with the contained view controllers, `RouteComposer` uses special 
entities called [ContainerAdapter](https://ekazaev.github.io/route-composer/Protocols/ContainerAdapter.html)s. The `RouteComposer`
contains built-in adapters for the main container view controllers that come with `UIKit`. You can create your own `ContainerAdapter`s 
if you are using your own custom container view controllers or ones that come from another library. If you want `RouteComposer` to work 
correctly with such containers, switch their tabs or make another view controller visible within them e.t.c. 
Please check the Example app for the reference.

## Deep-linking

With `RouteComposer` every view controller becomes deep-linkable out of the box. You can also provide different configuration in case
the screen is being opened using universal link. See Example app for more information. 

```swift
    let router = DefaultRouter()

    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        guard let productID = extractProductId(from: url) else {
            return false
        }
        try? router.navigate(to: Configuration.productScreen, with: productID)
        return true
    }
```

## Troubleshooting

If for some reason you are unsatisfied with the result and you think that it is the Routers issue, or you found that your particular case is not covered, you can always
temporarily replace the router with your custom implementation and implement simple routing yourself. Please, create a [new issue](https://github.com/ekazaev/route-composer/issues/new)
and we will try to fix the issue as soon as possible.

*Example:*
```swift
     func goToProduct(with productId: UUID) {
        // If view controller with this product id is present on the screen - do nothing
        guard ProductViewControllerFinder(options: .currentVisibleOnly).getViewController(with: productId) == nil else {
            return
        }
        
        /// Otherwise, find visible `UINavigationController`, build `ProductViewController`
        guard let navigationController = ClassFinder<UINavigationController, Any?>(options: .currentVisibleOnly).getViewController(),
              let productController = try? ProductViewControllerFactory().execute(with: productId) else {
            return
        }
        
        /// Apply context task if necessary
        try? ProductViewControllerContextTask().execute(on: productController, with: productId)

        /// Push `ProductViewController` into `UINavigationController`
        navigationController.pushViewController(productController, animated: true)
    }
```

## SwiftUI:

`RouteComposer` is compatible with [SwiftUI](https://developer.apple.com/xcode/swiftui/). See example app for the details.

## Advanced Configuration:

You can find more configuration examples [here](https://ekazaev.github.io/route-composer/examples.html).

## Contributing

RouteComposer is in active development, and we welcome your contributions.

If you’d like to contribute to this repo, please
read [the contribution guidelines](https://github.com/ekazaev/route-composer/blob/master/CONTRIBUTING.md).

## License

RouteComposer is distributed under [the MIT license](https://github.com/ekazaev/RouteComposer/blob/master/LICENSE).

RouteComposer is provided for your use, free-of-charge, on an as-is basis. We make no guarantees, promises or
apologies. *Caveat developer.*

## Articles

English:

  - [Composition of UIViewControllers and navigation between them](https://itnext.io/composition-of-uiviewcontrollers-and-navigation-between-them-and-not-only-15b825da5ac)
  - [Going deeper into the RouteComposer configuration](https://itnext.io/going-deeper-into-the-routecomposer-configuration-3a54661bb16a)
  - [Coordinator Pattern’s Issues & What is RouteComposer](https://itnext.io/coordinator-patterns-issues-what-is-routecomposer-8b50a0477917)

Russian:

  - [Композиция UIViewController-ов и навигация между ними](https://habr.com/post/421097/)
  - [Примеры конфигурации UIViewController-ов используя RouteComposer](https://habr.com/post/428990/)
  - [Проблемы паттерна Координатор и при чем тут RouteComposer](https://habr.com/ru/post/446550/)

## Author

Evgeny Kazaev, eugene.kazaev@gmail.com. Twitter [ekazaev](https://twitter.com/EKazaev)

*I am happy to answer any questions you may have. Just create a [new issue](https://github.com/ekazaev/route-composer/issues/new).*

