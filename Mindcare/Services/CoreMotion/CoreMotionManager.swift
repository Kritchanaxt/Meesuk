//
//  CoreMotionManager.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation
import CoreMotion
import Combine

/// CoreMotion Manager - จัดการข้อมูลจาก Motion Sensors
final class CoreMotionManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = CoreMotionManager()
    
    // MARK: - Properties
    private let pedometer = CMPedometer()
    private let motionManager = CMMotionManager()
    private let activityManager = CMMotionActivityManager()
    
    @Published var todaySteps: Int = 0
    @Published var todayDistance: Double = 0 // meters
    @Published var todayFloors: Int = 0
    @Published var currentActivity: ActivityType = .unknown
    @Published var isStepCountingAvailable: Bool = false
    @Published var isActivityAvailable: Bool = false
    
    // MARK: - Activity Type
    enum ActivityType: String {
        case stationary = "stationary"
        case walking = "walking"
        case running = "running"
        case cycling = "cycling"
        case automotive = "automotive"
        case unknown = "unknown"
        
        var icon: String {
            switch self {
            case .stationary: return "figure.stand"
            case .walking: return "figure.walk"
            case .running: return "figure.run"
            case .cycling: return "bicycle"
            case .automotive: return "car.fill"
            case .unknown: return "questionmark"
            }
        }
    }
    
    // MARK: - Initialization
    
    private init() {
        checkAvailability()
    }
    
    private func checkAvailability() {
        isStepCountingAvailable = CMPedometer.isStepCountingAvailable()
        isActivityAvailable = CMMotionActivityManager.isActivityAvailable()
    }
    
    // MARK: - Pedometer
    
    /// เริ่มนับก้าวเดินวันนี้
    func startPedometerUpdates() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("❌ Step counting is not available")
            return
        }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        
        pedometer.startUpdates(from: startOfDay) { [weak self] data, error in
            guard let data = data, error == nil else {
                print("❌ Pedometer error: \(error?.localizedDescription ?? "Unknown")")
                return
            }
            
            DispatchQueue.main.async {
                self?.todaySteps = data.numberOfSteps.intValue
                self?.todayDistance = data.distance?.doubleValue ?? 0
                self?.todayFloors = data.floorsAscended?.intValue ?? 0
            }
        }
    }
    
    /// หยุดนับก้าว
    func stopPedometerUpdates() {
        pedometer.stopUpdates()
    }
    
    /// ดึงจำนวนก้าวเดินในช่วงเวลาที่กำหนด
    func queryPedometerData(from startDate: Date, to endDate: Date = Date()) async throws -> CMPedometerData {
        try await withCheckedThrowingContinuation { continuation in
            pedometer.queryPedometerData(from: startDate, to: endDate) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let data = data else {
                    continuation.resume(throwing: CoreMotionError.noData)
                    return
                }
                
                continuation.resume(returning: data)
            }
        }
    }
    
    /// ดึงข้อมูลก้าวเดิน 7 วันล่าสุด
    func fetchWeeklySteps() async throws -> [DailySteps] {
        var weeklyData: [DailySteps] = []
        let calendar = Calendar.current
        
        for dayOffset in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date())!
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            do {
                let data = try await queryPedometerData(from: startOfDay, to: endOfDay)
                weeklyData.append(DailySteps(
                    date: startOfDay,
                    steps: data.numberOfSteps.intValue,
                    distance: data.distance?.doubleValue ?? 0,
                    floors: data.floorsAscended?.intValue ?? 0
                ))
            } catch {
                // Add empty data for this day
                weeklyData.append(DailySteps(
                    date: startOfDay,
                    steps: 0,
                    distance: 0,
                    floors: 0
                ))
            }
        }
        
        return weeklyData.reversed() // Oldest first
    }
    
    // MARK: - Motion Activity
    
    /// เริ่มติดตาม Activity
    func startActivityUpdates() {
        guard CMMotionActivityManager.isActivityAvailable() else {
            print("❌ Activity tracking is not available")
            return
        }
        
        activityManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let strongSelf = self, let activity = activity else { return }
            strongSelf.currentActivity = strongSelf.mapActivity(activity)
        }
    }
    
    /// หยุดติดตาม Activity
    func stopActivityUpdates() {
        activityManager.stopActivityUpdates()
    }
    
    private func mapActivity(_ activity: CMMotionActivity) -> ActivityType {
        if activity.stationary {
            return .stationary
        } else if activity.running {
            return .running
        } else if activity.walking {
            return .walking
        } else if activity.cycling {
            return .cycling
        } else if activity.automotive {
            return .automotive
        } else {
            return .unknown
        }
    }
    
    /// ดึงประวัติ Activity
    func queryActivityHistory(from startDate: Date, to endDate: Date = Date()) async throws -> [CMMotionActivity] {
        try await withCheckedThrowingContinuation { continuation in
            activityManager.queryActivityStarting(from: startDate, to: endDate, to: .main) { activities, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                continuation.resume(returning: activities ?? [])
            }
        }
    }
    
    // MARK: - Device Motion
    
    /// เริ่มติดตาม Device Motion (accelerometer, gyroscope)
    func startDeviceMotionUpdates(interval: TimeInterval = 0.1) {
        guard motionManager.isDeviceMotionAvailable else {
            print("❌ Device motion is not available")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = interval
        motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
            guard let motion = motion, error == nil else { return }
            
            // Process motion data if needed
            _ = motion.attitude
            _ = motion.gravity
            _ = motion.userAcceleration
        }
    }
    
    /// หยุดติดตาม Device Motion
    func stopDeviceMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    // MARK: - Accelerometer
    
    /// เริ่มติดตาม Accelerometer
    func startAccelerometerUpdates(interval: TimeInterval = 0.1, handler: @escaping (CMAccelerometerData) -> Void) {
        guard motionManager.isAccelerometerAvailable else {
            print("❌ Accelerometer is not available")
            return
        }
        
        motionManager.accelerometerUpdateInterval = interval
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let data = data, error == nil else { return }
            handler(data)
        }
    }
    
    /// หยุดติดตาม Accelerometer
    func stopAccelerometerUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
    
    // MARK: - Gyroscope
    
    /// เริ่มติดตาม Gyroscope
    func startGyroscopeUpdates(interval: TimeInterval = 0.1, handler: @escaping (CMGyroData) -> Void) {
        guard motionManager.isGyroAvailable else {
            print("❌ Gyroscope is not available")
            return
        }
        
        motionManager.gyroUpdateInterval = interval
        motionManager.startGyroUpdates(to: .main) { data, error in
            guard let data = data, error == nil else { return }
            handler(data)
        }
    }
    
    /// หยุดติดตาม Gyroscope
    func stopGyroscopeUpdates() {
        motionManager.stopGyroUpdates()
    }
    
    // MARK: - Cleanup
    
    /// หยุด Updates ทั้งหมด
    func stopAllUpdates() {
        stopPedometerUpdates()
        stopActivityUpdates()
        stopDeviceMotionUpdates()
        stopAccelerometerUpdates()
        stopGyroscopeUpdates()
    }
    
    deinit {
        stopAllUpdates()
    }
}

// MARK: - Daily Steps Model

struct DailySteps: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
    let distance: Double // meters
    let floors: Int
    
    var distanceInKm: Double {
        distance / 1000.0
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

// MARK: - CoreMotion Errors

enum CoreMotionError: LocalizedError {
    case notAvailable
    case noData
    case permissionDenied
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "Motion data is not available on this device"
        case .noData:
            return "No motion data found"
        case .permissionDenied:
            return "Motion permission was denied"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
