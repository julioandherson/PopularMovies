import UIKit

/// Class represents movie cell.
class MovieViewCell: UICollectionViewCell {
    // MARK: - Outlets
    /// The movie poster image.
    @IBOutlet weak var poster: UIImageView!
    /// The localizable movie title.
    @IBOutlet weak var movieTitle: UILabel!
    /// The favorite icon (star).
    @IBOutlet weak var favoriteIcon: UIButton!
    
    // MARK: - Callbacks
    /// The favorites button pressed callback.
    var favoriteButtonPressed: (() -> ()) = {}
    
    // MARK: - Actions
    /// Favorites button pressed.
    /// - Parameter sender: The button favorites.
    @IBAction func saveOnFavoritesAction(_ sender: UIButton) {
        favoriteButtonPressed()
    }
}
