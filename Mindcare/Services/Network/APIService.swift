import Combine
import Foundation

/// API Service — High-level API calls สำหรับ MindCare
final class APIService {

    // MARK: - Singleton
    static let shared = APIService()
    private let network = NetworkManager.shared
    private init() {}

    // MARK: - Auth APIs

    func login(email: String, password: String) async throws -> AuthResponse {
        let params: [String: Any] = ["email": email, "password": password]
        return try await network.post(APIEndpoints.Auth.login, parameters: params)
    }

    func register(email: String, password: String, name: String) async throws -> AuthResponse {
        let request = RegisterRequest(email: email, password: password, name: name)
        return try await network.post(APIEndpoints.Auth.register, body: request)
    }

    func appleLogin(identityToken: String, authorizationCode: String, fullName: String?) async throws -> AuthResponse {
        let request = AppleLoginRequest(identityToken: identityToken, authorizationCode: authorizationCode, fullName: fullName)
        return try await network.post(APIEndpoints.Auth.appleLogin, body: request)
    }

    func refreshToken(refreshToken: String) async throws -> TokenResponse {
        let params: [String: Any] = ["refresh_token": refreshToken]
        return try await network.post(APIEndpoints.Auth.refreshToken, parameters: params)
    }

    func logout() async throws {
        try await network.delete(APIEndpoints.Auth.logout)
    }

    // MARK: - User APIs

    func getProfile() async throws -> UserProfile {
        try await network.get(APIEndpoints.User.profile)
    }

    func updateProfile(_ profile: UpdateProfileRequest) async throws -> UserProfile {
        try await network.put(APIEndpoints.User.updateProfile, body: profile)
    }

    // MARK: - Psychiatrist APIs (User Service — Port 8082)

    /// GET /psychiatrists — ดึงรายชื่อจิตแพทย์จาก DB จริง
    func getPsychiatrists() async throws -> [Psychiatrist] {
        try await network.get(APIEndpoints.User.psychiatrists)
    }

    /// POST /admin/psychiatrists/{id}/approve — Admin อนุมัติจิตแพทย์
    func approvePsychiatrist(id: String) async throws {
        let _: EmptyResponse = try await network.post(APIEndpoints.User.approvePsychiatrist(id: id), parameters: nil)
    }

    // MARK: - Health APIs (Port 8083)

    func syncHealthData(_ metrics: HealthMetrics) async throws -> SyncResponse {
        try await network.post(APIEndpoints.Health.sync, body: metrics)
    }

    func getHealthHistory(days: Int = 7) async throws -> [HealthMetrics] {
        try await network.get(APIEndpoints.Health.historyWithDays(days: days))
    }

    func getHealthAnalysis() async throws -> HealthAnalysis {
        try await network.get(APIEndpoints.Health.analysis)
    }

    func getHealthSummary() async throws -> HealthSummary {
        try await network.get(APIEndpoints.Health.summary)
    }

    // MARK: - AI Chat (Port 8084 / Legacy 9999)

    /// Send message to Meesuk AI Chatbot (legacy port 9999)
    func sendMessageToChatBot(_ message: String, sessionId: String) async throws -> SimpleChatResponse {
        let params: [String: Any] = ["message": message, "session_id": sessionId]
        return try await network.post(APIEndpoints.AI.chatBot, parameters: params)
    }

    // MARK: - Mood APIs (Port 8085)

    /// POST /mood/check-in — Daily check-in บันทึกลง DB
    func checkInMood(_ checkIn: MoodCheckIn) async throws -> MoodCheckInResponse {
        try await network.post(APIEndpoints.Mood.checkIn, body: checkIn)
    }

    /// GET /mood/trends — ดู mood trend
    func getMoodTrends() async throws -> MoodTrends {
        try await network.get(APIEndpoints.Mood.trends)
    }

    /// GET /mood/user/{user_id}/history — ดู mood history ของ user (สำหรับตัวเอง)
    func getMoodHistory(userId: String) async throws -> [MoodEntry] {
        try await network.get(APIEndpoints.Mood.userMoodHistory(userId: userId))
    }

    /// POST /journals — สร้าง journal entry
    func createJournal(content: String, mood: Int) async throws -> JournalEntry {
        let params: [String: Any] = ["content": content, "mood_level": mood]
        return try await network.post(APIEndpoints.Mood.journals, parameters: params)
    }

    /// GET /journals — ดู journal history
    func getJournals() async throws -> [JournalEntry] {
        try await network.get(APIEndpoints.Mood.journals)
    }

    // MARK: - Appointment APIs — Patient (Port 8086)

    /// GET /appointments — ดู appointment ของ patient
    func getAppointments() async throws -> [Appointment] {
        try await network.get(APIEndpoints.Appointment.list)
    }

    /// POST /appointments — จอง appointment
    func createAppointment(_ request: CreateAppointmentRequest) async throws -> Appointment {
        try await network.post(APIEndpoints.Appointment.create, body: request)
    }

    /// PUT /appointments/{id}/change-therapist — เปลี่ยนหมอ
    func changeTherapist(appointmentId: String, newPsychiatristId: String) async throws -> Appointment {
        let body = ChangeTherapistRequest(psychiatristId: newPsychiatristId)
        return try await network.put(APIEndpoints.Appointment.changeTherapist(id: appointmentId), body: body)
    }

    // MARK: - Appointment APIs — Psychiatrist (Port 8086)

    /// GET /appointments/psychiatrist/queue — จิตแพทย์ดูคิวที่รอรับ
    func getAppointmentQueue() async throws -> [Appointment] {
        try await network.get(APIEndpoints.Appointment.psychiatristQueue)
    }

    /// POST /appointments/{id}/accept — จิตแพทย์กดรับคิว
    func acceptAppointment(id: String) async throws -> Appointment {
        try await network.post(APIEndpoints.Appointment.accept(id: id), parameters: nil)
    }

    /// GET /appointments/psychiatrist/users/{user_id}/moods — จิตแพทย์ดู mood ของ patient
    func getPatientMoodHistory(userId: String) async throws -> [MoodEntry] {
        try await network.get(APIEndpoints.Appointment.patientMoodHistory(userId: userId))
    }

    /// POST /session-notes — จิตแพทย์เขียน session note
    func createSessionNote(appointmentId: String, note: String, isPrivate: Bool = true) async throws -> SessionNote {
        let params: [String: Any] = [
            "appointment_id": appointmentId,
            "note": note,
            "is_private": isPrivate
        ]
        return try await network.post(APIEndpoints.Appointment.sessionNotes, parameters: params)
    }

    /// GET /session-notes/my-notes — Patient ดู session notes ของตัวเอง
    func getMySessionNotes() async throws -> [SessionNote] {
        try await network.get(APIEndpoints.Appointment.mySessionNotes)
    }

    /// GET /chat/history/{user_id} — ดู chat history กับอีกคน
    func getChatHistory(withUserId userId: String) async throws -> [ChatHistoryMessage] {
        try await network.get(APIEndpoints.Appointment.chatHistoryWith(userId: userId))
    }
}

// MARK: - Request Models

struct ChangeTherapistRequest: Encodable {
    let psychiatristId: String
    enum CodingKeys: String, CodingKey {
        case psychiatristId = "psychiatrist_id"
    }
}

struct EmptyResponse: Decodable {}
