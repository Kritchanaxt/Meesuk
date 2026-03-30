import Combine
import Foundation
import SwiftUI

@MainActor
class PsychiatristDashboardViewModel: ObservableObject {

    // MARK: - Published
    @Published var queueAppointments: [Appointment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var selectedPatientUserId: String?
    @Published var patientMoodHistory: [MoodEntry] = []
    @Published var isLoadingMoodHistory = false

    // MARK: - Load Appointment Queue

    func loadQueue() async {
        isLoading = true
        errorMessage = nil
        
        // 100% Mock Flow - Removed API call
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        self.queueAppointments = [
            Appointment(
                id: "q-1",
                patientId: "patient-101",
                psychiatristId: "doc-julian",
                psychiatristName: "Dr. Julian Vance",
                patientName: "John Doe",
                scheduledAt: Date().addingTimeInterval(3600),
                duration: 60,
                type: .consultation,
                status: .scheduled,
                notes: "Feeling anxious about work",
                meetingUrl: nil,
                createdAt: Date()
            ),
            Appointment(
                id: "q-2",
                patientId: "patient-102",
                psychiatristId: "doc-julian",
                psychiatristName: "Dr. Julian Vance",
                patientName: "Jane Smith",
                scheduledAt: Date().addingTimeInterval(7200),
                duration: 60,
                type: .followUp,
                status: .confirmed,
                notes: "Regular follow-up",
                meetingUrl: nil,
                createdAt: Date()
            )
        ]
        
        isLoading = false
    }

    // MARK: - Accept Appointment (กดรับคิว)

    func acceptAppointment(id: String) async {
        isLoading = true
        errorMessage = nil
        
        // 100% Mock Flow - Removed API call
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        if let index = queueAppointments.firstIndex(where: { $0.id == id }) {
            queueAppointments[index].status = .confirmed
            successMessage = "รับคิวสำเร็จ ✅"
        }
        
        isLoading = false
    }

    // MARK: - Load Patient Mood History (7 วัน)

    func loadPatientMoodHistory(userId: String) async {
        isLoadingMoodHistory = true
        selectedPatientUserId = userId
        
        // 100% Mock Flow - Removed API call
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Mock mood entries for the last 5 days
        let today = Date()
        self.patientMoodHistory = [
            MoodEntry(id: "m1", userId: userId, moodLevel: 4, emotions: [Emotion.happy], activities: ["Exercise"], notes: "Had a great day at the park", sleepQuality: 4, energyLevel: 4, stressLevel: 2, createdAt: today),
            MoodEntry(id: "m2", userId: userId, moodLevel: 2, emotions: [Emotion.stressed], activities: ["Work"], notes: "Heavy workload", sleepQuality: 3, energyLevel: 2, stressLevel: 5, createdAt: today.addingTimeInterval(-86400)),
            MoodEntry(id: "m3", userId: userId, moodLevel: 3, emotions: [Emotion.calm], activities: ["Reading"], notes: "Regular day", sleepQuality: 4, energyLevel: 3, stressLevel: 3, createdAt: today.addingTimeInterval(-172800)),
            MoodEntry(id: "m4", userId: userId, moodLevel: 5, emotions: [Emotion.happy, Emotion.excited], activities: ["Celebration"], notes: "Got a promotion!", sleepQuality: 5, energyLevel: 5, stressLevel: 1, createdAt: today.addingTimeInterval(-259200)),
            MoodEntry(id: "m5", userId: userId, moodLevel: 1, emotions: [Emotion.sad, Emotion.lonely], activities: ["Rest"], notes: "Missing family", sleepQuality: 2, energyLevel: 1, stressLevel: 4, createdAt: today.addingTimeInterval(-345600))
        ]
        
        isLoadingMoodHistory = false
    }

    // MARK: - Helpers

    var pendingQueue: [Appointment] {
        queueAppointments.filter { $0.status == .scheduled }
    }

    var confirmedToday: [Appointment] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        return queueAppointments.filter {
            $0.scheduledAt >= today && $0.scheduledAt < tomorrow && $0.status == .confirmed
        }
    }
}
