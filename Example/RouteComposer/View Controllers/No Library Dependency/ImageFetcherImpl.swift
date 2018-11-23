//
// Created by Eugene Kazaev on 23/02/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation
import ImagesController

class ImageFetcherImpl: ImagesFetcher {

    func loadImages(completion: @escaping ([String]) -> Void) {
        completion(["first", "second", "star"])
    }

}
