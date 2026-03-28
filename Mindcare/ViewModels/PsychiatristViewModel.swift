import Combine
import Foundation
import SwiftUI

class PsychiatristViewModel: ObservableObject {
    @Published var selectedProblems: Set<ProblemType> = []
    @Published var selectedIntensity: IntensityLevel?
    @Published var selectedStyles: Set<TherapyStylePreference> = []
    @Published var selectedCommunication: CommunicationPreference?
    @Published var selectedBudget: BudgetPreference?

    @Published var recommendedDoctors: [Psychiatrist] = []
    @Published var selectedDoctor: Psychiatrist?
    @Published var isMatching: Bool = false

    // Using dummy doctor list from Demo script to supply logic for UI
    private var availableDoctors: [Psychiatrist] = [
        Psychiatrist(
            id: "doc-A",
            name: "Dr. A",
            avatar: "Dr_img",
            specialization: "Psychiatrist",
            bio:
                "Dr. A is a warm and specialized psychiatrist who deeply focuses on anxiety and social stress disorders. Matched with you for an optimal text-based communication support system.",
            rating: 4.8,
            reviewCount: 100,
            yearsOfExperience: 5,
            languages: ["English", "Thai"],
            isAvailable: true,
            specialties: ["anxiety", "social_anxiety"],
            styles: ["warm", "listener"],
            intensitySupport: ["mild", "moderate"],
            communicationMethods: ["text", "video"],
            priceLevel: "low"
        ),
        Psychiatrist(
            id: "doc-B",
            name: "Dr. B",
            avatar: "Dr_img",
            specialization: "Psychologist",
            bio:
                "Dr. B is extremely experienced in managing deep burnout and depression. Known for a conversational and warm approach, she brings light to heavy situations.",
            rating: 4.5,
            reviewCount: 50,
            yearsOfExperience: 8,
            languages: ["English"],
            isAvailable: true,
            specialties: ["depression", "burnout"],
            styles: ["warm", "conversational"],
            intensitySupport: ["moderate", "high"],
            communicationMethods: ["video", "voice"],
            priceLevel: "medium"
        ),
        Psychiatrist(
            id: "doc-C",
            name: "Dr. C",
            avatar: "Dr_img",
            specialization: "Counselor",
            bio:
                "Dr. C relies on structured, practical therapy patterns to navigate grief and relationship tension.",
            rating: 4.9,
            reviewCount: 200,
            yearsOfExperience: 10,
            languages: ["English"],
            isAvailable: true,
            specialties: ["grief", "relationship"],
            styles: ["structured", "practical"],
            intensitySupport: ["mild", "moderate"],
            communicationMethods: ["text"],
            priceLevel: "high"
        ),
        Psychiatrist(
            id: "doc-D",
            name: "Dr. Sarah Jenkins",
            avatar: "Dr_img",
            specialization: "Clinical Psychiatrist",
            bio:
                "Dr. Jenkins specializes in clinical adult tele-psychiatry with a focus on holistic mental wellness and addressing trauma or high-level emotional challenges securely.",
            rating: 4.9,
            reviewCount: 200,
            yearsOfExperience: 15,
            languages: ["English", "Spanish"],
            isAvailable: true,
            specialties: ["trauma", "depression", "anxiety"],
            styles: ["structured", "listener"],
            intensitySupport: ["high", "clinical"],
            communicationMethods: ["video", "voice", "text"],
            priceLevel: "high"
        ),
    ]

    private let engine = MatchingEngine()

    // Form Helpers
    var isCurrentStepValid: Bool {
        // Implement step validation later, or keep buttons disabled
        return true
    }

    func resetForm() {
        selectedProblems.removeAll()
        selectedIntensity = nil
        selectedStyles.removeAll()
        selectedCommunication = nil
        selectedBudget = nil
        recommendedDoctors.removeAll()
        selectedDoctor = nil
    }

    func performMatch(completion: @escaping () -> Void = {}) {
        isMatching = true

        // Generate preference object
        let preference = UserPreference(
            problems: Array(selectedProblems),
            intensity: selectedIntensity ?? .moderate,
            styles: Array(selectedStyles),
            communication: selectedCommunication ?? .openToAny,
            budget: selectedBudget ?? .aiRecommend
        )

        let results = engine.match(doctors: availableDoctors, userPreference: preference)

        // Output top 3 Matches on UI
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {  // Simulate AI think time
            self.recommendedDoctors = Array(results.prefix(3)).map { $0.doctor }
            self.isMatching = false
            completion()
        }
    }
}

@MainActor
class AppointmentViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isBookingSuccessful = false
    
    func fetchAppointments() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await APIService.shared.getAppointments()
            self.appointments = fetched
        } catch {
            self.errorMessage = error.localizedDescription
            print("Failed to fetch appointments: \(error)")
        }
        isLoading = false
    }
    
    func bookAppointment(psychiatristId: String, date: Date, type: AppointmentType = .consultation) async {
        isLoading = true
        errorMessage = nil
        do {
            let request = CreateAppointmentRequest(
                psychiatristId: psychiatristId,
                scheduledAt: date,
                duration: 60,
                type: type,
                notes: "Booked via App"
            )
            let newAppointment = try await APIService.shared.createAppointment(request)
            self.appointments.append(newAppointment)
            self.isBookingSuccessful = true
        } catch {
            self.errorMessage = error.localizedDescription
            print("Failed to book appointment: \(error)")
        }
        isLoading = false
    }
}
