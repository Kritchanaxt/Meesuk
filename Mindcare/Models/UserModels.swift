//
//  UserModels.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation

// MARK: - User Profile

struct UserProfile: Codable, Identifiable {
    let id: String?
    var email: String
    var name: String
    var avatar: String?
    let role: UserRole
    var dateOfBirth: Date?
    var gender: Gender?
    var phoneNumber: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    // Health profile
    var height: Double? // cm
    var weight: Double? // kg
    var bloodType: String?
    var emergencyContact: EmergencyContact?
    
    enum CodingKeys: String, CodingKey {
        case id, email, name, avatar, role
        case dateOfBirth = "date_of_birth"
        case gender
        case phoneNumber = "phone_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case height, weight
        case bloodType = "blood_type"
        case emergencyContact = "emergency_contact"
    }
}

// MARK: - Gender

enum Gender: String, Codable, CaseIterable {
    case male = "male"
    case female = "female"
    case other = "other"
    case preferNotToSay = "prefer_not_to_say"
    
    var displayName: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        case .other: return "Other"
        case .preferNotToSay: return "Prefer not to say"
        }
    }
}

// MARK: - Emergency Contact

struct EmergencyContact: Codable {
    var name: String
    var relationship: String
    var phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case name, relationship
        case phoneNumber = "phone_number"
    }
}

// MARK: - Update Profile Request

struct UpdateProfileRequest: Codable {
    var name: String?
    var avatar: String?
    var dateOfBirth: Date?
    var gender: Gender?
    var phoneNumber: String?
    var height: Double?
    var weight: Double?
    var emergencyContact: EmergencyContact?
    
    enum CodingKeys: String, CodingKey {
        case name, avatar
        case dateOfBirth = "date_of_birth"
        case gender
        case phoneNumber = "phone_number"
        case height, weight
        case emergencyContact = "emergency_contact"
    }
}

// MARK: - Patient Summary (สำหรับ Psychiatrist)

struct PatientSummary: Codable, Identifiable {
    let id: String
    let name: String
    let avatar: String?
    let lastActivity: Date?
    let riskLevel: RiskLevel
    let lastMoodScore: Double?
    let alertCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, avatar
        case lastActivity = "last_activity"
        case riskLevel = "risk_level"
        case lastMoodScore = "last_mood_score"
        case alertCount = "alert_count"
    }
}

// MARK: - Patient Detail

struct PatientDetail: Codable, Identifiable {
    let id: String
    let profile: UserProfile
    let healthSummary: HealthSummary?
    let recentMoods: [MoodEntry]
    let riskAssessment: RiskAssessment?
    let notes: [PatientNote]
    let appointments: [Appointment]
    
    enum CodingKeys: String, CodingKey {
        case id, profile
        case healthSummary = "health_summary"
        case recentMoods = "recent_moods"
        case riskAssessment = "risk_assessment"
        case notes, appointments
    }
}

// MARK: - Patient Note

struct PatientNote: Codable, Identifiable {
    let id: String
    let patientId: String
    let psychiatristId: String
    let note: String
    let createdAt: Date
    let isPrivate: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case patientId = "patient_id"
        case psychiatristId = "psychiatrist_id"
        case note
        case createdAt = "created_at"
        case isPrivate = "is_private"
    }
}

// MARK: - Risk Level

enum RiskLevel: String, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
    
    var displayName: String {
        switch self {
        case .low: return "Low Risk"
        case .medium: return "Medium Risk"
        case .high: return "High Risk"
        case .critical: return "Critical"
        }
    }
    
    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "yellow"
        case .high: return "orange"
        case .critical: return "red"
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "checkmark.circle.fill"
        case .medium: return "exclamationmark.circle.fill"
        case .high: return "exclamationmark.triangle.fill"
        case .critical: return "xmark.octagon.fill"
        }
    }
}

// MARK: - Risk Assessment

struct RiskAssessment: Codable, Identifiable {
    let id: String
    let userId: String
    let assessedAt: Date
    let overallRisk: RiskLevel
    let factors: [RiskFactor]
    let recommendations: [String]
    let needsImmediateAttention: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case assessedAt = "assessed_at"
        case overallRisk = "overall_risk"
        case factors
        case recommendations
        case needsImmediateAttention = "needs_immediate_attention"
    }
}

// MARK: - Risk Factor

struct RiskFactor: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let severity: RiskLevel
    let score: Double // 0-100
}

// MARK: - Alert

struct Alert: Codable, Identifiable {
    let id: String
    let patientId: String
    let patientName: String
    let type: AlertType
    let message: String
    let severity: RiskLevel
    let createdAt: Date
    var isRead: Bool
    var isResolved: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case patientId = "patient_id"
        case patientName = "patient_name"
        case type, message, severity
        case createdAt = "created_at"
        case isRead = "is_read"
        case isResolved = "is_resolved"
    }
}

// MARK: - Alert Type

enum AlertType: String, Codable {
    case highRisk = "high_risk"
    case missedCheckIn = "missed_check_in"
    case abnormalHealth = "abnormal_health"
    case textRisk = "text_risk"
    case appointmentReminder = "appointment_reminder"
    
    var displayName: String {
        switch self {
        case .highRisk: return "High Risk Alert"
        case .missedCheckIn: return "Missed Check-in"
        case .abnormalHealth: return "Abnormal Health Data"
        case .textRisk: return "Risk Detected in Message"
        case .appointmentReminder: return "Appointment Reminder"
        }
    }
    
    var icon: String {
        switch self {
        case .highRisk: return "exclamationmark.triangle.fill"
        case .missedCheckIn: return "calendar.badge.exclamationmark"
        case .abnormalHealth: return "heart.slash.fill"
        case .textRisk: return "text.bubble.fill"
        case .appointmentReminder: return "calendar"
        }
    }
}
