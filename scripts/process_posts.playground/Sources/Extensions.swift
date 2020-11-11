import Foundation

extension URL: Comparable {
    public static func < (lhs: URL, rhs: URL) -> Bool {
        return lhs.absoluteString < rhs.absoluteString
    }
}
