//
//  Logger.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation
import os.log

/// Custom Logger สำหรับ MindCare App
final class Logger {
    
    // MARK: - Singleton
    static let shared = Logger()
    
    // MARK: - Log Categories
    private let generalLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.mindcare", category: "General")
    private let networkLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.mindcare", category: "Network")
    private let healthKitLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.mindcare", category: "HealthKit")
    private let authLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.mindcare", category: "Auth")
    private let uiLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.mindcare", category: "UI")
    
    private init() {}
    
    // MARK: - Log Levels
    enum LogLevel: String {
        case debug = "🔍 DEBUG"
        case info = "ℹ️ INFO"
        case warning = "⚠️ WARNING"
        case error = "❌ ERROR"
        case critical = "🔴 CRITICAL"
    }
    
    enum LogCategory {
        case general
        case network
        case healthKit
        case auth
        case ui
    }
    
    // MARK: - Logging Methods
    
    func debug(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, category: category, file: file, function: function, line: line)
    }
    
    func info(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, category: category, file: file, function: function, line: line)
    }
    
    func warning(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, category: category, file: file, function: function, line: line)
    }
    
    func error(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, category: category, file: file, function: function, line: line)
    }
    
    func critical(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .critical, category: category, file: file, function: function, line: line)
    }
    
    // MARK: - Private
    
    private func log(_ message: String, level: LogLevel, category: LogCategory, file: String, function: String, line: Int) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "\(level.rawValue) [\(fileName):\(line)] \(function) - \(message)"
        
        let osLog = getOSLog(for: category)
        let osLogType = getOSLogType(for: level)
        
        os_log("%{public}@", log: osLog, type: osLogType, logMessage)
        print(logMessage)
        #endif
    }
    
    private func getOSLog(for category: LogCategory) -> OSLog {
        switch category {
        case .general: return generalLog
        case .network: return networkLog
        case .healthKit: return healthKitLog
        case .auth: return authLog
        case .ui: return uiLog
        }
    }
    
    private func getOSLogType(for level: LogLevel) -> OSLogType {
        switch level {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        case .critical: return .fault
        }
    }
}

// MARK: - Global Convenience Functions

func logDebug(_ message: String, category: Logger.LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.shared.debug(message, category: category, file: file, function: function, line: line)
}

func logInfo(_ message: String, category: Logger.LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.shared.info(message, category: category, file: file, function: function, line: line)
}

func logWarning(_ message: String, category: Logger.LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.shared.warning(message, category: category, file: file, function: function, line: line)
}

func logError(_ message: String, category: Logger.LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.shared.error(message, category: category, file: file, function: function, line: line)
}
