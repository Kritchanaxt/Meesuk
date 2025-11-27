//
//  APIEndpoints.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation

/// API Endpoints สำหรับ MindCare Backend
enum APIEndpoints {
    
    // MARK: - Base
    static let baseURL = AppEnvironment.current.baseURL
    
    // MARK: - Auth
    enum Auth {
        static let login = "/auth/login"
        static let register = "/auth/register"
        static let logout = "/auth/logout"
        static let refreshToken = "/auth/refresh"
        static let appleLogin = "/auth/apple"
        static let forgotPassword = "/auth/forgot-password"
        static let resetPassword = "/auth/reset-password"
        static let verifyEmail = "/auth/verify-email"
    }
    
    // MARK: - User
    enum User {
        static let profile = "/users/profile"
        static let updateProfile = "/users/profile"
        static let deleteAccount = "/users/account"
        static let settings = "/users/settings"
        static let notifications = "/users/notifications"
        
        static func user(id: String) -> String {
            "/users/\(id)"
        }
    }
    
    // MARK: - Health Data
    enum Health {
        static let metrics = "/health/metrics"
        static let sync = "/health/sync"
        static let history = "/health/history"
        static let analysis = "/health/analysis"
        static let summary = "/health/summary"
        
        static func metrics(userId: String) -> String {
            "/health/\(userId)/metrics"
        }
        
        static func history(days: Int) -> String {
            "/health/history?days=\(days)"
        }
    }
    
    // MARK: - AI / Chat
    enum AI {
        static let chat = "/ai/chat"
        static let analyze = "/ai/analyze"
        static let suggestions = "/ai/suggestions"
        static let riskAssessment = "/ai/risk-assessment"
        
        static func conversation(id: String) -> String {
            "/ai/conversations/\(id)"
        }
    }
    
    // MARK: - Activities
    enum Activities {
        static let list = "/activities"
        static let recommended = "/activities/recommended"
        static let complete = "/activities/complete"
        
        static func activity(id: String) -> String {
            "/activities/\(id)"
        }
    }
    
    // MARK: - Mood / Check-in
    enum Mood {
        static let checkIn = "/mood/check-in"
        static let history = "/mood/history"
        static let trends = "/mood/trends"
    }
    
    // MARK: - Appointments (สำหรับ Psychiatrist)
    enum Appointments {
        static let list = "/appointments"
        static let create = "/appointments"
        
        static func appointment(id: String) -> String {
            "/appointments/\(id)"
        }
        
        static func cancel(id: String) -> String {
            "/appointments/\(id)/cancel"
        }
    }
    
    // MARK: - Psychiatrist
    enum Psychiatrist {
        static let patients = "/psychiatrist/patients"
        static let alerts = "/psychiatrist/alerts"
        static let notes = "/psychiatrist/notes"
        
        static func patient(id: String) -> String {
            "/psychiatrist/patients/\(id)"
        }
        
        static func patientNotes(patientId: String) -> String {
            "/psychiatrist/patients/\(patientId)/notes"
        }
    }
    
    // MARK: - Payment
    enum Payment {
        static let process = "/payments/process"
        static let verify = "/payments/verify"
        static let history = "/payments/history"
        static let refund = "/payments/refund"
        
        // Subscription
        static let subscriptions = "/payments/subscriptions"
        static let subscribePlan = "/payments/subscribe"
        static let cancelSubscription = "/payments/subscriptions/cancel"
        static let plans = "/payments/plans"
        
        static func transaction(id: String) -> String {
            "/payments/transactions/\(id)"
        }
        
        static func receipt(transactionId: String) -> String {
            "/payments/receipts/\(transactionId)"
        }
    }
}
