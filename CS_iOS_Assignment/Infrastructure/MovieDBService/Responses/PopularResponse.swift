// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let popularResponse = try? newJSONDecoder().decode(PopularResponse.self, from: jsonData)

import Foundation

// MARK: - PopularResponse
public struct PopularResponse: Codable {
    public let page: Int?
    public let results: [PopularResult]?
    public let totalPages, totalResults: Int?

    public enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension PopularResponse {
    
    // MARK: - Result
    public struct PopularResult: Codable {
        public let adult: Bool?
        public let backdropPath: String?
        public let genreIDS: [Int]?
        public let id: Int?
        public let originalTitle, overview: String?
        public let popularity: Double?
        public let posterPath, releaseDate, title: String?
        public let video: Bool?
        public let voteAverage: Double?
        public let voteCount: Int?
        
        public enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case genreIDS = "genre_ids"
            case id
            case originalTitle = "original_title"
            case overview, popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title, video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
    }
}

