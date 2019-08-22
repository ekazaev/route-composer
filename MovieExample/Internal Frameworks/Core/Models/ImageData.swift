//
// Created by Eugene Kazaev on 2019-08-21.
// Copyright (c) 2019 Eugene Kazaev. All rights reserved.
//

import Foundation

public struct ImageData: Codable {
    public let id = UUID()
    public let aspect_ratio: Float
    public let file_path: String
    public let height: Int
    public let width: Int
}
