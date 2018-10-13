# Deeper into the configuration

### How the `Router` parses the configuration:

The `Router` goes by the chain of steps starting from the first step. If the `Finder` of this step says that the `UIViewController` of this step does not exist, it moves on to the next one. It does this until one of the finders say that it has found the `UIViewController` described in the chain. Then `Router` starts to move backwards through the chain of steps and starts to create the `UIViewController` for each step using its `Factory` and integrates it into the stack using the `Action` attached to this step.

It is easier to think about how to configure your routing to the `UIViewController` if you start to think that the user can be anywhere in the application and has received an universal link that requests your application to show a particular `UIViewController`.

### `StackIteratingFinder` options:

Behaviour of the `StackIteratingFinder` can be changed using the `SearchOptions`. They are:

- `current`: The topmost view controller
- `visible`: If the view controller is a container, search in its visible view controllers (Example: `UINavigationController` always has one visible view controller, `UISplitController` which can han have 2 visible controllers if expanded.)
- `containing`: If the view controller is a container, search in all the view controllers it contains (i.e. All the view controllers in the `UINavigationController` before the one that is currently visible)
- `presenting`: Search in all the view controllers that are under the topmost one
- *`presented`*: Search from the view controller provided in all the view controllers that it are presented (It does not make sense to use it with the `StackIteratingFinder` as it always starts from the topmost view controller so there won't be any view controllers above)

The next image may help you to imagine `SearchOptions` in the real app:

![](https://habrastorage.org/webt/4j/pn/p5/4jpnp5peadzdj-cbk0tlfusbwxe.png)

If you want it so that the `StackIteratingFinder` would look for the desired view controller everywhere, but only if they are visible, it should be set like the following:

```swift
ClassFinder<AccountViewController, Any?>(options: [.current, .visible, .presenting])
```

### Q&A:

#### I have some `UIViewController` as a root and I want it to be replaced with the `HomeViewController`:

```swift
    let screen = StepAssembly(
            finder: ClassFinder<HomeViewController, Any?>(),
            factory: XibFactory())
            .using(GeneralAction.replaceRoot())
            .from(GeneralStep.root())
            .assemble()

```
*The `XibFactory` will load the `HomeViewController` from the xib file named `HomeViewController.xib`*

*Do not forget that if you use a combination of abstract `Finder` and `Factory` - you must specify the types of `UIViewController` and `Context` for one of them `ClassFinder<HomeViewController, Any?>`*

#### What will happen if, in the configuration above, I will replace `GeneralStep.root` with `GeneralStep.current`?

It will work if the user is not in some `UIViewController` that is presented modally. If they are, `ReplaceRoot` can not replace the modally presented `UIViewController` and the navigation will fail. If you want this configuration to work in all cases - you should explain to the router that it should start building the stack from the root view controller. Then the router will dismiss all the modal view controllers above the root view controller if there are any.

#### I want to push the `AccountViewController` into any `UINavigationController` that is present anywhere on the screen (even if the `UINavigationController` is under some modal `UIViewController`):

```swift
    let screen = StepAssembly(
            finder: ClassFinder<AccountViewController, Any?>(),
            factory: XibFactory())
            .using(NavigationControllerFactory.pushToNavigation())
            .from(SingleStep(ClassFinder<UINavigationController, Any?>(), NilFactory()))
            .from(GeneralStep.current())
            .assemble()

```

*Why is the `NilFactory` used here? That means: look for the `UINavigationController` everywhere, but do not create it if it is not found (the routing will fail in this case). The `NilFactory` can not be accompanied by any `Action` as the `UIViewController` already exists in the stack.*

#### The `UIViewController` should be pushed into any `UINavigationController` if it is present on the screen, if not - presented modally:

```swift
    let screen = StepAssembly(
            finder: ClassFinder<AccountViewController, Any?>(),
            factory: XibFactory())
            .using(NavigationControllerFactory.PushToNavigation())
            .from(SwitchAssembly<UINavigationController, Any?>()
                    .addCase(when: ClassFinder<UINavigationController, Any?>(options: .visible)) // If found - just push in to it
                    .assemble(default: { // else
                        return ChainAssembly()
                                .from(SingleContainerStep(finder: NilFinder(), factory: NavigationControllerFactory()))
                                .using(GeneralAction.presentModally())
                                .from(GeneralStep.current())
                                .assemble()
                    })
            ).assemble()
```

#### I want to present the `UITabBarController` with the `HomeViewController` and the `AccountViewController` in the tabs:

```swift
    let tabScreen = SingleContainerStep(
            finder: ClassFinder(),
            factory: CompleteFactoryAssembly(factory: TabBarControllerFactory())
                    .with(XibFactory<HomeViewController, Any?>(), using: TabBarControllerFactory.AddTab())
                    .with(XibFactory<AccountViewController, Any?>(), using: TabBarControllerFactory.AddTab())
                    .assemble())
            .using(GeneralAction.replaceRoot())
            .from(GeneralStep.root())
            .assemble()
```

#### I want to use custom `UIViewControllerTransitioningDelegate` with the `PresentModally` action:

```swift
    let transitionController = CustomViewControllerTransitioningDelegate()

    // Configuration
    .using(GeneralAction.PresentModally(transitioningDelegate: transitionController))
```

#### I want to navigate to the `AccountViewController` if the user is in another tab or even if the user is in some `UIViewController` presented modally:

```swift
    let screen = StepAssembly(
            finder: ClassFinder<AccountViewController, Any?>(),
            factory: NilFactory())
            .from(tabScreen)
            .assemble()
```

*Why is the `NilFactory` used here? We do not need to build anything: The `AccountViewController` will be built in the dependent `tabScreen` configuration. See the `tabScreen` configuration above.*

#### I want to modally present `ForgotPasswordViewController`, but after `LoginViewController` in the `UINavigationController`:

```swift
    let screen = StepAssembly(
            finder: ClassFinder<ForgotPasswordViewController, Any?>(),
            factory: XibFactory())
            .using(NavigationControllerFactory.pushToNavigation())
            .from(SingleStep(finder: ClassFinder<LoginViewController, Any?>, factory: XibFactory()))
            .using(NavigationControllerFactory.pushToNavigation())
            .from(SingleContainerStep(finder: ClassFinder(), factory: NavigationControllerFactory()))
            .using(GeneralAction.presentModally())
            .from(GeneralStep.current())
            .assemble()
```
Or:
```swift
    let loginScreen = StepAssembly(
            finder: ClassFinder<LoginViewController, Any?>(),
            factory: XibFactory())
            .using(NavigationControllerFactory.pushToNavigation())
            .from(NavigationControllerStep())
            .using(GeneralAction.presentModally())
            .from(GeneralStep.current())
            .assemble()

    let forgotPasswordScreen = StepAssembly(
            finder: ClassFinder<ForgotPasswordViewController, Any?>(),
            factory: XibFactory())
            .using(NavigationControllerFactory.pushToNavigation())
            .from(loginScreen.asContainerWitness())
            .assemble()

```
*With the configuration above you will be able to navigate to both screens using the `Router`*

#### Why do we use `asContainerWitness` here?

Because `pushToNavigation` action requires `UINavigationController` to be previous `UIViewController` in the chain. `asContainerWitness` method allows us to escape this check. You guarantee that it will be there by the time `pushToNavigation` will start to perform.

#### What will happen if, in the configuration above, I will replace the `GeneralStep.current` with the `GeneralStep.root`?

It will work, but it means that the router has to start building the stack from the root `UIViewController`, so if the user is in some `UIViewController` presented modally - the router will close it before it will start the navigation.

#### The app has a tab bar controller with the `HomeViewController` and the `BagViewController` inside. The user should be able to navigate to the bag manually using the tab bar. But if they tap on the button "Go to Bag" in the `HomeViewController`, the app should present the `BagViewController` modally. The same should happen if the user has to be sent to the bag using an Universal Link.

There are two ways of implementing this configuration:

1. To use the `NilFinder` which means that the router will never find an existing `BagViewController` on the screen and will always create a new one and present it modally. However, this has a downside: If the user is already in the `BagViewController` presented modally, and then he taps on the push notification that deep links him to the bag again, the router will build another `BagViewController` and present it modally on top.

2. Tweak the `ClassFinder` slightly so it will ignore the `BagViewController` that is not presented modally and use it in the configuration:

```swift
    struct ModalBagFinder: StackIteratingFinder  {

        func isTarget(_ viewController: BagViewController, with context: Any?) -> Bool {
            return viewController.presentingViewController != nil
        }

    }

    let screen = StepAssembly(
        finder: ModalBagFinder(),
        factory: XibFactory())
        .using(NavigationControllerFactory.pushToNavigation())
        .from(NavigationControllerStep())
        .using(GeneralAction.presentModally())
        .from(GeneralStep.current())
        .assemble()

```
 
