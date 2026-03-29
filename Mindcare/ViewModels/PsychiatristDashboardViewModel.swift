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
        do {
            let queue = try await APIService.shared.getAppointmentQueue()
            self.queueAppointments = queue
        } catch {
            self.errorMessage = "ไม่สามารถโหลดคิวได้: \(error.localizedDescription)"
            print("❌ Queue error: \(error)")
        }
        isLoading = false
    }

    // MARK: - Accept Appointment (กดรับคิว)

    func acceptAppointment(id: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let updated = try await APIService.shared.acceptAppointment(id: id)
            // Remove from queue or update status locally
            if let index = queueAppointments.firstIndex(where: { $0.id == updated.id }) {
                queueAppointments[index] = updated
            }
            successMessage = "รับคิวสำเร็จ ✅"
        } catch {
            self.errorMessage = "ไม่สามารถรับคิวได้: \(error.localizedDescription)"
        }
        isLoading = false
    }

    // MARK: - Load Patient Mood History (7 วัน)

    func loadPatientMoodHistory(userId: String) async {
        isLoadingMoodHistory = true
        selectedPatientUserId = userId
        do {
            let history = try await APIService.shared.getPatientMoodHistory(userId: userId)
            self.patientMoodHistory = history
        } catch {
            print("❌ Mood history error: \(error)")
            self.patientMoodHistory = []
        }
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
