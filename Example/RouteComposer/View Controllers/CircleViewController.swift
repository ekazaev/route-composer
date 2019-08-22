//
//  Created by Eugene Kazaev on 18/12/2017.
//

import UIKit
import RouteComposer

class CircleViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.circle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Circle"
    }

    @IBAction func goToSquareTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.squareScreen, with: nil)
    }

    @IBAction func goToRandomColorTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.colorScreen, with: "0000FF")
    }

    @IBAction func goToDeepModalTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.routingSupportScreen, with: "00FF00")
    }

    @IBAction func goToSuperModalTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.secondModalScreen, with: "0000FF")
    }

    @IBAction func goToProductTapped() {
        try? router.navigate(to: ProductConfiguration.productScreen, with: ProductContext(productId: "00"))
    }

    @IBAction func goToWelcomeTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.welcomeScreen, with: nil)
    }

    @IBAction func goToImagesTapped() {
        try? router.navigate(to: ImagesConfigurationWithLibrary.images())
    }

    @IBAction func goToImagesNoLibraryTapped() {
        ImagesWithoutLibraryConfiguration.shared.showCustomController()
    }

}
