//
//  ActivityModels.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation

// MARK: - Activity

struct Activity: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let category: ActivityCategory
    let duration: Int // minutes
    let difficulty: ActivityDifficulty
    let benefits: [String]
    let instructions: [String]?
    let imageUrl: String?
    let videoUrl: String?
    let isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, category, duration, difficulty, benefits, instructions
        case imageUrl = "image_url"
        case videoUrl = "video_url"
        case isCompleted = "is_completed"
    }
}

// MARK: - Activity Category

enum ActivityCategory: String, Codable, CaseIterable {
    case breathing = "breathing"
    case meditation = "meditation"
    case exercise = "exercise"
    case journaling = "journaling"
    case mindfulness = "mindfulness"
    case social = "social"
    case creative = "creative"
    case relaxation = "relaxation"
    case sleep = "sleep"
    case gratitude = "gratitude"
    
    var displayName: String {
        switch self {
        case .breathing: return "Breathing"
        case .meditation: return "Meditation"
        case .exercise: return "Exercise"
        case .journaling: return "Journaling"
        case .mindfulness: return "Mindfulness"
        case .social: return "Social"
        case .creative: return "Creative"
        case .relaxation: return "Relaxation"
        case .sleep: return "Sleep"
        case .gratitude: return "Gratitude"
        }
    }
    
    var icon: String {
        switch self {
        case .breathing: return "wind"
        case .meditation: return "brain.head.profile"
        case .exercise: return "figure.run"
        case .journaling: return "book.fill"
        case .mindfulness: return "leaf.fill"
        case .social: return "person.2.fill"
        case .creative: return "paintpalette.fill"
        case .relaxation: return "cup.and.saucer.fill"
        case .sleep: return "moon.fill"
        case .gratitude: return "heart.fill"
        }
    }
    
    var color: String {
        switch self {
        case .breathing: return "cyan"
        case .meditation: return "purple"
        case .exercise: return "orange"
        case .journaling: return "brown"
        case .mindfulness: return "green"
        case .social: return "pink"
        case .creative: return "indigo"
        case .relaxation: return "teal"
        case .sleep: return "blue"
        case .gratitude: return "red"
        }
    }
}

// MARK: - Activity Difficulty

enum ActivityDifficulty: String, Codable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var color: String {
        switch self {
        case .easy: return "green"
        case .medium: return "orange"
        case .hard: return "red"
        }
    }
}

// MARK: - Activity Completion Response

struct ActivityCompletionResponse: Codable {
    let success: Bool
    let message: String
    let pointsEarned: Int?
    let streak: Int?
    let badge: Badge?
    
    enum CodingKeys: String, CodingKey {
        case success, message
        case pointsEarned = "points_earned"
        case streak
        case badge
    }
}

// MARK: - Badge

struct Badge: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let earnedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, icon
        case earnedAt = "earned_at"
    }
}

// MARK: - User Activity Stats

struct UserActivityStats: Codable {
    let totalCompleted: Int
    let currentStreak: Int
    let longestStreak: Int
    let totalMinutes: Int
    let categoriesCompleted: [CategoryCount]
    let badges: [Badge]
    
    enum CodingKeys: String, CodingKey {
        case totalCompleted = "total_completed"
        case currentStreak = "current_streak"
        case longestStreak = "longest_streak"
        case totalMinutes = "total_minutes"
        case categoriesCompleted = "categories_completed"
        case badges
    }
}

// MARK: - Category Count

struct CategoryCount: Codable, Identifiable {
    var id: String { category.rawValue }
    let category: ActivityCategory
    let count: Int
}
