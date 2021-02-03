import UIKit

/// Class represents movie search results.
class SearchResultsController: UIViewController, DialogProtocol {
    // MARK: - Outlets
    /// The searched movies collection view.
    @IBOutlet weak var collectionView: UICollectionView!
    /// The search result label.
    @IBOutlet weak var queryResults: UILabel!
    /// The page counter.
    @IBOutlet weak var pageCount: UILabel!
    /// The first page button.
    @IBOutlet weak var firstPageButton: UIButton!
    /// The previous page button.
    @IBOutlet weak var previousPageButton: UIButton!
    /// The next page button.
    @IBOutlet weak var nextPageButton: UIButton!
    /// The last page button.
    @IBOutlet weak var lastPageButton: UIButton!

    // MARK: - Properties
    /// The movie view model.
    let movieViewModel = MovieViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        queryResults.text = movieViewModel.formatedQuery
        setupLabelsText()
        setupPaginationCounter()

        collectionView.reloadData()
    }

    // MARK: - Public functions
    /// Initialize movie propertie at View Model.
    /// - Parameters:
    ///   - query: The text used to searched.
    ///   - movies: The movies searched using query string.
    ///   - pagination: The info pagination.
    func setupSearchResults(query: String, movies: [Movie], pagination: Pagination) {
        self.movieViewModel.movies = movies
        self.movieViewModel.formatedQuery = "\"\(query)\""
        self.movieViewModel.querySearch = query
        self.movieViewModel.pagination = pagination
    }
    
    /// Search movies.
    /// - Parameter page: The page.
    func searchMovies(page: Int) {
        movieViewModel.searchMovies(page: page, completionHandler: { errorResponse in
            if let error = errorResponse {
                self.showErrorAlert(controller: self, message: error.localizedDescription)
            } else {
                self.setupPaginationCounter()
                self.collectionView.reloadData()
            }
        })
    }

    /// Setup current page label.
    func setupPaginationCounter() {
        if let pagination = movieViewModel.pagination {
            pageCount.text = String(pagination.currentPage)
        }
    }

    /// Setup button labels text.
    func setupLabelsText() {
        pageCount.text = "1"
        firstPageButton.setTitle("first".localized(), for: .normal)
        previousPageButton.setTitle("previous".localized(), for: .normal)
        nextPageButton.setTitle("next".localized(), for: .normal)
        lastPageButton.setTitle("last".localized(), for: .normal)
    }

    /// Change favorite icon acordlying movie persistence.
    /// - Parameter isFavorited: The is favorite flag.
    /// - Returns: A UIImage containing a filled star or empty star icon.
    func setupFavoriteImage(isFavorited: Bool) -> UIImage {
        let resourceName = isFavorited ? Constants.starFilled : Constants.starEmpty
        return UIImage(imageLiteralResourceName: resourceName)
    }

    // MARK: - Actions
    /// Navigate to first page.
    /// - Parameter sender: The first page button.
    @IBAction func firstPageAction(_ sender: UIButton) {
        searchMovies(page: 1)
        setupPaginationCounter()
    }

    /// Navigate to last page.
    /// - Parameter sender: The last page button.
    @IBAction func lastPageAction(_ sender: UIButton) {
        searchMovies(page: movieViewModel.pagination.totalPages)
        setupPaginationCounter()
    }

    /// Navigate to previous page.
    /// - Parameter sender: The previous page button.
    @IBAction func previousPageAction(_ sender: UIButton) {
        let currentPage = movieViewModel.pagination.currentPage - 1
        if currentPage >= 1 {
            searchMovies(page: currentPage)
            setupPaginationCounter()
        }
    }

    /// Navigate to next page.
    /// - Parameter sender: The next page button.
    @IBAction func nextPageAction(_ sender: UIButton) {
        let currentPage = movieViewModel.pagination.currentPage + 1
        if currentPage <= movieViewModel.pagination.totalPages {
            searchMovies(page: currentPage)
            setupPaginationCounter()
        }
    }
}

// MARK: - Collection view delegate
extension SearchResultsController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieViewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.movieCell, for: indexPath) as? MovieViewCell else {
            fatalError("Dequeue reusable MovieViewCell error")
        }
        let movie = movieViewModel.movies[indexPath.row]

        let movieURL = URL(string: movie.posterPath)!
        movieCell.poster.downloaded(from: movieURL)
        movieCell.movieTitle.text = movie.title
        
        if movieViewModel.hasMovie(id: movie.id) {
            movieCell.favoriteIcon.setImage(setupFavoriteImage(isFavorited: true), for: .normal)
        } else {
            movieCell.favoriteIcon.setImage(setupFavoriteImage(isFavorited: false), for: .normal)
        }
        
        movieCell.favoriteButtonPressed = {
            if self.movieViewModel.hasMovie(id: movie.id) {
                movieCell.favoriteIcon.setImage(self.setupFavoriteImage(isFavorited: false), for: .normal)
                self.movieViewModel.persistenceManager.deleteMovie(id: movie.id)
            } else {
                movieCell.favoriteIcon.setImage(self.setupFavoriteImage(isFavorited: true), for: .normal)
                self.movieViewModel.persistenceManager.save(movie: movie)
            }
        }
        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movieViewModel.movies[indexPath.row]

        let storyBoard: UIStoryboard = UIStoryboard(name: Constants.movieDetailsView, bundle: nil)
        let movieDetailsController = storyBoard.instantiateViewController(withIdentifier: Constants.movieDetailsController) as! MovieDetailsController
        movieDetailsController.setupMovieDetail(movie: selectedMovie)
        
        self.present(movieDetailsController, animated: true, completion: nil)
    }
}
