//
// Created by Eugene Kazaev on 23/02/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation

public protocol ImagesFetcher {

    func loadImages(completion: @escaping (_: [String]) -> Void)

}
