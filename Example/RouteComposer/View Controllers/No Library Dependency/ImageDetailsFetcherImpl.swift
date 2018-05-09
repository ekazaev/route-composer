//
// Created by Eugene Kazaev on 25/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class ImageDetailsFetcherImpl: ImageDetailsFetcher {

    func details(for imageID: String, completion: @escaping (UIImage?) -> Void) {
        guard let image = UIImage(named: imageID) else {
            completion(nil)
            return
        }

        completion(image)
    }

}
