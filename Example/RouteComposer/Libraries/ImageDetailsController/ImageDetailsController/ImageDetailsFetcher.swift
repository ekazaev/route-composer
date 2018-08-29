//
// Created by Eugene Kazaev on 25/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public protocol ImageDetailsFetcher {
    func details(for imageID: String, completion: @escaping (_: UIImage?) -> Void)
}
