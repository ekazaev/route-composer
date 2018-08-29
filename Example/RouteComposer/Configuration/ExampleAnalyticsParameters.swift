//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

struct ExampleAnalyticsParameters {

    let source: ExampleTarget

    let webpageURL: URL?

    let referrerURL: URL?

    init(source: ExampleTarget, webpageURL: URL? = nil, referrerURL: URL? = nil) {
        self.source = source
        self.webpageURL = webpageURL
        self.referrerURL = referrerURL
    }
}

protocol ExampleAnalyticsSupport {

    var analyticParameters: ExampleAnalyticsParameters { get }

}
