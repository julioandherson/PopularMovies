import UIKit

class HomeController: UIViewController {
    // MARK: - Outlets
    /// The movies collection view.
    @IBOutlet weak var collectionView: UICollectionView!
    /// The search bar.
    @IBOutlet weak var searchBar: UISearchBar!
    /// The loading indicator.
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    // MARK: - Properties
    /// The home view model.
    let homeViewModel = HomeViewModel()
    /// The network manager.
    let networkManager = NetworkManager()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self
        
        fetchMovies()
    }
    
    // MARK: - Public functions
    /// Fetch movies and set movie list.
    func fetchMovies() {
        loadingIndicator.isHidden = false
        networkManager.fetchPopularMovies { movies in
            self.homeViewModel.movies = movies
            self.loadingIndicator.isHidden = true
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Collection view delegate
extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.movieCell, for: indexPath) as? MovieViewCell else {
            fatalError("Dequeue reusable MovieViewCell error")
        }
        let movie = homeViewModel.movies[indexPath.row]

        let movieURL = URL(string: movie.posterPath)!
        movieCell.poster.downloaded(from: movieURL)
        movieCell.movieTitle.text = movie.title
        
        movieCell.favoriteButtonPressed = {
            print("Favorite movie press: \(movie.title)") // TODO: Implement
        }

        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = homeViewModel.movies[indexPath.row]

        let storyBoard: UIStoryboard = UIStoryboard(name: Constants.movieDetailsView, bundle: nil)
        let movieDetailsController = storyBoard.instantiateViewController(withIdentifier: Constants.movieDetailsController) as! MovieDetailsController
        movieDetailsController.setupMovieDetail(movie: selectedMovie)
        
        self.present(movieDetailsController, animated: true, completion: nil)
    }
}

// MARK: - Searchbar delegate
extension HomeController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            loadingIndicator.isHidden = false
            networkManager.searchMovies(queryString: searchText, completionHandler: { movies in
                self.loadingIndicator.isHidden = true
                let storyBoard: UIStoryboard = UIStoryboard(name: Constants.searchResultsView, bundle: nil)
                DispatchQueue.main.async {
                    let searchResultsController = storyBoard.instantiateViewController(withIdentifier: Constants.searchResultsController) as! SearchResultsController
                    searchResultsController.setupSearchResults(query: searchText, movies: movies)

                    self.present(searchResultsController, animated: true, completion: nil)
                }
            })
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
