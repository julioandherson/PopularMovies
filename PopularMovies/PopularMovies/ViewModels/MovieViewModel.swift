class MovieViewModel {
    let networkManager = NetworkManager()
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
}
