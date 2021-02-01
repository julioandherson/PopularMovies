import Foundation

/// Class responsible to manager endpoints requests.
class NetworkManager {
    // MARK: - Locale
    /// The current language of device.
    let language: String = Locale.current.languageCode ?? Constants.defaultLanguageCode

    // MARK: - Domains
    /// The movies database domain.
    let tmdbDomain = "https://api.themoviedb.org"
    /// The image domain.
    let imageDomain = "https://image.tmdb.org/t/p/w500"

    // MARK: - Private functions
    /// Get popular movies address.
    /// - Parameter page: The current page.
    /// - Returns: A address to popular movies.
    private func getPopularMoviesAddress(page: Int = 1) -> String {
        return "\(tmdbDomain)/3/movie/popular?api_key=\(Constants.API_KEY)&language=\(language)&page=\(page)"
    }
    
    /// Get search movies address.
    /// - Parameter page: The current page.
    /// - Returns: A address to searched movies.
    private func getSearchMoviesAddress(page: Int = 1) -> String {
        return "\(tmdbDomain)/3/search/movie?api_key=\(Constants.API_KEY)&language=\(language)&page=\(page)&query="
    }

    /// Create a movie using dictionary.
    /// - Parameter dictionary: The dictionary to create a movie.
    /// - Returns: Movie.
    private func getMovieFrom(dictionary: [String: Any]) -> Movie {
        let id = dictionary["id"] as? Int
        let originalTitle = dictionary["original_title"] as? String
        let title = dictionary["title"] as? String
        let overview = dictionary["overview"] as? String
        var posterPath = self.imageDomain
        posterPath += dictionary["poster_path"] as? String ?? ""
        var backdropPath = self.imageDomain
        backdropPath += dictionary["backdrop_path"] as? String ?? ""
        let voteAverage = dictionary["vote_average"] as? Double

        let movie = Movie(id: id!,
                            originalTitle: originalTitle!,
                            title: title!,
                            overview: overview!,
                            posterPath: posterPath,
                            backdropPath: backdropPath,
                            voteAverage: voteAverage!)

        return movie
    }

    // MARK: - Public functions
    /// Fetch popular movies.
    /// - Parameters:
    ///   - page: The number of movies page.
    ///   - completionHandler: A closure which is called with movies list.
    func fetchPopularMovies(page: Int = 1,
                            completionHandler: @escaping ([Movie]) -> Void) {
        var movies = [Movie]()
        if let url = URL(string: getPopularMoviesAddress(page: page)) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print("Error fetching movies: \(error)")
                    // TODO: Handler error
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the fetching movies response, unexpected status code: \(String(describing: response))")
                    // TODO: Handler error
                    return
                }

                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let results = json["results"] as? [[String: Any]] {
                        for movieDictionary in results {
                            let movie = self.getMovieFrom(dictionary: movieDictionary)
                            movies.append(movie)
                        }
                        DispatchQueue.main.async {
                            completionHandler(movies)
                        }
                    }
                }
            })
            task.resume()
        } else {
            print("Fetch movies error")
            // TODO: Handle fetch movies error
        }
    }

    /// Search movies using a query.
    /// - Parameters:
    ///   - page: The number of movies page.
    ///   - queryString: The query to search movies.
    ///   - completionHandler: A closure which is called with searched movies list.
    func searchMovies(page: Int = 1,
                      queryString: String,
                      completionHandler: @escaping ([Movie]) -> Void) {
        var movies = [Movie]()

        let querySearch = queryString.removeExtraSpaces().replacingOccurrences(of: " ", with: "+")
        if let url = URL(string: getSearchMoviesAddress(page: page) + querySearch) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print("Error fetching movies: \(error)")
                    // TODO: Handler error
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the fetching movies response, unexpected status code: \(String(describing: response))")
                    // TODO: Handler error
                    return
                }

                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let results = json["results"] as? [[String: Any]] {
                        for movieDictionary in results {
                            let movie = self.getMovieFrom(dictionary: movieDictionary)
                            movies.append(movie)
                        }
                        DispatchQueue.main.async {
                            completionHandler(movies)
                        }
                    }
                }
            })
            task.resume()
        } else {
            print("URL error with follow query: \(querySearch)")
            // TODO: Handle search error
        }
    }
}
