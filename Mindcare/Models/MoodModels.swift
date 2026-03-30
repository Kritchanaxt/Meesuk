import Foundation

// MARK: - Mood Models Configuration
// This file defines the structures for mood tracking and analytics.

// MARK: - Mood Check-in

struct MoodCheckIn: Codable {
    let moodLevel: Int // 1-5
    let emotions: [Emotion]
    let activities: [String]?
    let notes: String?
    let sleepQuality: Int? // 1-5
    let energyLevel: Int? // 1-5
    let stressLevel: Int? // 1-5
    
    enum CodingKeys: String, CodingKey {
        case moodLevel = "mood_level"
        case emotions
        case activities
        case notes
        case sleepQuality = "sleep_quality"
        case energyLevel = "energy_level"
        case stressLevel = "stress_level"
    }
}

// MARK: - Mood Check-in Response

struct MoodCheckInResponse: Codable {
    let id: String
    let message: String
    let insights: [String]?
    let suggestions: [Suggestion]?
    let riskDetected: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, message, insights, suggestions
        case riskDetected = "risk_detected"
    }
}

// MARK: - Mood Entry

struct MoodEntry: Codable, Identifiable {
    let id: String
    let userId: String
    let moodLevel: Int
    let emotions: [Emotion]
    let activities: [String]?
    let notes: String?
    let sleepQuality: Int?
    let energyLevel: Int?
    let stressLevel: Int?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case moodLevel = "mood_level"
        case emotions
        case activities
        case notes
        case sleepQuality = "sleep_quality"
        case energyLevel = "energy_level"
        case stressLevel = "stress_level"
        case createdAt = "created_at"
    }
    
    var moodEmoji: String {
        switch moodLevel {
        case 1: return "😢"
        case 2: return "😔"
        case 3: return "😐"
        case 4: return "🙂"
        case 5: return "😄"
        default: return "😐"
        }
    }
    
    var moodText: String {
        switch moodLevel {
        case 1: return "Very Bad"
        case 2: return "Bad"
        case 3: return "Okay"
        case 4: return "Good"
        case 5: return "Great"
        default: return "Unknown"
        }
    }
}

// MARK: - Emotion

enum Emotion: String, Codable, CaseIterable {
    case happy = "happy"
    case calm = "calm"
    case excited = "excited"
    case grateful = "grateful"
    case hopeful = "hopeful"
    case content = "content"
    case sad = "sad"
    case anxious = "anxious"
    case angry = "angry"
    case frustrated = "frustrated"
    case lonely = "lonely"
    case stressed = "stressed"
    case tired = "tired"
    case overwhelmed = "overwhelmed"
    case confused = "confused"
    case bored = "bored"
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .calm: return "😌"
        case .excited: return "🤩"
        case .grateful: return "🙏"
        case .hopeful: return "🌟"
        case .content: return "😇"
        case .sad: return "😢"
        case .anxious: return "😰"
        case .angry: return "😠"
        case .frustrated: return "😤"
        case .lonely: return "🥺"
        case .stressed: return "😫"
        case .tired: return "😴"
        case .overwhelmed: return "🤯"
        case .confused: return "😕"
        case .bored: return "😑"
        }
    }
    
    var isPositive: Bool {
        switch self {
        case .happy, .calm, .excited, .grateful, .hopeful, .content:
            return true
        default:
            return false
        }
    }
    
    var category: EmotionCategory {
        switch self {
        case .happy, .excited, .grateful, .hopeful:
            return .positive
        case .calm, .content:
            return .neutral
        case .sad, .lonely:
            return .sadness
        case .anxious, .stressed, .overwhelmed:
            return .anxiety
        case .angry, .frustrated:
            return .anger
        case .tired, .bored, .confused:
            return .fatigue
        }
    }
}

// MARK: - Emotion Category

enum EmotionCategory: String, Codable {
    case positive = "positive"
    case neutral = "neutral"
    case sadness = "sadness"
    case anxiety = "anxiety"
    case anger = "anger"
    case fatigue = "fatigue"
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var color: String {
        switch self {
        case .positive: return "green"
        case .neutral: return "blue"
        case .sadness: return "indigo"
        case .anxiety: return "orange"
        case .anger: return "red"
        case .fatigue: return "gray"
        }
    }
}

// MARK: - Mood Trends

struct MoodTrends: Codable {
    let period: String
    let averageMood: Double
    let moodTrend: MoodTrend
    let topEmotions: [EmotionCount]
    let dailyMoods: [DailyMood]
    let insights: [String]
    
    enum CodingKeys: String, CodingKey {
        case period
        case averageMood = "average_mood"
        case moodTrend = "mood_trend"
        case topEmotions = "top_emotions"
        case dailyMoods = "daily_moods"
        case insights
    }
}

// MARK: - Emotion Count

struct EmotionCount: Codable, Identifiable {
    var id: String { emotion.rawValue }
    let emotion: Emotion
    let count: Int
}

// MARK: - Daily Mood

struct DailyMood: Codable, Identifiable {
    var id: String { date.ISO8601Format() }
    let date: Date
    let averageMood: Double
    let checkInCount: Int
    
    enum CodingKeys: String, CodingKey {
        case date
        case averageMood = "average_mood"
        case checkInCount = "check_in_count"
    }
}
