//
//  ChatModels.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation

// MARK: - Chat Response

struct ChatResponse: Codable {
    let message: ChatMessage
    let conversationId: String
    let suggestions: [String]?
    let riskDetected: Bool?
    let riskLevel: RiskLevel?

    enum CodingKeys: String, CodingKey {
        case message
        case conversationId = "conversation_id"
        case suggestions
        case riskDetected = "risk_detected"
        case riskLevel = "risk_level"
    }
}

// Model for the legacy/test chat API (http://[REDACTED_IP]:9999/chat)
struct SimpleChatResponse: Codable {
    let response: String
    let riskLevel: String?
    let probability: Double?
    let historyLength: Int?

    enum CodingKeys: String, CodingKey {
        case response
        case riskLevel = "risk_level"
        case probability
        case historyLength = "history_length"
    }
}

// MARK: - Chat Message

struct ChatMessage: Codable, Identifiable {
    let id: String
    let conversationId: String
    let role: MessageRole
    let content: String
    let createdAt: Date
    var isRead: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case conversationId = "conversation_id"
        case role
        case content
        case createdAt = "created_at"
        case isRead = "is_read"
    }
}

// MARK: - Message Role

enum MessageRole: String, Codable {
    case user = "user"
    case assistant = "assistant"
    case system = "system"
}

// MARK: - Conversation

struct Conversation: Codable, Identifiable {
    let id: String
    let userId: String
    let title: String?
    let lastMessage: ChatMessage?
    let messageCount: Int
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case lastMessage = "last_message"
        case messageCount = "message_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Suggestion

struct Suggestion: Codable, Identifiable {
    let id: String
    let type: SuggestionType
    let title: String
    let description: String
    let actionText: String?
    let priority: Int

    enum CodingKeys: String, CodingKey {
        case id, type, title, description
        case actionText = "action_text"
        case priority
    }
}

// MARK: - Suggestion Type

enum SuggestionType: String, Codable {
    case activity = "activity"
    case breathing = "breathing"
    case meditation = "meditation"
    case journal = "journal"
    case exercise = "exercise"
    case social = "social"
    case sleep = "sleep"
    case professional = "professional"

    var icon: String {
        switch self {
        case .activity: return "figure.walk"
        case .breathing: return "wind"
        case .meditation: return "brain.head.profile"
        case .journal: return "book.fill"
        case .exercise: return "figure.run"
        case .social: return "person.2.fill"
        case .sleep: return "bed.double.fill"
        case .professional: return "person.badge.plus"
        }
    }
}
