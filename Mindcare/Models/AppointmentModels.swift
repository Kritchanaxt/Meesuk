//
//  AppointmentModels.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation

// MARK: - Appointment

struct Appointment: Codable, Identifiable {
    let id: String
    let patientId: String
    let psychiatristId: String
    let psychiatristName: String?
    let patientName: String?
    let scheduledAt: Date
    let duration: Int // minutes
    let type: AppointmentType
    var status: AppointmentStatus
    let notes: String?
    let meetingUrl: String?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case patientId = "patient_id"
        case psychiatristId = "psychiatrist_id"
        case psychiatristName = "psychiatrist_name"
        case patientName = "patient_name"
        case scheduledAt = "scheduled_at"
        case duration
        case type
        case status
        case notes
        case meetingUrl = "meeting_url"
        case createdAt = "created_at"
    }
    
    var endTime: Date {
        Calendar.current.date(byAdding: .minute, value: duration, to: scheduledAt) ?? scheduledAt
    }
    
    var isUpcoming: Bool {
        scheduledAt > Date() && status == .scheduled
    }
    
    var isPast: Bool {
        scheduledAt < Date()
    }
}

// MARK: - Appointment Type

enum AppointmentType: String, Codable {
    case initial = "initial"
    case followUp = "follow_up"
    case emergency = "emergency"
    case consultation = "consultation"
    
    var displayName: String {
        switch self {
        case .initial: return "Initial Consultation"
        case .followUp: return "Follow-up"
        case .emergency: return "Emergency"
        case .consultation: return "Consultation"
        }
    }
    
    var icon: String {
        switch self {
        case .initial: return "person.badge.plus"
        case .followUp: return "arrow.triangle.2.circlepath"
        case .emergency: return "exclamationmark.triangle.fill"
        case .consultation: return "bubble.left.and.bubble.right.fill"
        }
    }
}

// MARK: - Appointment Status

enum AppointmentStatus: String, Codable {
    case scheduled = "scheduled"
    case confirmed = "confirmed"
    case inProgress = "in_progress"
    case completed = "completed"
    case cancelled = "cancelled"
    case noShow = "no_show"
    case rescheduled = "rescheduled"
    
    var displayName: String {
        switch self {
        case .scheduled: return "Scheduled"
        case .confirmed: return "Confirmed"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        case .noShow: return "No Show"
        case .rescheduled: return "Rescheduled"
        }
    }
    
    var color: String {
        switch self {
        case .scheduled: return "blue"
        case .confirmed: return "green"
        case .inProgress: return "orange"
        case .completed: return "gray"
        case .cancelled, .noShow: return "red"
        case .rescheduled: return "purple"
        }
    }
}

// MARK: - Create Appointment Request

struct CreateAppointmentRequest: Codable {
    let psychiatristId: String
    let scheduledAt: Date
    let duration: Int
    let type: AppointmentType
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case psychiatristId = "psychiatrist_id"
        case scheduledAt = "scheduled_at"
        case duration
        case type
        case notes
    }
}

// MARK: - Reschedule Request

struct RescheduleAppointmentRequest: Codable {
    let appointmentId: String
    let newScheduledAt: Date
    let reason: String?
    
    enum CodingKeys: String, CodingKey {
        case appointmentId = "appointment_id"
        case newScheduledAt = "new_scheduled_at"
        case reason
    }
}

// MARK: - Available Slot

struct AvailableSlot: Codable, Identifiable {
    var id: String { "\(psychiatristId)_\(startTime.ISO8601Format())" }
    let psychiatristId: String
    let startTime: Date
    let endTime: Date
    let duration: Int
    
    enum CodingKeys: String, CodingKey {
        case psychiatristId = "psychiatrist_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case duration
    }
}

// MARK: - Psychiatrist

struct Psychiatrist: Codable, Identifiable {
    let id: String
    let name: String
    let avatar: String?
    let specialization: String
    let bio: String?
    let rating: Double?
    let reviewCount: Int
    let yearsOfExperience: Int
    let languages: [String]
    let isAvailable: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, avatar, specialization, bio, rating
        case reviewCount = "review_count"
        case yearsOfExperience = "years_of_experience"
        case languages
        case isAvailable = "is_available"
    }
}
