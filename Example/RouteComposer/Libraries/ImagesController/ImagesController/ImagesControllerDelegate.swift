//
// Created by Eugene Kazaev on 23/02/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation

public protocol ImagesControllerDelegate: AnyObject {

    func didSelect(imageID: String, in controller: ImagesViewController)

}
