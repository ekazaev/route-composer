//
// Created by Eugene Kazaev on 23/02/2018.
//

import Foundation

public protocol ImagesFetcher {

    func loadImages(completion: @escaping (_: [String]) -> Void)

}
