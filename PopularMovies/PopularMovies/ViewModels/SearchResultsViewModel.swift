/// View Model responsible to handler searched movies.
class SearchResultsViewModel {
    let networkManager = NetworkManager()
    /// The searched movies list.
    var movies = [Movie]()
    /// The formated query to search movies.
    var formatedQuery = String()
    /// The original query.
    var querySearch = String()
    /// The pagination.
    var pagination: Pagination!

    /// Call search movies endpoint.
    /// - Parameters:
    ///   - page: The page.
    ///   - completionHandler: A closure which is called with searched movies error.
    func searchMovies(page: Int, completionHandler: @escaping (APIResponse?) -> Void) {
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
