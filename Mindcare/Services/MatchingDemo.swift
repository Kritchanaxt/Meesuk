import Foundation

// MARK: - Mock Test script

struct MatchingDemo {

    static func runDemo() {
        let engine = MatchingEngine()

        let doctors: [Psychiatrist] = [
            // Dr A: Matches Anxiety, Warm, Text, Low well
            Psychiatrist(
                id: "doc-A",
                name: "Dr. A",
                avatar: nil,
                specialization: "Psychiatrist",
                bio: nil,
                rating: 4.8,
                reviewCount: 100,
                yearsOfExperience: 5,
                languages: ["English"],
                isAvailable: true,
                specialties: ["anxiety", "social_anxiety"],
                styles: ["warm", "listener"],
                intensitySupport: ["mild", "moderate"],
                communicationMethods: ["text", "video"],
                priceLevel: "low"
            ),
            // Dr B: Matches some but not all
            Psychiatrist(
                id: "doc-B",
                name: "Dr. B",
                avatar: nil,
                specialization: "Psychologist",
                bio: nil,
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
            // Dr C: Matches less
            Psychiatrist(
                id: "doc-C",
                name: "Dr. C",
                avatar: nil,
                specialization: "Counselor",
                bio: nil,
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
            // Dr D: Clinical level
            Psychiatrist(
                id: "doc-D",
                name: "Dr. D",
                avatar: nil,
                specialization: "Clinical Psychiatrist",
                bio: nil,
                rating: 4.9,
                reviewCount: 200,
                yearsOfExperience: 15,
                languages: ["English"],
                isAvailable: true,
                specialties: ["trauma", "depression", "anxiety"],
                styles: ["structured", "listener"],
                intensitySupport: ["high", "clinical"],
                communicationMethods: ["video", "voice", "text"],
                priceLevel: "high"
            ),
        ]

        // Example Case
        // User เลือก
        // Problem: Anxiety
        // Intensity: Moderate
        // Style: Warm
        // Communication: Text
        // Budget: Low

        let exampleUser = UserPreference(
            problems: [.anxiety],
            intensity: .moderate,
            styles: [.warmSupportive],
            communication: .textChat,
            budget: .low
        )

        print("--- Standard Match Demo ---")
        let results = engine.match(doctors: doctors, userPreference: exampleUser)
        for (index, match) in results.enumerated() {
            print("\(index + 1). \(match.doctor.name) (score \(match.score))")
        }

        // Red Flag Case
        // Very High, Trauma
        let redFlagUser = UserPreference(
            problems: [.trauma],
            intensity: .veryHigh,
            styles: [.notSure],
            communication: .openToAny,
            budget: .aiRecommend
        )

        print("\n--- Red Flag Match Demo ---")
        let rfResults = engine.match(doctors: doctors, userPreference: redFlagUser)
        for (index, match) in rfResults.enumerated() {
            print("\(index + 1). \(match.doctor.name) (score \(match.score))")
        }
    }
}
