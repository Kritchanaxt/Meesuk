//
//  HealthKitManager.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation
import HealthKit
import Combine

/// HealthKit Manager - จัดการการเชื่อมต่อและดึงข้อมูลจาก HealthKit
final class HealthKitManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = HealthKitManager()
    
    // MARK: - Properties
    private let healthStore = HKHealthStore()
    private var activeQueries: [HKQuery] = []
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isAuthorized: Bool = false
    @Published var latestHeartRate: Double?
    @Published var latestHRV: Double?
    @Published var latestOxygenSaturation: Double?
    @Published var todaySteps: Int = 0
    @Published var todayActiveEnergy: Double = 0
    @Published var restingHeartRate: Double?
    @Published var vo2Max: Double?
    @Published var sleepData: [SleepData] = []
    
    // MARK: - Health Data Types
    
    /// ประเภทข้อมูลที่ต้องการอ่าน
    private var readTypes: Set<HKObjectType> {
        let types: [HKObjectType?] = [
            HKQuantityType.quantityType(forIdentifier: .heartRate),
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN),
            HKQuantityType.quantityType(forIdentifier: .oxygenSaturation),
            HKQuantityType.quantityType(forIdentifier: .stepCount),
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned),
            HKQuantityType.quantityType(forIdentifier: .restingHeartRate),
            HKQuantityType.quantityType(forIdentifier: .vo2Max),
            HKCategoryType.categoryType(forIdentifier: .sleepAnalysis),
            HKQuantityType.workoutType()
        ]
        return Set(types.compactMap { $0 })
    }
    
    /// ประเภทข้อมูลที่ต้องการเขียน (ถ้ามี)
    private var writeTypes: Set<HKSampleType> {
        // เพิ่มตามต้องการ
        return []
    }
    
    // MARK: - Initialization
    
    private init() {
        checkAuthorizationStatus()
    }
    
    // MARK: - Authorization
    
    /// ตรวจสอบว่า HealthKit พร้อมใช้งานหรือไม่
    var isHealthDataAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    /// ตรวจสอบสถานะ Authorization
    private func checkAuthorizationStatus() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        
        let status = healthStore.authorizationStatus(for: heartRateType)
        DispatchQueue.main.async {
            self.isAuthorized = (status == .sharingAuthorized)
        }
    }
    
    /// ขอ Permission จากผู้ใช้
    func requestAuthorization() async throws {
        guard isHealthDataAvailable else {
            throw HealthKitError.notAvailable
        }
        
        try await healthStore.requestAuthorization(toShare: writeTypes, read: readTypes)
        
        await MainActor.run {
            self.isAuthorized = true
            UserDefaults.standard.set(true, forKey: AppConstants.UserDefaultsKeys.isHealthKitAuthorized)
        }
    }
    
    // MARK: - Background Delivery
    
    /// Setup Background Delivery สำหรับข้อมูลสุขภาพ
    func setupBackgroundDelivery() async {
        guard isHealthDataAvailable else { return }
        
        let typesToObserve: [HKQuantityTypeIdentifier] = [
            .heartRate,
            .heartRateVariabilitySDNN,
            .stepCount,
            .activeEnergyBurned
        ]
        
        for identifier in typesToObserve {
            guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { continue }
            
            do {
                try await healthStore.enableBackgroundDelivery(for: type, frequency: .immediate)
                print("✅ Background delivery enabled for \(identifier.rawValue)")
            } catch {
                print("❌ Failed to enable background delivery for \(identifier.rawValue): \(error)")
            }
        }
    }
    
    // MARK: - HKSampleQuery - ดึงข้อมูล Sample
    
    /// ดึงข้อมูล Heart Rate ล่าสุด
    func fetchLatestHeartRate() async throws -> Double {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            throw HealthKitError.typeNotAvailable
        }
        
        let sample = try await fetchLatestSample(for: heartRateType)
        let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
        let value = sample.quantity.doubleValue(for: heartRateUnit)
        
        await MainActor.run {
            self.latestHeartRate = value
        }
        
        return value
    }
    
    /// ดึงข้อมูล HRV ล่าสุด
    func fetchLatestHRV() async throws -> Double {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            throw HealthKitError.typeNotAvailable
        }
        
        let sample = try await fetchLatestSample(for: hrvType)
        let value = sample.quantity.doubleValue(for: .secondUnit(with: .milli))
        
        await MainActor.run {
            self.latestHRV = value
        }
        
        return value
    }
    
    /// ดึงข้อมูล Oxygen Saturation ล่าสุด
    func fetchLatestOxygenSaturation() async throws -> Double {
        guard let oxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else {
            throw HealthKitError.typeNotAvailable
        }
        
        let sample = try await fetchLatestSample(for: oxygenType)
        let value = sample.quantity.doubleValue(for: .percent()) * 100
        
        await MainActor.run {
            self.latestOxygenSaturation = value
        }
        
        return value
    }
    
    /// Generic function สำหรับดึง Sample ล่าสุด
    private func fetchLatestSample(for type: HKQuantityType) async throws -> HKQuantitySample {
        try await withCheckedThrowingContinuation { continuation in
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            let query = HKSampleQuery(
                sampleType: type,
                predicate: nil,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let sample = samples?.first as? HKQuantitySample else {
                    continuation.resume(throwing: HealthKitError.noData)
                    return
                }
                
                continuation.resume(returning: sample)
            }
            
            healthStore.execute(query)
        }
    }
    
    // MARK: - HKStatisticsQuery - ดึงข้อมูลสถิติ
    
    /// ดึงจำนวนก้าวเดินวันนี้
    func fetchTodaySteps() async throws -> Int {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw HealthKitError.typeNotAvailable
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let steps = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Int, Error>) in
            let query = HKStatisticsQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                let count = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                continuation.resume(returning: Int(count))
            }
            
            healthStore.execute(query)
        }
        
        await MainActor.run {
            self.todaySteps = steps
        }
        
        return steps
    }
    
    /// ดึง Active Energy วันนี้
    func fetchTodayActiveEnergy() async throws -> Double {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            throw HealthKitError.typeNotAvailable
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let energy = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Double, Error>) in
            let query = HKStatisticsQuery(
                quantityType: energyType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                let value = result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                continuation.resume(returning: value)
            }
            
            healthStore.execute(query)
        }
        
        await MainActor.run {
            self.todayActiveEnergy = energy
        }
        
        return energy
    }
    
    // MARK: - HKStatisticsCollectionQuery - ดึงข้อมูลหลายวัน
    
    /// ดึงข้อมูล Heart Rate ย้อนหลัง 7 วัน
    func fetchHeartRateHistory(days: Int = 7) async throws -> [HealthDataPoint] {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            throw HealthKitError.typeNotAvailable
        }
        
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: now)!
        let anchorDate = Calendar.current.startOfDay(for: now)
        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsCollectionQuery(
                quantityType: heartRateType,
                quantitySamplePredicate: predicate,
                options: .discreteAverage,
                anchorDate: anchorDate,
                intervalComponents: daily
            )
            
            query.initialResultsHandler = { _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                var dataPoints: [HealthDataPoint] = []
                
                results?.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                    let unit = HKUnit.count().unitDivided(by: .minute())
                    if let average = statistics.averageQuantity()?.doubleValue(for: unit) {
                        dataPoints.append(HealthDataPoint(
                            date: statistics.startDate,
                            value: average,
                            type: .heartRate
                        ))
                    }
                }
                
                continuation.resume(returning: dataPoints)
            }
            
            healthStore.execute(query)
        }
    }
    
    /// ดึงข้อมูลก้าวเดินย้อนหลัง
    func fetchStepsHistory(days: Int = 7) async throws -> [HealthDataPoint] {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw HealthKitError.typeNotAvailable
        }
        
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: now)!
        let anchorDate = Calendar.current.startOfDay(for: now)
        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsCollectionQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: anchorDate,
                intervalComponents: daily
            )
            
            query.initialResultsHandler = { _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                var dataPoints: [HealthDataPoint] = []
                
                results?.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                    if let sum = statistics.sumQuantity()?.doubleValue(for: .count()) {
                        dataPoints.append(HealthDataPoint(
                            date: statistics.startDate,
                            value: sum,
                            type: .steps
                        ))
                    }
                }
                
                continuation.resume(returning: dataPoints)
            }
            
            healthStore.execute(query)
        }
    }
    
    // MARK: - HKAnchoredObjectQuery - ดึงข้อมูลแบบ Incremental
    
    /// เริ่ม Observer สำหรับ Heart Rate แบบ Real-time
    func startHeartRateObserver(handler: @escaping (Double) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        
        let query = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] _, samples, _, _, error in
            guard error == nil else { return }
            self?.processHeartRateSamples(samples, handler: handler)
        }
        
        query.updateHandler = { [weak self] _, samples, _, _, error in
            guard error == nil else { return }
            self?.processHeartRateSamples(samples, handler: handler)
        }
        
        activeQueries.append(query)
        healthStore.execute(query)
    }
    
    private func processHeartRateSamples(_ samples: [HKSample]?, handler: (Double) -> Void) {
        guard let samples = samples as? [HKQuantitySample], let latest = samples.last else { return }
        
        let unit = HKUnit.count().unitDivided(by: .minute())
        let value = latest.quantity.doubleValue(for: unit)
        
        DispatchQueue.main.async {
            self.latestHeartRate = value
        }
        
        handler(value)
    }
    
    // MARK: - HKObserverQuery - สำหรับ Background Updates
    
    /// เริ่ม Observer Query สำหรับการเปลี่ยนแปลงข้อมูล
    func startObserverQuery(for identifier: HKQuantityTypeIdentifier, handler: @escaping () -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
        
        let query = HKObserverQuery(sampleType: type, predicate: nil) { _, completionHandler, error in
            if error == nil {
                handler()
            }
            completionHandler()
        }
        
        activeQueries.append(query)
        healthStore.execute(query)
    }
    
    // MARK: - Sleep Analysis
    
    /// ดึงข้อมูลการนอน
    func fetchSleepData(days: Int = 7) async throws -> [SleepData] {
        guard let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else {
            throw HealthKitError.typeNotAvailable
        }
        
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: now)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: sleepType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let samples = samples as? [HKCategorySample] else {
                    continuation.resume(returning: [])
                    return
                }
                
                let sleepData = samples.compactMap { sample -> SleepData? in
                    let sleepStage: SleepStage
                    
                    if #available(iOS 16.0, *) {
                        switch sample.value {
                        case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                            sleepStage = .core
                        case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                            sleepStage = .deep
                        case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                            sleepStage = .rem
                        case HKCategoryValueSleepAnalysis.awake.rawValue:
                            sleepStage = .awake
                        default:
                            sleepStage = .unknown
                        }
                    } else {
                        sleepStage = sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue ? .asleep : .awake
                    }
                    
                    return SleepData(
                        startDate: sample.startDate,
                        endDate: sample.endDate,
                        stage: sleepStage
                    )
                }
                
                continuation.resume(returning: sleepData)
            }
            
            healthStore.execute(query)
        }
    }
    
    // MARK: - Resting Heart Rate & VO2 Max
    
    /// ดึง Resting Heart Rate
    func fetchRestingHeartRate() async throws -> Double {
        guard let type = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) else {
            throw HealthKitError.typeNotAvailable
        }
        
        let sample = try await fetchLatestSample(for: type)
        let unit = HKUnit.count().unitDivided(by: .minute())
        let value = sample.quantity.doubleValue(for: unit)
        
        await MainActor.run {
            self.restingHeartRate = value
        }
        
        return value
    }
    
    /// ดึง VO2 Max
    func fetchVO2Max() async throws -> Double {
        guard let type = HKQuantityType.quantityType(forIdentifier: .vo2Max) else {
            throw HealthKitError.typeNotAvailable
        }
        
        let sample = try await fetchLatestSample(for: type)
        let unit = HKUnit(from: "ml/kg*min")
        let value = sample.quantity.doubleValue(for: unit)
        
        await MainActor.run {
            self.vo2Max = value
        }
        
        return value
    }
    
    // MARK: - Fetch All Health Data
    
    /// ดึงข้อมูลสุขภาพทั้งหมดสำหรับส่งไป Backend
    func fetchAllHealthData() async -> HealthMetrics {
        var metrics = HealthMetrics()
        
        // Fetch all data concurrently
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                metrics.heartRate = try? await self.fetchLatestHeartRate()
            }
            group.addTask {
                metrics.hrv = try? await self.fetchLatestHRV()
            }
            group.addTask {
                metrics.oxygenSaturation = try? await self.fetchLatestOxygenSaturation()
            }
            group.addTask {
                metrics.steps = try? await self.fetchTodaySteps()
            }
            group.addTask {
                metrics.activeEnergy = try? await self.fetchTodayActiveEnergy()
            }
            group.addTask {
                metrics.restingHeartRate = try? await self.fetchRestingHeartRate()
            }
            group.addTask {
                metrics.vo2Max = try? await self.fetchVO2Max()
            }
        }
        
        metrics.timestamp = Date()
        return metrics
    }
    
    // MARK: - Cleanup
    
    /// หยุด Query ทั้งหมด
    func stopAllQueries() {
        activeQueries.forEach { healthStore.stop($0) }
        activeQueries.removeAll()
    }
    
    deinit {
        stopAllQueries()
    }
}

// MARK: - HealthKit Errors

enum HealthKitError: LocalizedError {
    case notAvailable
    case notAuthorized
    case typeNotAvailable
    case noData
    case queryFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "HealthKit is not available on this device"
        case .notAuthorized:
            return "HealthKit authorization was denied"
        case .typeNotAvailable:
            return "The requested health data type is not available"
        case .noData:
            return "No health data found"
        case .queryFailed(let error):
            return "Query failed: \(error.localizedDescription)"
        }
    }
}
