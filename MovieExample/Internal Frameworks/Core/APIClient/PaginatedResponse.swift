//
// Created by Eugene Kazaev on 2019-08-21.
// Copyright (c) 2019 Eugene Kazaev. All rights reserved.
//

import Foundation

public struct PaginatedResponse<T: Codable>: Codable {
    public let page: Int?
    public let total_results: Int?
    public let total_pages: Int?
    public let results: [T]
}
