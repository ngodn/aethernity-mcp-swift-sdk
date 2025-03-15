import Foundation

/// The Model Context Protocol uses string-based version identifiers
/// following the format YYYY-MM-DD, to indicate
/// the last date backwards incompatible changes were made.
///
/// - SeeAlso: https://spec.modelcontextprotocol.io/specification/2024-11-05/basic/versioning/
public enum Version {
    /// The current protocol version.
    public static let latest = "2024-11-05"
}
