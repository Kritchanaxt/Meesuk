//
//  MatchingModels.swift
//  Mindcare
//

import Foundation

// MARK: - Traits and Preferences

enum ProblemType: String, CaseIterable, Codable {
    case anxiety = "Anxiety"
    case workStress = "Work Stress"
    case burnout = "Burnout"
    case depression = "Depression"
    case relationshipIssues = "Relationship Issues"
    case sleepProblems = "Sleep Problems"
    case grief = "Grief"
    case socialAnxiety = "Social Anxiety"
    case trauma = "Trauma"
    case adhdSymptoms = "ADHD Symptoms"
    case notSure = "Not Sure"
}

enum IntensityLevel: String, CaseIterable, Codable {
    case mild = "Mild"
    case moderate = "Moderate"
    case high = "High"
    case veryHigh = "Very High"
}

enum TherapyStylePreference: String, CaseIterable, Codable {
    case warmSupportive = "Warm & Supportive"
    case calmListener = "Calm & Good Listener"
    case structuredGoalOriented = "Structured & Goal Oriented"
    case practicalAdvice = "Practical Advice"
    case friendlyConversational = "Friendly & Conversational"
    case notSure = "Not Sure"
}

enum CommunicationPreference: String, CaseIterable, Codable {
    case textChat = "Text Chat"
    case voiceCall = "Voice Call"
    case videoSession = "Video Session"
    case openToAny = "Open to Any"
}

enum BudgetPreference: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case aiRecommend = "AI Recommend"
}

// MARK: - User Preference (from Questionnaire)

struct UserPreference: Codable {
    var problems: [ProblemType]
    var intensity: IntensityLevel
    var styles: [TherapyStylePreference]
    var communication: CommunicationPreference
    var budget: BudgetPreference

    // Processed requirements for matching
    var requiredSpecialties: [String] {
        var specialties: [String] = []
        for problem in problems {
            switch problem {
            case .anxiety: specialties.append("anxiety")
            case .workStress, .burnout: specialties.append("burnout")
            case .depression: specialties.append("depression")
            case .relationshipIssues: specialties.append("relationship")
            case .sleepProblems: specialties.append("sleep")
            case .grief: specialties.append("grief")
            case .socialAnxiety: specialties.append("social_anxiety")
            case .trauma: specialties.append("trauma")
            case .adhdSymptoms: specialties.append("adhd")
            case .notSure: specialties.append("general")
            }
        }
        return specialties
    }

    var requiredIntensitySupport: String {
        switch intensity {
        case .mild: return "mild"
        case .moderate: return "moderate"
        case .high: return "high"
        case .veryHigh: return "clinical"
        }
    }

    var preferredStyles: [String] {
        var mappedStyles: [String] = []
        for style in styles {
            switch style {
            case .warmSupportive: mappedStyles.append("warm")
            case .calmListener: mappedStyles.append("listener")
            case .structuredGoalOriented: mappedStyles.append("structured")
            case .practicalAdvice: mappedStyles.append("practical")
            case .friendlyConversational: mappedStyles.append("conversational")
            case .notSure: mappedStyles.append("general")
            }
        }
        return mappedStyles
    }

    var preferredCommunication: String? {
        switch communication {
        case .textChat: return "text"
        case .voiceCall: return "voice"
        case .videoSession: return "video"
        case .openToAny: return nil
        }
    }

    var preferredPriceLevel: String? {
        switch budget {
        case .low: return "low"
        case .medium: return "medium"
        case .high: return "high"
        case .aiRecommend: return nil
        }
    }
}
