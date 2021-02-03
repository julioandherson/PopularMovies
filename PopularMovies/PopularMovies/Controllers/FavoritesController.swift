import UIKit

/// Controller responsible to display favorites movies.
class FavoritesController: UIViewController {
    // MARK: - Outlets
    /// The collection view.
    @IBOutlet weak var collectionView: UICollectionView!
    /// The favorite movies label.
    @IBOutlet weak var favoritesLabel: UILabel!
    
    // MARK: - Properties
    /// The movie view model.
    let movieViewModel = MovieViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLabelText()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateMoviesList()
    }
    
    /// Setup label text.
    func setupLabelText() {
        favoritesLabel.text = "FavoritesMovies".localized()
    }
    
    /// Change favorite icon acordlying movie persistence.
    /// - Parameter isFavorited: The is favorite flag.
    /// - Returns: A UIImage containing a filled star or empty star icon.
    func setupFavoriteImage(isFavorited: Bool) -> UIImage {
        let resourceName = isFavorited ? Constants.starFilled : Constants.starEmpty
        return UIImage(imageLiteralResourceName: resourceName)
    }
    
    /// Update movies list with data retriving from database.
    func updateMoviesList() {
        movieViewModel.movies = movieViewModel.getAllMovies()
        collectionView.reloadData()
    }
}

// MARK: - Collection view delegate
extension FavoritesController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        movieCell.favoriteIcon.setImage(setupFavoriteImage(isFavorited: true), for: .normal)

        movieCell.favoriteButtonPressed = {
            movieCell.favoriteIcon.setImage(self.setupFavoriteImage(isFavorited: false), for: .normal)
            self.movieViewModel.persistenceManager.deleteMovie(id: movie.id)
            self.updateMoviesList()
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
