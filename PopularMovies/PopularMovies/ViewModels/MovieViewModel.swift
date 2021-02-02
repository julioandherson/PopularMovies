/// Responsible to handler information about 'Movie' entity.
class MovieViewModel {
    /// The network manager instance.
    let networkManager = NetworkManager()
    /// The persistence manager instance.
    let persistenceManager = PersistenceManager()
    /// The movie list.
    var movies = [Movie]()
    /// The pagination information.
    var pagination: Pagination!
    /// The formated query to search movies.
    var formatedQuery = String()
    /// The query search.
    var querySearch = String()
    
    /// Call fetch movies endpoint.
    /// - Parameters:
    ///   - page: The page.
    ///   - completionHandler: A closure which is called with fetched movies error.
    func fetchPopularMovies(page: Int = 1, completionHandler: @escaping (APIResponse?) -> Void) {
        networkManager.fetchPopularMovies(page: page, completionHandler: { movies, pagination, errorResponse in

            if let error = errorResponse {
                completionHandler(.requestFailure)
            } else {
                self.movies = movies
                self.pagination = pagination
                completionHandler(nil)
            }
        })
    }

    /// Call search movies endpoint.
    /// - Parameters:
    ///   - page: The page.
    ///   - completionHandler: A closure which is called with searched movies error.
    func searchMovies(page: Int = 1, completionHandler: @escaping (APIResponse?) -> Void) {
        networkManager.searchMovies(page: page, queryString: querySearch, completionHandler: { movies, pagination, errorResponse in
            if let error = errorResponse {
                completionHandler(.requestFailure)
            } else {
                self.movies = movies
                self.pagination = pagination
                completionHandler(nil)
            }
        })
    }

    /// Save movie.
    /// - Parameter movie: The movie to be saved.
    func saveMovie(movie: Movie) {
        persistenceManager.save(movie: movie)
    }
    
    /// Check if movie already exists on database.
    /// - Parameter id: The movie id to be verified.
    /// - Returns: A Boolean indicating whether movie already exists.
    func hasMovie(id: Int) -> Bool {
        return persistenceManager.hasMovie(id: id)
    }
    
    /// Get all movies saved.
    /// - Returns: An Array of all saved movies.
    func getAllMovies() -> [Movie] {
        return persistenceManager.getAllMovies()
    }
    
    /// Delete object using movie id.
    /// - Parameter id: The movie id to be deleted.
    func deleteMovie(id: Int) {
        persistenceManager.deleteMovie(id: id)
    }
}
