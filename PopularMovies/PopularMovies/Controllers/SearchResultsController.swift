import UIKit

/// Class represents movie search results.
class SearchResultsController: UIViewController {
    // MARK: - Outlets
    /// The searched movies collection view.
    @IBOutlet weak var collectionView: UICollectionView!
    /// The search result label.
    @IBOutlet weak var queryResults: UILabel!
    
    // MARK: - Properties
    /// The search results view model.
    let searchResultsViewModel = SearchResultsViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        queryResults.text = searchResultsViewModel.query
        collectionView.reloadData()
    }
    
    // MARK: - Public functions
    /// Initialize movie propertie at View Model.
    /// - Parameters:
    ///   - query: The text used to searched.
    ///   - movies: The movies searched using query string.
    func setupSearchResults(query: String, movies: [Movie]) {
        searchResultsViewModel.movies = movies
        searchResultsViewModel.query = "\"\(query)\""
    }
}

// MARK: - Collection view delegate
extension SearchResultsController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultsViewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.movieCell, for: indexPath) as? MovieViewCell else {
            fatalError("Dequeue reusable MovieViewCell error")
        }
        let movie = searchResultsViewModel.movies[indexPath.row]

        let movieURL = URL(string: movie.posterPath)!
        movieCell.poster.downloaded(from: movieURL)
        movieCell.movieTitle.text = movie.title
        
        movieCell.favoriteButtonPressed = {
            print("Favorite movie press: \(movie.title)") // TODO: Implement
        }
        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = searchResultsViewModel.movies[indexPath.row]

        let storyBoard: UIStoryboard = UIStoryboard(name: Constants.movieDetailsView, bundle: nil)
        let movieDetailsController = storyBoard.instantiateViewController(withIdentifier: Constants.movieDetailsController) as! MovieDetailsController
        movieDetailsController.setupMovieDetail(movie: selectedMovie)
        
        self.present(movieDetailsController, animated: true, completion: nil)
    }
}
