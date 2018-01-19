//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

struct ExampleAnalyticsParameters {

    let source: ExampleSource

    let webpageURL: URL?

    let referrerURL: URL?

    init(source: ExampleSource, webpageURL: URL? = nil, referrerURL: URL? = nil) {
        self.source = source
        self.webpageURL = webpageURL
        self.referrerURL = referrerURL
    }
}

protocol AnalyticsSupportViewController {

    var analyticParameters: ExampleAnalyticsParameters { get }

}