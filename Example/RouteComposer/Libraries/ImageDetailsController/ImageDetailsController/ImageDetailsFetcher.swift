//
// Created by Eugene Kazaev on 25/02/2018.
//

import Foundation
import UIKit

public protocol ImageDetailsFetcher {
    func details(for imageID: String, completion: @escaping (_: UIImage?) -> Void)
}
