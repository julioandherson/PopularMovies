import Foundation

/// Class responsible to manager endpoints requests.
class NetworkManager {
    let locale = Locale.current.languageCode // TODO: Put this on popularURL
    // TODO: Put this on ENUM
    let popularURL = "https://api.themoviedb.org/3/movie/popular?api_key=\(Constants.API_KEY)&language=pt-BR"
    
    let searchURL = "https://api.themoviedb.org/3/search/movie?api_key=\(Constants.API_KEY)&query="
    
    let imageDomain = "https://image.tmdb.org/t/p/w500"
    
    /// Fetch popular movies.
    /// - Parameter completionHandler: A closure which is called with movies list.
    func fetchPopularMovies(completionHandler: @escaping ([Movie]) -> Void) {
        var movies = [Movie]()
        let url = URL(string: popularURL)!

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
                    for movie in results {
                        let id = movie["id"] as? Int
                        let originalTitle = movie["original_title"] as? String
                        let title = movie["title"] as? String
                        let overview = movie["overview"] as? String
                        var posterPath = self.imageDomain
                        posterPath += movie["poster_path"] as! String
                        var backdropPath = self.imageDomain
                        backdropPath += movie["backdrop_path"] as! String
                        let voteAverage = movie["vote_average"] as? Double

                        movies.append(Movie(id: id!,
                                            originalTitle: originalTitle!,
                                            title: title!,
                                            overview: overview!,
                                            posterPath: posterPath,
                                            backdropPath: backdropPath,
                                            voteAverage: voteAverage!))
                    }
                    completionHandler(movies)
                }
            }
        })
        task.resume()
      }

    /// Search movies using a query.
    /// - Parameters:
    ///   - queryString: The query to search movies.
    ///   - completionHandler: A closure which is called with searched movies list.
    func searchMovies(queryString: String, completionHandler: @escaping ([Movie]) -> Void) {
        var movies = [Movie]()
        let url = URL(string: searchURL + queryString)! // TODO: Replace white space to +

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
                    for movie in results {
                        let id = movie["id"] as? Int
                        let originalTitle = movie["original_title"] as? String
                        let title = movie["title"] as? String
                        let overview = movie["overview"] as? String
                        var posterPath = self.imageDomain
                        posterPath += movie["poster_path"] as? String ?? ""
                        var backdropPath = self.imageDomain
                        backdropPath += movie["backdrop_path"] as? String ?? ""
                        let voteAverage = movie["vote_average"] as? Double

                        movies.append(Movie(id: id!,
                                            originalTitle: originalTitle!,
                                            title: title!,
                                            overview: overview!,
                                            posterPath: posterPath,
                                            backdropPath: backdropPath,
                                            voteAverage: voteAverage!))
                    }
                    completionHandler(movies)
                }
            }
        })
        task.resume()
      }
}
