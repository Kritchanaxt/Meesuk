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
    // Using dummy doctor list for 100% Mock Demo
    private var availableDoctors: [Psychiatrist] = [
        Psychiatrist(
            id: "doc-julian",
            name: "Dr. Julian Vance",
            avatar: "Dr_img",
            specialization: "Clinical Psychiatrist",
            bio: "Dr. Julian Vance is a highly experienced psychiatrist specializing in cognitive behavioral therapy and anxiety management. He focuses on creating a safe, empathetic space for patients to explore their feelings and develop practical coping strategies.",
            rating: 4.9,
            reviewCount: 342,
            yearsOfExperience: 12,
            languages: ["English", "Thai"],
            isAvailable: true,
            specialties: ["Anxiety", "Depression", "CBT"],
            styles: ["Empathetic", "Structured", "Listener"],
            intensitySupport: ["Moderate", "High"],
            communicationMethods: ["Video", "Voice", "Text"],
            priceLevel: "Medium"
        ),
        Psychiatrist(
            id: "doc-sarah",
            name: "Dr. Sarah Jenkins",
            avatar: "Dr_img",
            specialization: "Psychotherapist",
            bio: "Specializes in clinical adult tele-psychiatry with a focus on holistic mental wellness and addressing trauma or high-level emotional challenges securely.",
            rating: 4.8,
            reviewCount: 215,
            yearsOfExperience: 15,
            languages: ["English"],
            isAvailable: true,
            specialties: ["Trauma", "Burnout"],
            styles: ["Practical", "Conversational"],
            intensitySupport: ["High"],
            communicationMethods: ["Video", "Text"],
            priceLevel: "High"
        )
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

        Task { @MainActor in
            // 100% Mock Flow - Removed API call
            let doctors = availableDoctors

            let preference = UserPreference(
                problems: Array(selectedProblems),
                intensity: selectedIntensity ?? .moderate,
                styles: Array(selectedStyles),
                communication: selectedCommunication ?? .openToAny,
                budget: selectedBudget ?? .aiRecommend
            )

            let results = engine.match(doctors: doctors, userPreference: preference)

            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 sec simulate AI
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
        
        // 100% Mock Flow - Simulating delay without API call
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Initialize with one mock appointment if empty
        if self.appointments.isEmpty {
            self.appointments = [
                Appointment(
                    id: "mock-appt-1",
                    patientId: "demo-patient",
                    psychiatristId: "doc-julian",
                    psychiatristName: "Dr. Julian Vance",
                    patientName: "Demo User",
                    scheduledAt: Date().addingTimeInterval(86400),
                    duration: 60,
                    type: .consultation,
                    status: .scheduled,
                    notes: "Introductory session",
                    meetingUrl: nil,
                    createdAt: Date()
                )
            ]
        }
        
        isLoading = false
    }
    
    func bookAppointment(psychiatristId: String, date: Date, type: AppointmentType = .consultation) async {
        isLoading = true
        errorMessage = nil
        
        // 100% Mock Flow - Simulating success without API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let newAppointment = Appointment(
            id: "mock-appt-\(UUID().uuidString.prefix(6))",
            patientId: "demo-patient",
            psychiatristId: psychiatristId,
            psychiatristName: "Dr. Julian Vance",
            patientName: "Demo User",
            scheduledAt: date,
            duration: 60,
            type: type,
            status: .scheduled,
            notes: "Booked via App (Mock)",
            meetingUrl: nil,
            createdAt: Date()
        )
        
        self.appointments.append(newAppointment)
        self.isBookingSuccessful = true
        isLoading = false
    }
}
