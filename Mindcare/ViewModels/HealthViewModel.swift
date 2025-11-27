//
//  HealthViewModel.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation
import Combine

/// ViewModel สำหรับจัดการข้อมูลสุขภาพ
@MainActor
final class HealthViewModel: BaseViewModel {
    
    // MARK: - Dependencies
    private let healthKitManager = HealthKitManager.shared
    private let apiService = APIService.shared
    
    // MARK: - Published Properties
    @Published var healthMetrics: HealthMetrics?
    @Published var healthAnalysis: HealthAnalysis?
    @Published var heartRateHistory: [HealthDataPoint] = []
    @Published var stepsHistory: [HealthDataPoint] = []
    @Published var sleepData: [SleepData] = []
    
    @Published var isHealthKitAuthorized: Bool = false
    @Published var lastSyncDate: Date?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupBindings()
    }
    
    private func setupBindings() {
        healthKitManager.$isAuthorized
            .receive(on: DispatchQueue.main)
            .assign(to: &$isHealthKitAuthorized)
    }
    
    // MARK: - Authorization
    
    func requestHealthKitAuthorization() async {
        startLoading()
        
        do {
            try await healthKitManager.requestAuthorization()
            stopLoading()
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Fetch Health Data
    
    func fetchAllHealthData() async {
        startLoading()
        
        do {
            // Fetch from HealthKit
            healthMetrics = await healthKitManager.fetchAllHealthData()
            
            // Fetch history
            heartRateHistory = try await healthKitManager.fetchHeartRateHistory(days: 7)
            stepsHistory = try await healthKitManager.fetchStepsHistory(days: 7)
            sleepData = try await healthKitManager.fetchSleepData(days: 7)
            
            stopLoading()
        } catch {
            handleError(error)
        }
    }
    
    func fetchLatestHeartRate() async {
        do {
            let heartRate = try await healthKitManager.fetchLatestHeartRate()
            healthMetrics?.heartRate = heartRate
        } catch {
            logWarning("Failed to fetch heart rate: \(error.localizedDescription)", category: .healthKit)
        }
    }
    
    func fetchTodaySteps() async {
        do {
            let steps = try await healthKitManager.fetchTodaySteps()
            healthMetrics?.steps = steps
        } catch {
            logWarning("Failed to fetch steps: \(error.localizedDescription)", category: .healthKit)
        }
    }
    
    // MARK: - Sync to Backend
    
    func syncHealthData() async {
        guard let metrics = healthMetrics else {
            logWarning("No health metrics to sync", category: .healthKit)
            return
        }
        
        startLoading()
        
        do {
            let response = try await apiService.syncHealthData(metrics)
            if response.success {
                lastSyncDate = response.syncedAt
                UserDefaults.standard.set(response.syncedAt, forKey: AppConstants.UserDefaultsKeys.lastSyncDate)
            }
            stopLoading()
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Get Analysis
    
    func fetchHealthAnalysis() async {
        startLoading()
        
        do {
            healthAnalysis = try await apiService.getHealthAnalysis()
            stopLoading()
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Real-time Updates
    
    func startHeartRateMonitoring() {
        healthKitManager.startHeartRateObserver { [weak self] heartRate in
            Task { @MainActor in
                self?.healthMetrics?.heartRate = heartRate
            }
        }
    }
    
    func stopMonitoring() {
        healthKitManager.stopAllQueries()
    }
    
    // MARK: - Computed Properties
    
    var stressLevel: StressLevel {
        guard let analysis = healthAnalysis else { return .moderate }
        
        switch analysis.stressScore {
        case 0..<25: return .low
        case 25..<50: return .moderate
        case 50..<75: return .high
        default: return .veryHigh
        }
    }
    
    var sleepQualityText: String {
        guard let analysis = healthAnalysis else { return "Unknown" }
        
        switch analysis.sleepQualityScore {
        case 0..<25: return "Poor"
        case 25..<50: return "Fair"
        case 50..<75: return "Good"
        default: return "Excellent"
        }
    }
}
