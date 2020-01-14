//
// Created by Eugene Kazaev on 2018-10-10.
//

import Foundation
import RouteComposer
import UIKit

/// Simple extension to support `Destination` instance directly by the `Router`.
extension Router {

    func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>, with context: Context) throws {
        try navigate(to: step, with: context, animated: true, completion: nil)
    }

}
