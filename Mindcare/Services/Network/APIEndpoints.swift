import Foundation

/// API Endpoints สำหรับ MindCare Backend
enum APIEndpoints {
    
    // MARK: - Base Configuration
    static let host = AppEnvironment.current.apiHost
    static let httpScheme = "http://"
    static let wsScheme = "ws://"

    // MARK: - Auth (Port 8081)
    enum Auth {
        static let base = "\(httpScheme)\(host):8081"
        static let login = "\(base)/auth/login"
        static let register = "\(base)/auth/register"
        static let logout = "\(base)/auth/logout"
        static let refreshToken = "\(base)/auth/refresh"
        static let appleLogin = "\(base)/auth/apple"
        static let forgotPassword = "\(base)/auth/forgot-password"
        static let resetPassword = "\(base)/auth/reset-password"
        static let verifyEmail = "\(base)/auth/verify-email"
    }

    // MARK: - User (Port 8082)
    enum User {
        static let base = "\(httpScheme)\(host):8082"
        static let profile = "\(base)/users/profile"
        static let updateProfile = "\(base)/users/profile"
        static let emergencyContacts = "\(base)/emergency-contacts"

        // Psychiatrist listing (under user service)
        static let psychiatrists = "\(base)/psychiatrists"

        // Admin
        static func approvePsychiatrist(id: String) -> String {
            "\(base)/admin/psychiatrists/\(id)/approve"
        }
    }

    // MARK: - Health (Port 8083)
    enum Health {
        static let base = "\(httpScheme)\(host):8083"
        static let metrics = "\(base)/health/metrics"
        static let sync = "\(base)/health/sync"
        static let history = "\(base)/health/history"
        static let analysis = "\(base)/health/analysis"
        static let summary = "\(base)/health/summary"

        static func metricsForUser(userId: String) -> String {
            "\(base)/health/\(userId)/metrics"
        }

        static func historyWithDays(days: Int) -> String {
            "\(base)/health/history?days=\(days)"
        }
    }

    // MARK: - AI (Port 8084)
    enum AI {
        static let base = "\(httpScheme)\(host):8084"
        static let chatBot = "http://\(host):9999/chat"  // Legacy AI chatbot
        static let hotline = "\(base)/ai/hotline"
        static let analyze = "\(base)/ai/analyze"
        static let suggestions = "\(base)/ai/suggestions"
        static let riskAssessment = "\(base)/ai/risk-assessment"
    }

    // MARK: - Mood (Port 8085)
    enum Mood {
        static let base = "\(httpScheme)\(host):8085"
        static let checkIn = "\(base)/mood/check-in"
        static let trends = "\(base)/mood/trends"
        static let seedLast7Days = "\(base)/mood/seed-last-7-days"
        static let journals = "\(base)/journals"
        static let triggers = "\(base)/triggers"

        static func userMoodHistory(userId: String) -> String {
            "\(base)/mood/user/\(userId)/history"
        }

        static func incrementTrigger(id: String) -> String {
            "\(triggers)/\(id)/increment"
        }
    }

    // MARK: - Appointment (Port 8086)
    enum Appointment {
        static let base = "\(httpScheme)\(host):8086"

        // Patient endpoints
        static let list = "\(base)/appointments"
        static let create = "\(base)/appointments"
        static let sessionNotes = "\(base)/session-notes"
        static let mySessionNotes = "\(base)/session-notes/my-notes"
        static let reviews = "\(base)/reviews"
        static let schedules = "\(base)/schedules"

        // Psychiatrist endpoints
        static let psychiatristQueue = "\(base)/appointments/psychiatrist/queue"
        static let chatHistory = "\(base)/chat/history"

        static func changeTherapist(id: String) -> String {
            "\(base)/appointments/\(id)/change-therapist"
        }

        static func accept(id: String) -> String {
            "\(base)/appointments/\(id)/accept"
        }

        static func cancel(id: String) -> String {
            "\(base)/appointments/\(id)/cancel"
        }

        static func patientMoodHistory(userId: String) -> String {
            "\(base)/appointments/psychiatrist/users/\(userId)/moods"
        }

        static func chatHistoryWith(userId: String) -> String {
            "\(base)/chat/history/\(userId)"
        }
    }

    // MARK: - Payment (Port 8087)
    enum Payment {
        static let base = "\(httpScheme)\(host):8087"
        static let process = "\(base)/payments/process"
        static let verify = "\(base)/payments/verify"
        static let history = "\(base)/payments/history"
        static let refund = "\(base)/payments/refund"
        static let subscriptions = "\(base)/payments/subscriptions"
        static let subscribePlan = "\(base)/payments/subscribe"
        static let cancelSubscription = "\(base)/payments/subscriptions/cancel"
        static let plans = "\(base)/payments/plans"
    }

    // MARK: - Notification (Port 8088)
    enum Notification {
        static let base = "\(httpScheme)\(host):8088"
        static let list = "\(base)/users/notifications"
    }

    // MARK: - WebSocket (Port 8089)
    enum WebSocket {
        static let base = "\(wsScheme)\(host):8089"
    }
}
