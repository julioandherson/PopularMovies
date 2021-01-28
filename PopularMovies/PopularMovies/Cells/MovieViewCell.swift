import UIKit

/// Class represents movie cell.
class MovieViewCell: UICollectionViewCell {
    /// The movie poster image.
    @IBOutlet weak var poster: UIImageView!
    /// The localizable movie title.
    @IBOutlet weak var movieTitle: UILabel!
    /// The favorites button pressed callback.
    var favoriteButtonPressed: (() -> ()) = {}
    
    /// Favorites button pressed.
    /// - Parameter sender: The button favorites.
    @IBAction func saveOnFavoritesAction(_ sender: UIButton) {
        favoriteButtonPressed()
    }
}
