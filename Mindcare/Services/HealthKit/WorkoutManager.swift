//
//  WorkoutManager.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation
import HealthKit
import Combine

/// Workout Manager - จัดการ Workout Sessions (สำหรับ Apple Watch)
final class WorkoutManager: NSObject, ObservableObject {
    
    // MARK: - Singleton
    static let shared = WorkoutManager()
    
    // MARK: - Properties
    private let healthStore = HKHealthStore()
    
    #if os(watchOS)
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    #endif
    
    @Published var isWorkoutActive: Bool = false
    @Published var currentHeartRate: Double = 0
    @Published var activeCalories: Double = 0
    @Published var elapsedTime: TimeInterval = 0
    @Published var workoutDistance: Double = 0
    
    // MARK: - Workout Configuration
    
    /// สร้าง Workout Configuration
    func createWorkoutConfiguration(activityType: HKWorkoutActivityType = .mindAndBody,
                                    locationType: HKWorkoutSessionLocationType = .indoor) -> HKWorkoutConfiguration {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = activityType
        configuration.locationType = locationType
        return configuration
    }
    
    #if os(watchOS)
    // MARK: - Start Workout (watchOS only)
    
    /// เริ่ม Workout Session
    func startWorkout(configuration: HKWorkoutConfiguration) async throws {
        // Create session
        session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
        builder = session?.associatedWorkoutBuilder()
        
        // Setup builder
        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: configuration
        )
        
        // Set delegates
        session?.delegate = self
        builder?.delegate = self
        
        // Start session and builder
        let startDate = Date()
        session?.startActivity(with: startDate)
        try await builder?.beginCollection(at: startDate)
        
        await MainActor.run {
            self.isWorkoutActive = true
        }
    }
    
    /// หยุด Workout Session
    func endWorkout() async throws {
        guard let session = session, let builder = builder else { return }
        
        session.end()
        try await builder.endCollection(at: Date())
        
        // Save workout
        try await builder.finishWorkout()
        
        await MainActor.run {
            self.isWorkoutActive = false
            self.resetWorkoutData()
        }
    }
    
    /// Pause Workout
    func pauseWorkout() {
        session?.pause()
    }
    
    /// Resume Workout
    func resumeWorkout() {
        session?.resume()
    }
    
    #endif
    
    // MARK: - Fetch Workouts
    
    /// ดึงประวัติ Workout
    func fetchWorkouts(days: Int = 30) async throws -> [HKWorkout] {
        let workoutType = HKWorkoutType.workoutType()
        
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: now)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: workoutType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                let workouts = samples as? [HKWorkout] ?? []
                continuation.resume(returning: workouts)
            }
            
            healthStore.execute(query)
        }
    }
    
    // MARK: - Helper Methods
    
    private func resetWorkoutData() {
        currentHeartRate = 0
        activeCalories = 0
        elapsedTime = 0
        workoutDistance = 0
    }
}

#if os(watchOS)
// MARK: - HKWorkoutSessionDelegate

extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date) {
        DispatchQueue.main.async {
            switch toState {
            case .running:
                self.isWorkoutActive = true
            case .paused:
                self.isWorkoutActive = false
            case .ended:
                self.isWorkoutActive = false
            default:
                break
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didFailWithError error: Error) {
        print("Workout session failed: \(error)")
    }
}

// MARK: - HKLiveWorkoutBuilderDelegate

extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder,
                        didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { continue }
            
            guard let statistics = workoutBuilder.statistics(for: quantityType) else { continue }
            
            DispatchQueue.main.async {
                switch quantityType {
                case HKQuantityType.quantityType(forIdentifier: .heartRate):
                    let unit = HKUnit.count().unitDivided(by: .minute())
                    self.currentHeartRate = statistics.mostRecentQuantity()?.doubleValue(for: unit) ?? 0
                    
                case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                    self.activeCalories = statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                    
                case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                    self.workoutDistance = statistics.sumQuantity()?.doubleValue(for: .meter()) ?? 0
                    
                default:
                    break
                }
            }
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Handle workout events
    }
}
#endif
