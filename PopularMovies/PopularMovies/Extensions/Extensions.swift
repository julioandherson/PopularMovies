import UIKit

extension UIImageView {
    /// Download image using URL and defines own image to downloaded image.
    /// - Parameters:
    ///   - url: The URL to download image.
    ///   - mode: The image configuration mode.
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data, error == nil,
                  let image = UIImage(data: data)
            else {
                print("Error to download images...")
                return
            }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}

extension String {
    /// Trim String and remove extra spaces between words. E.G.: '     Star    Wars     ' -> 'Star Wars'.
    /// - Returns: A String with no extra spaces.
    func removeExtraSpaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }
}
