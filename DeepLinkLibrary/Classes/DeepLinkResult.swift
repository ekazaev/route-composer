//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 Gilt Groupe. All rights reserved.
//

import Foundation

public enum DeepLinkResult {
    /** The request to process the deep link resulted in a successful
    navigation to the destination. */
    case handled

    /** The request to process the deep link was not handled and therefore
    did not result in any navigation. */
    case unhandled
}
