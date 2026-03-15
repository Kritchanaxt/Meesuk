//
//  APIService.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Combine
import Foundation

/// API Service - High-level API calls สำหรับ MindCare
final class APIService {

    // MARK: - Singleton
    static let shared = APIService()

    // MARK: - Properties
    private let network = NetworkManager.shared

    private init() {}

    // MARK: - Auth APIs

    /// Login
    func login(email: String, password: String) async throws -> AuthResponse {
        let params: [String: Any] = [
            "email": email,
            "password": password,
        ]
        return try await network.post(APIEndpoints.Auth.login, parameters: params)
    }

    /// Register
    func register(email: String, password: String, name: String) async throws -> AuthResponse {
        let request = RegisterRequest(email: email, password: password, name: name)
        return try await network.post(APIEndpoints.Auth.register, body: request)
    }

    /// Apple Login
    func appleLogin(identityToken: String, authorizationCode: String, fullName: String?)
        async throws -> AuthResponse
    {
        let request = AppleLoginRequest(
            identityToken: identityToken,
            authorizationCode: authorizationCode,
            fullName: fullName
        )
        return try await network.post(APIEndpoints.Auth.appleLogin, body: request)
    }

    /// Refresh Token
    func refreshToken(refreshToken: String) async throws -> TokenResponse {
        let params: [String: Any] = ["refresh_token": refreshToken]
        return try await network.post(APIEndpoints.Auth.refreshToken, parameters: params)
    }

    /// Logout
    func logout() async throws {
        try await network.delete(APIEndpoints.Auth.logout)
    }

    // MARK: - User APIs

    /// Get User Profile
    func getProfile() async throws -> UserProfile {
        try await network.get(APIEndpoints.User.profile)
    }

    /// Update Profile
    func updateProfile(_ profile: UpdateProfileRequest) async throws -> UserProfile {
        try await network.put(APIEndpoints.User.updateProfile, body: profile)
    }

    // MARK: - Health Data APIs

    /// Sync Health Data
    func syncHealthData(_ metrics: HealthMetrics) async throws -> SyncResponse {
        try await network.post(APIEndpoints.Health.sync, body: metrics)
    }

    /// Get Health History
    func getHealthHistory(days: Int = 7) async throws -> [HealthMetrics] {
        try await network.get(APIEndpoints.Health.history(days: days))
    }

    /// Get Health Analysis
    func getHealthAnalysis() async throws -> HealthAnalysis {
        try await network.get(APIEndpoints.Health.analysis)
    }

    /// Get Health Summary
    func getHealthSummary() async throws -> HealthSummary {
        try await network.get(APIEndpoints.Health.summary)
    }

    // MARK: - AI / Chat APIs

    /// Send Message to Meesuk Chat Bot (http://[REDACTED_IP]:9999/chat)
    func sendMessageToChatBot(_ message: String, sessionId: String) async throws
        -> SimpleChatResponse
    {
        let params: [String: Any] = [
            "message": message,
            "session_id": sessionId,
        ]
        return try await network.post(APIEndpoints.AI.chat, parameters: params)
    }

    /// Send Chat Message (New API)
    func sendChatMessage(_ message: String, conversationId: String? = nil) async throws
        -> ChatResponse
    {
        var params: [String: Any] = ["message": message]
        if let conversationId = conversationId {
            params["conversation_id"] = conversationId
        }
        return try await network.post(APIEndpoints.AI.chat, parameters: params)
    }

    /// Get AI Suggestions
    func getAISuggestions() async throws -> [Suggestion] {
        try await network.get(APIEndpoints.AI.suggestions)
    }

    /// Risk Assessment
    func getRiskAssessment() async throws -> RiskAssessment {
        try await network.get(APIEndpoints.AI.riskAssessment)
    }

    // MARK: - Mood APIs

    /// Check-in Mood
    func checkInMood(_ checkIn: MoodCheckIn) async throws -> MoodCheckInResponse {
        try await network.post(APIEndpoints.Mood.checkIn, body: checkIn)
    }

    /// Get Mood History
    func getMoodHistory() async throws -> [MoodEntry] {
        try await network.get(APIEndpoints.Mood.history)
    }

    /// Get Mood Trends
    func getMoodTrends() async throws -> MoodTrends {
        try await network.get(APIEndpoints.Mood.trends)
    }

    // MARK: - Activities APIs

    /// Get Recommended Activities
    func getRecommendedActivities() async throws -> [Activity] {
        try await network.get(APIEndpoints.Activities.recommended)
    }

    /// Complete Activity
    func completeActivity(id: String) async throws -> ActivityCompletionResponse {
        try await network.post("\(APIEndpoints.Activities.complete)/\(id)", parameters: nil)
    }

    // MARK: - Appointment APIs (สำหรับ User)

    /// Get Appointments
    func getAppointments() async throws -> [Appointment] {
        try await network.get(APIEndpoints.Appointments.list)
    }

    /// Create Appointment
    func createAppointment(_ appointment: CreateAppointmentRequest) async throws -> Appointment {
        try await network.post(APIEndpoints.Appointments.create, body: appointment)
    }

    /// Cancel Appointment
    func cancelAppointment(id: String) async throws {
        try await network.delete(APIEndpoints.Appointments.cancel(id: id))
    }

    // MARK: - Psychiatrist APIs

    /// Get Patients List
    func getPatients() async throws -> [PatientSummary] {
        try await network.get(APIEndpoints.Psychiatrist.patients)
    }

    /// Get Patient Detail
    func getPatient(id: String) async throws -> PatientDetail {
        try await network.get(APIEndpoints.Psychiatrist.patient(id: id))
    }

    /// Get Alerts
    func getAlerts() async throws -> [Alert] {
        try await network.get(APIEndpoints.Psychiatrist.alerts)
    }

    /// Add Patient Note
    func addPatientNote(patientId: String, note: String) async throws -> PatientNote {
        let params: [String: Any] = ["note": note]
        return try await network.post(
            APIEndpoints.Psychiatrist.patientNotes(patientId: patientId), parameters: params)
    }
}
