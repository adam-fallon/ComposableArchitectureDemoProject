// This file was generated from JSON Schema using quicktype, do not modify it directly.
import Foundation

// MARK: - User
struct User: Codable, Equatable, Sendable {
    let firstName, lastName: String
    /// The entry point of the items hierarchy
    let rootItem: Item?
    
    /// Base64 Encoded Authorization String
    var authString: String?
}
