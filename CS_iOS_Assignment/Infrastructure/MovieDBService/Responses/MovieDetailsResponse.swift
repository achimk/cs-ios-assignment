// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieDetailsResponse = try? newJSONDecoder().decode(MovieDetailsResponse.self, from: jsonData)

import Foundation

// MARK: - MovieDetailsResponse
public struct MovieDetailsResponse: Codable {
    public let adult: Bool?
    public let backdropPath: String?
    public let budget: Int?
    public let genres: [Genre]?
    public let homepage: String?
    public let id: Int?
    public let imdbID, originalLanguage, originalTitle, overview: String?
    public let popularity: Double?
    public let posterPath: String?
    public let releaseDate: String?
    public let revenue, runtime: Int?
    public let status, tagline, title: String?
    public let video: Bool?
    public let voteAverage: Double?
    public let voteCount: Int?

    public enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, homepage, id
        case genres
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue, runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieDetailsResponse {
    // MARK: - Genre
    public struct Genre: Codable {
        public let id: Int?
        public let name: String?
    }
}

