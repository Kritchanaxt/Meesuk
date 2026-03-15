//
//  MatchingEngine.swift
//  Mindcare
//

import Foundation

class MatchingEngine {

    // Weights for scoring
    private let specialtyWeight = 40
    private let intensityWeight = 20
    private let styleWeight = 20
    private let communicationWeight = 10
    private let budgetWeight = 10

    /// Calculate the matching score between a doctor and user preferences
    func calculateScore(doctor: Psychiatrist, user: UserPreference) -> Int {
        var score = 0

        // 1. Specialty Mapping (Problem Type)
        if let doctorSpecialties = doctor.specialties {
            let requiredSpecs = user.requiredSpecialties
            let matches = doctorSpecialties.filter { requiredSpecs.contains($0) }

            if !matches.isEmpty {
                score += specialtyWeight
                // Bonus 5 points for each additional matched specialty
                if matches.count > 1 {
                    score += (matches.count - 1) * 5
                }
            }
        }

        // 2. Intensity Support Mapping
        if let doctorIntensity = doctor.intensitySupport {
            let requiredIntensity = user.requiredIntensitySupport
            if doctorIntensity.contains(requiredIntensity) {
                score += intensityWeight
            }
        }

        // 3. Therapy Style Mapping
        if let doctorStyles = doctor.styles {
            let preferredStyles = user.preferredStyles
            if !doctorStyles.filter({ preferredStyles.contains($0) }).isEmpty {
                score += styleWeight
            }
        }

        // 4. Communication Method Mapping
        if let userComm = user.preferredCommunication {
            if let doctorComms = doctor.communicationMethods, doctorComms.contains(userComm) {
                score += communicationWeight
            }
        } else {
            // "Open to Any" gets points automatically
            score += communicationWeight
        }

        // 5. Budget Level Mapping
        if let userBudget = user.preferredPriceLevel {
            if doctor.priceLevel == userBudget {
                score += budgetWeight
            }
        } else {
            // "AI Recommend" gets points automatically
            score += budgetWeight
        }

        return score
    }

    /// Red Flag Logic: Force clinical/psychiatrist level for high severity cases
    func isRedFlag(user: UserPreference) -> Bool {
        let hasSevereProblems =
            user.problems.contains(.trauma) || user.problems.contains(.depression)
        let isHighIntensity = user.intensity == .veryHigh
        return hasSevereProblems && isHighIntensity
    }

    /// Main matching function to get the top 3 recommended doctors
    func match(doctors: [Psychiatrist], userPreference: UserPreference, limit: Int = 3) -> [(
        doctor: Psychiatrist, score: Int
    )] {
        let isRedFlagCase = isRedFlag(user: userPreference)

        var validDoctors = doctors

        // Apply Red Flag filtering if necessary
        if isRedFlagCase {
            // Only keep doctors who can handle "clinical" intensity
            validDoctors = validDoctors.filter { doc in
                return doc.intensitySupport?.contains("clinical") == true
            }
        }

        // Calculate scores for all valid doctors
        let scoredDoctors: [(Psychiatrist, Int)] = validDoctors.compactMap { doctor in
            let score = calculateScore(doctor: doctor, user: userPreference)
            // Optional minimum threshold for matching could be added here
            return (doctor, score)
        }

        // Sort descending by score
        let sortedDoctors = scoredDoctors.sorted { $0.1 > $1.1 }

        // Return top N
        return Array(sortedDoctors.prefix(limit))
    }
}
