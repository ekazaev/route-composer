//
// Created by Eugene Kazaev on 2019-08-21.
// Copyright (c) 2019 Eugene Kazaev. All rights reserved.
//

import Foundation

public struct Movie: Codable {
    public let id: Int

    public let original_title: String
    public let title: String

    public let overview: String
    public let poster_path: String?
    public let backdrop_path: String?
    public let popularity: Float
    public let vote_average: Float
    public let vote_count: Int

    public let release_date: String?
    public var releaseDate: Date? {
        return release_date != nil ? Movie.dateFormatter.date(from: release_date!) : Date()
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        return formatter
    }()

    public let genres: [Genre]?
    public let runtime: Int?
    public let status: String?

    public var keywords: Keywords?
    public var images: MovieImages?

    public var production_countries: [ProductionCountry]?

    public var character: String?
    public var department: String?

    public struct Keywords: Codable {
        public let keywords: [Keyword]?
    }

    public struct MovieImages: Codable {
        public let posters: [ImageData]?
        public let backdrops: [ImageData]?
    }

    public struct ProductionCountry: Codable {
        public let id = UUID()
        public let name: String
    }
}
