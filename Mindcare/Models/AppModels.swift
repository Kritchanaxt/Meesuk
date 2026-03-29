import Foundation

// MARK: - Journal Entry

struct JournalEntry: Codable, Identifiable {
    let id: String
    let userId: String
    let content: String
    let moodLevel: Int?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case content
        case moodLevel = "mood_level"
        case createdAt = "created_at"
    }
}

// MARK: - Session Note

struct SessionNote: Codable, Identifiable {
    let id: String
    let appointmentId: String
    let psychiatristId: String
    let note: String
    let isPrivate: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case appointmentId = "appointment_id"
        case psychiatristId = "psychiatrist_id"
        case note
        case isPrivate = "is_private"
        case createdAt = "created_at"
    }
}

// MARK: - Chat History Message (Direct Chat)

struct ChatHistoryMessage: Codable, Identifiable {
    let id: String
    let senderId: String
    let receiverId: String
    let content: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case content
        case createdAt = "created_at"
    }
}
