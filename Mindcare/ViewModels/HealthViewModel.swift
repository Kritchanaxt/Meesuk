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
    private let watchConnectivityManager = WatchConnectivityManager.shared
    private let apiService = APIService.shared
    
    // MARK: - Published Properties
    @Published var healthMetrics: HealthMetrics?
    @Published var healthAnalysis: HealthAnalysis?
    @Published var heartRateHistory: [HealthDataPoint] = []
    @Published var stepsHistory: [HealthDataPoint] = []
    @Published var sleepData: [SleepData] = []
    
    @Published var isHealthKitAuthorized: Bool = false
    @Published var lastSyncDate: Date?
    
    // Watch Connectivity Properties
    @Published var isWatchPaired: Bool = false
    @Published var isWatchReachable: Bool = false
    @Published var isWatchAppInstalled: Bool = false
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupBindings()
        
        // Start watch session
        watchConnectivityManager.startSession()
        
        // Initial fetch
        Task {
            await fetchAllHealthData()
            startHeartRateMonitoring()
        }
    }
    
    private func setupBindings() {
        healthKitManager.$isAuthorized
            .receive(on: DispatchQueue.main)
            .assign(to: &$isHealthKitAuthorized)
            
        // Watch connectivity bindings
        watchConnectivityManager.$isPaired
            .receive(on: DispatchQueue.main)
            .assign(to: &$isWatchPaired)
            
        watchConnectivityManager.$isReachable
            .receive(on: DispatchQueue.main)
            .assign(to: &$isWatchReachable)
            
        watchConnectivityManager.$isWatchAppInstalled
            .receive(on: DispatchQueue.main)
            .assign(to: &$isWatchAppInstalled)
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
        print("🔍 Starting to fetch all health data from HealthKit...")
        startLoading()
        
        do {
            // Fetch from HealthKit
            healthMetrics = await healthKitManager.fetchAllHealthData()
            print("📊 Health metrics fetched: \(healthMetrics != nil ? "Success" : "Empty")")
            
            // Fetch history
            heartRateHistory = try await healthKitManager.fetchHeartRateHistory(days: 7)
            stepsHistory = try await healthKitManager.fetchStepsHistory(days: 7)
            sleepData = try await healthKitManager.fetchSleepData(days: 7)
            print("📈 History fetched: HR (\(heartRateHistory.count)), Steps (\(stepsHistory.count)), Sleep (\(sleepData.count))")
            
            stopLoading()
        } catch {
            print("❌ Failed to fetch health data: \(error.localizedDescription)")
            handleError(error)
        }
    }
    
    func fetchLatestHeartRate() async {
        do {
            let heartRate = try await healthKitManager.fetchLatestHeartRate()
            print("💓 Latest Heart Rate: \(heartRate) BPM")
            if healthMetrics == nil {
                healthMetrics = HealthMetrics()
            }
            healthMetrics?.heartRate = heartRate
        } catch {
            print("⚠️ Failed to fetch heart rate: \(error.localizedDescription)")
            logWarning("Failed to fetch heart rate: \(error.localizedDescription)", category: .healthKit)
        }
    }
    
    func fetchTodaySteps() async {
        do {
            let steps = try await healthKitManager.fetchTodaySteps()
            if healthMetrics == nil {
                healthMetrics = HealthMetrics()
            }
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
    
    private var heartRateTimer: Timer?
    
    func startHeartRateMonitoring() {
        // Observer for immediate HealthKit updates
        healthKitManager.startHeartRateObserver { [weak self] heartRate in
            Task { @MainActor in
                if self?.healthMetrics == nil {
                    self?.healthMetrics = HealthMetrics()
                }
                self?.healthMetrics?.heartRate = heartRate
                print("💓 [Observer] Heart Rate updated: \(heartRate) BPM")
            }
        }
        
        // Polling every 1 second for real-time BPM
        heartRateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.fetchLatestHeartRate()
            }
        }
        print("⏱️ Heart rate polling timer started (every 1s - real-time)")
    }
    
    func stopMonitoring() {
        healthKitManager.stopAllQueries()
        heartRateTimer?.invalidate()
        heartRateTimer = nil
        print("⏹️ Heart rate monitoring stopped")
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
