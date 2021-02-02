import UIKit

/// Controller responsible to display details about selected movie.
class MovieDetailsController: UIViewController {
    // MARK: - Outlets
    /// The backdrop movie image.
    @IBOutlet weak var backdropImage: UIImageView!
    /// The overview description about movie.
    @IBOutlet weak var overview: UITextView!
    /// The movie title.
    @IBOutlet weak var movieTitle: UILabel!
    /// The average movie score.
    @IBOutlet weak var voteAverage: UILabel!
    /// The favorite button.
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Properties
    /// The movie details view model.
    let movieDetailsViewModel = MovieDetailsViewModel()
    /// The movie view model.
    let movieViewModel = MovieViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDetails()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupFavoriteButton()
    }

    // MARK: - Public functions
    /// Setup movie details fields.
    func setupDetails() {
        if let movie = movieDetailsViewModel.selectedMovie {
            let movieURL = URL(string: movie.backdropPath)!
            backdropImage.downloaded(from: movieURL)
            movieTitle.text = movie.title
            overview.text = movie.overview
            voteAverage.text = String(format: "%.1f", movie.voteAverage)
        }
    }

    /// Setup favorite button.
    func setupFavoriteButton() {
        if movieViewModel.hasMovie(id: movieDetailsViewModel.selectedMovie.id) {
            favoriteButton.setImage(self.setupFavoriteImage(isFavorited: true), for: .normal)
        } else {
            favoriteButton.setImage(self.setupFavoriteImage(isFavorited: false), for: .normal)
        }
    }

    /// Change favorite icon acordlying movie persistence.
    /// - Parameter isFavorited: The is favorite flag.
    /// - Returns: A UIImage containing a filled star or empty star icon.
    func setupFavoriteImage(isFavorited: Bool) -> UIImage {
        let resourceName = isFavorited ? Constants.starFilled : Constants.starEmpty
        return UIImage(imageLiteralResourceName: resourceName)
    }

    // MARK: - Public functions
    /// Initialize movie propertie at View Model.
    /// - Parameter movie: The movie.
    func setupMovieDetail(movie: Movie) {
        movieDetailsViewModel.selectedMovie = movie
    }

    /// The favorite action.
    /// - Parameter sender: The favorite button.
    @IBAction func favoriteMovieAction(_ sender: UIButton) {
        if movieViewModel.hasMovie(id: movieDetailsViewModel.selectedMovie.id) {
            favoriteButton.setImage(self.setupFavoriteImage(isFavorited: false), for: .normal)
            movieViewModel.persistenceManager.deleteMovie(id: movieDetailsViewModel.selectedMovie.id)
        } else {
            favoriteButton.setImage(self.setupFavoriteImage(isFavorited: true), for: .normal)
            movieViewModel.persistenceManager.save(movie: movieDetailsViewModel.selectedMovie)
        }
    }
}
