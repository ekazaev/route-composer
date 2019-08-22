//
// Created by Eugene Kazaev on 23/02/2018.
//

import Foundation

public protocol ImagesControllerDelegate: AnyObject {

    func didSelect(imageID: String, in controller: ImagesViewController)

}
