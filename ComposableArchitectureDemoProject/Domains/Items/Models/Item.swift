// This file was generated from JSON Schema using quicktype, do not modify it directly.
import Foundation

// MARK: - Item
struct Item: Codable, Equatable, Identifiable, Sendable, Hashable {
    let contentType: String?
    let id: String
    let isDir: Bool
    /// ISO 8601 format
    let modificationDate: String
    let name: String
    let parentID: String?
    let size: Double?

    enum CodingKeys: String, CodingKey {
        case contentType, id, isDir, modificationDate, name
        case parentID = "parentId"
        case size
    }
}
