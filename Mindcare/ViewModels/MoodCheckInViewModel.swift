import Combine
import Foundation
import SwiftUI

@MainActor
class MoodCheckInViewModel: ObservableObject {
    @Published var selectedMoodLevel: Int = 3       // 1-5
    @Published var selectedEmotions: Set<Emotion> = []
    @Published var notes: String = ""
    @Published var sleepQuality: Int = 3
    @Published var stressLevel: Int = 3
    @Published var energyLevel: Int = 3

    @Published var isLoading = false
    @Published var isSuccess = false
    @Published var errorMessage: String?
    @Published var lastResponse: MoodCheckInResponse?

    func submitCheckIn() async {
        isLoading = true
        errorMessage = nil
        isSuccess = false

        let checkIn = MoodCheckIn(
            moodLevel: selectedMoodLevel,
            emotions: Array(selectedEmotions),
            activities: nil,
            notes: notes.isEmpty ? nil : notes,
            sleepQuality: sleepQuality,
            energyLevel: energyLevel,
            stressLevel: stressLevel
        )

        do {
            let response = try await APIService.shared.checkInMood(checkIn)
            self.lastResponse = response
            self.isSuccess = true
            print("✅ Mood check-in saved: \(response.id)")
        } catch {
            self.errorMessage = "บันทึกไม่สำเร็จ: \(error.localizedDescription)"
            print("❌ Mood check-in failed: \(error)")
        }

        isLoading = false
    }

    func reset() {
        selectedMoodLevel = 3
        selectedEmotions = []
        notes = ""
        sleepQuality = 3
        stressLevel = 3
        energyLevel = 3
        isSuccess = false
        errorMessage = nil
        lastResponse = nil
    }

    var moodEmoji: String {
        switch selectedMoodLevel {
        case 1: return "😢"
        case 2: return "😔"
        case 3: return "😐"
        case 4: return "🙂"
        case 5: return "😄"
        default: return "😐"
        }
    }

    var moodLabel: String {
        switch selectedMoodLevel {
        case 1: return "แย่มาก"
        case 2: return "แย่"
        case 3: return "พอใช้"
        case 4: return "ดี"
        case 5: return "ดีมาก"
        default: return "พอใช้"
        }
    }
}
