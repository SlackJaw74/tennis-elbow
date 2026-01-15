import Foundation

extension String {
    /// Returns a localized version of this string
    func localized(comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }
}
