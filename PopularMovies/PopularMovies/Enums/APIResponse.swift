enum APIResponse: Error {
    case requestError(message: String)
    case fetchMoviesError
    case searchMoviesError
    case unknownError
}
