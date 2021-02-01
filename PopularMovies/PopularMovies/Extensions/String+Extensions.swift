import Foundation

extension String {
    /// Trim String and remove extra spaces between words. E.G.: '     Star    Wars     ' -> 'Star Wars'.
    /// - Returns: A String with no extra spaces.
    func removeExtraSpaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }

    /// A convenient method to associate and get localizable value for a String.
    /// - Parameters:
    ///   - bundle: The bundle thats contains localizable file.
    ///   - tableName: The table name.
    /// - Returns: A localizable string or whether string not found, the string key between asterisks.
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "A localizable string for key: \(self)")
    }
}
