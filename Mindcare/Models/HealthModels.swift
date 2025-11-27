//
//  HealthModels.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation

// MARK: - Health Metrics

/// ข้อมูลสุขภาพที่รวบรวมจาก HealthKit
struct HealthMetrics: Codable {
    var timestamp: Date?
    var heartRate: Double?
    var hrv: Double?
    var oxygenSaturation: Double?
    var steps: Int?
    var activeEnergy: Double?
    var restingHeartRate: Double?
    var vo2Max: Double?
    var sleepHours: Double?
    var sleepQuality: SleepQuality?
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case heartRate = "heart_rate"
        case hrv
        case oxygenSaturation = "oxygen_saturation"
        case steps
        case activeEnergy = "active_energy"
        case restingHeartRate = "resting_heart_rate"
        case vo2Max = "vo2_max"
        case sleepHours = "sleep_hours"
        case sleepQuality = "sleep_quality"
    }
}

// MARK: - Health Data Point

/// จุดข้อมูลสุขภาพสำหรับ Chart
struct HealthDataPoint: Identifiable, Codable {
    let id: UUID
    let date: Date
    let value: Double
    let type: HealthDataType
    
    init(id: UUID = UUID(), date: Date, value: Double, type: HealthDataType) {
        self.id = id
        self.date = date
        self.value = value
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case id, date, value, type
    }
}

// MARK: - Health Data Type

enum HealthDataType: String, Codable, CaseIterable {
    case heartRate = "heart_rate"
    case hrv = "hrv"
    case oxygenSaturation = "oxygen_saturation"
    case steps = "steps"
    case activeEnergy = "active_energy"
    case sleep = "sleep"
    case restingHeartRate = "resting_heart_rate"
    case vo2Max = "vo2_max"
    
    var displayName: String {
        switch self {
        case .heartRate: return "Heart Rate"
        case .hrv: return "HRV"
        case .oxygenSaturation: return "Blood Oxygen"
        case .steps: return "Steps"
        case .activeEnergy: return "Active Energy"
        case .sleep: return "Sleep"
        case .restingHeartRate: return "Resting HR"
        case .vo2Max: return "VO2 Max"
        }
    }
    
    var unit: String {
        switch self {
        case .heartRate, .restingHeartRate: return "BPM"
        case .hrv: return "ms"
        case .oxygenSaturation: return "%"
        case .steps: return "steps"
        case .activeEnergy: return "kcal"
        case .sleep: return "hours"
        case .vo2Max: return "ml/kg·min"
        }
    }
    
    var icon: String {
        switch self {
        case .heartRate, .restingHeartRate: return "heart.fill"
        case .hrv: return "waveform.path.ecg"
        case .oxygenSaturation: return "lungs.fill"
        case .steps: return "figure.walk"
        case .activeEnergy: return "flame.fill"
        case .sleep: return "bed.double.fill"
        case .vo2Max: return "wind"
        }
    }
}

// MARK: - Sleep Data

/// ข้อมูลการนอน
struct SleepData: Identifiable, Codable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let stage: SleepStage
    
    init(id: UUID = UUID(), startDate: Date, endDate: Date, stage: SleepStage) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.stage = stage
    }
    
    var duration: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }
    
    var durationInHours: Double {
        duration / 3600.0
    }
}

// MARK: - Sleep Stage

enum SleepStage: String, Codable {
    case awake = "awake"
    case asleep = "asleep"
    case core = "core"
    case deep = "deep"
    case rem = "rem"
    case unknown = "unknown"
    
    var displayName: String {
        switch self {
        case .awake: return "Awake"
        case .asleep: return "Asleep"
        case .core: return "Core Sleep"
        case .deep: return "Deep Sleep"
        case .rem: return "REM Sleep"
        case .unknown: return "Unknown"
        }
    }
    
    var color: String {
        switch self {
        case .awake: return "orange"
        case .asleep: return "blue"
        case .core: return "indigo"
        case .deep: return "purple"
        case .rem: return "cyan"
        case .unknown: return "gray"
        }
    }
}

// MARK: - Sleep Quality

enum SleepQuality: String, Codable {
    case poor = "poor"
    case fair = "fair"
    case good = "good"
    case excellent = "excellent"
    
    var score: Int {
        switch self {
        case .poor: return 1
        case .fair: return 2
        case .good: return 3
        case .excellent: return 4
        }
    }
}

// MARK: - Health Analysis

/// ผลวิเคราะห์สุขภาพจาก AI
struct HealthAnalysis: Codable, Identifiable {
    let id: String
    let userId: String
    let analyzedAt: Date
    let stressScore: Double // 0-100
    let moodScore: Double // 0-100
    let sleepQualityScore: Double // 0-100
    let activityScore: Double // 0-100
    let overallScore: Double // 0-100
    let insights: [HealthInsight]
    let recommendations: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case analyzedAt = "analyzed_at"
        case stressScore = "stress_score"
        case moodScore = "mood_score"
        case sleepQualityScore = "sleep_quality_score"
        case activityScore = "activity_score"
        case overallScore = "overall_score"
        case insights
        case recommendations
    }
}

// MARK: - Health Insight

struct HealthInsight: Codable, Identifiable {
    let id: String
    let type: InsightType
    let title: String
    let description: String
    let severity: InsightSeverity
    
    enum InsightType: String, Codable {
        case positive = "positive"
        case warning = "warning"
        case alert = "alert"
        case info = "info"
    }
    
    enum InsightSeverity: String, Codable {
        case low = "low"
        case medium = "medium"
        case high = "high"
    }
}

// MARK: - Health Summary

struct HealthSummary: Codable {
    let period: String // "daily", "weekly", "monthly"
    let averageHeartRate: Double?
    let averageHRV: Double?
    let totalSteps: Int?
    let totalActiveEnergy: Double?
    let averageSleepHours: Double?
    let stressLevel: StressLevel
    let moodTrend: MoodTrend
    
    enum CodingKeys: String, CodingKey {
        case period
        case averageHeartRate = "average_heart_rate"
        case averageHRV = "average_hrv"
        case totalSteps = "total_steps"
        case totalActiveEnergy = "total_active_energy"
        case averageSleepHours = "average_sleep_hours"
        case stressLevel = "stress_level"
        case moodTrend = "mood_trend"
    }
}

// MARK: - Stress Level

enum StressLevel: String, Codable {
    case low = "low"
    case moderate = "moderate"
    case high = "high"
    case veryHigh = "very_high"
    
    var displayName: String {
        switch self {
        case .low: return "Low"
        case .moderate: return "Moderate"
        case .high: return "High"
        case .veryHigh: return "Very High"
        }
    }
    
    var color: String {
        switch self {
        case .low: return "green"
        case .moderate: return "yellow"
        case .high: return "orange"
        case .veryHigh: return "red"
        }
    }
}

// MARK: - Mood Trend

enum MoodTrend: String, Codable {
    case improving = "improving"
    case stable = "stable"
    case declining = "declining"
    
    var icon: String {
        switch self {
        case .improving: return "arrow.up.right"
        case .stable: return "arrow.right"
        case .declining: return "arrow.down.right"
        }
    }
}

// MARK: - Sync Response

struct SyncResponse: Codable {
    let success: Bool
    let message: String
    let syncedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case success, message
        case syncedAt = "synced_at"
    }
}
