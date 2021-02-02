import UIKit

/// Controller responsible to display main view in which is displayed popular movies.
class HomeController: UIViewController {
    // MARK: - Outlets
    /// The movies collection view.
    @IBOutlet weak var collectionView: UICollectionView!
    /// The search bar.
    @IBOutlet weak var searchBar: UISearchBar!
    /// The loading indicator.
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
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

        setupLabelsText()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self

        fetchMovies()
    }

    // MARK: - Public functions
    /// Fetch movies and set movie list.
    /// - Parameter page: The movies page.
    func fetchMovies(page: Int = 1) {
        loadingIndicator.isHidden = false

        movieViewModel.fetchPopularMovies(page: page, completionHandler: { errorResponse in
            self.loadingIndicator.isHidden = true

            if let error = errorResponse { // TODO: use this value
                let alert = UIAlertController(title: "Request failure", message: "Message", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
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

    /// Display error alert.
    func showErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Request failure", message: "Message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Actions
    /// Navigate to first page.
    /// - Parameter sender: The first page button.
    @IBAction func firstPageAction(_ sender: UIButton) {
        fetchMovies(page: 1)
        setupPaginationCounter()
    }
    
    /// Navigate to last page.
    /// - Parameter sender: The last page button.
    @IBAction func lastPageAction(_ sender: UIButton) {
        fetchMovies(page: movieViewModel.pagination.totalPages)
        setupPaginationCounter()
    }
    
    /// Navigate to previous page.
    /// - Parameter sender: The previous page button.
    @IBAction func previousPageAction(_ sender: UIButton) {
        let currentPage = movieViewModel.pagination.currentPage - 1
        if currentPage >= 1 {
            fetchMovies(page: currentPage)
            setupPaginationCounter()
        }
    }

    /// Navigate to next page.
    /// - Parameter sender: The next page button.
    @IBAction func nextPageAction(_ sender: UIButton) {
        let currentPage = movieViewModel.pagination.currentPage + 1
        if currentPage <= movieViewModel.pagination.totalPages {
            fetchMovies(page: currentPage)
            setupPaginationCounter()
        }
    }
}

// MARK: - Collection view delegate
extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        
        movieCell.favoriteButtonPressed = {
            print("Favorite movie press: \(movie.title)") // TODO: Implement
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

// MARK: - Searchbar delegate
extension HomeController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            loadingIndicator.isHidden = false
            
            movieViewModel.querySearch = searchText
            movieViewModel.searchMovies(completionHandler: { errorResponse in
                self.loadingIndicator.isHidden = true

                if let error = errorResponse { // TODO: use this value
                    self.showErrorAlert()
                } else {
                    let storyBoard: UIStoryboard = UIStoryboard(name: Constants.searchResultsView, bundle: nil)
                    DispatchQueue.main.async {
                        let searchResultsController = storyBoard.instantiateViewController(withIdentifier: Constants.searchResultsController) as! SearchResultsController
                        searchResultsController.setupSearchResults(query: searchText,
                                                                   movies: self.movieViewModel.movies,
                                                                   pagination: self.movieViewModel.pagination!)

                        self.present(searchResultsController, animated: true, completion: nil)
                    }
                }
            })
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
