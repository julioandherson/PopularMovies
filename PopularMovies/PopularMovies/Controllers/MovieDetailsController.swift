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

    // MARK: - Properties
    let movieDetailsViewModel = MovieDetailsViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDetails()
    }
    
    // MARK: - Private functions
    /// Setup movie details fields.
    private func setupDetails() {
        if let movie = movieDetailsViewModel.selectedMovie {
            let movieURL = URL(string: movie.backdropPath)!
            backdropImage.downloaded(from: movieURL)
            movieTitle.text = movie.title
            overview.text = movie.overview
            voteAverage.text = String(format: "%.1f", movie.voteAverage)
        }
    }

    // MARK: - Public functions
    /// Initialize movie propertie at View Model.
    /// - Parameter movie: The movie.
    func setupMovieDetail(movie: Movie) {
        movieDetailsViewModel.selectedMovie = movie
    }
}
