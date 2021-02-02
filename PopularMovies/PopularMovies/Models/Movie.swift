/// The entity representing movie.
struct Movie: Codable, Identifiable {
    /// The movie id.
    var id: Int
    /// The original movie title.
    var originalTitle: String
    /// The localizable title.
    var title: String
    /// The movie overview.
    var overview: String
    /// The poster image (vertical) path.
    var posterPath: String
    /// The backdrop image (horizontal) path.
    var backdropPath: String
    /// The vote average.
    var voteAverage: Double
}
