//
//  AppEnvironment.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation

/// App Environment Configuration
enum AppEnvironment {
    case development
    case staging
    case production
    
    static var current: AppEnvironment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
    
    var baseURL: String {
        switch self {
        case .development:
            return "http://localhost:8080/api/v1"
        case .staging:
            return "https://staging-api.mindcare.app/api/v1"
        case .production:
            return "https://api.mindcare.app/api/v1"
        }
    }
    
    var isDebug: Bool {
        switch self {
        case .development, .staging:
            return true
        case .production:
            return false
        }
    }
}

/// App Constants
enum AppConstants {
    static let appName = "MindCare"
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    // Keychain Keys
    enum Keychain {
        static let accessToken = "com.mindcare.accessToken"
        static let refreshToken = "com.mindcare.refreshToken"
        static let userID = "com.mindcare.userID"
    }
    
    // UserDefaults Keys
    enum UserDefaultsKeys {
        static let isOnboardingCompleted = "isOnboardingCompleted"
        static let isHealthKitAuthorized = "isHealthKitAuthorized"
        static let lastSyncDate = "lastSyncDate"
        static let userRole = "userRole"
    }
    
    // Notification Names
    enum NotificationNames {
        static let healthDataUpdated = Notification.Name("healthDataUpdated")
        static let userDidLogin = Notification.Name("userDidLogin")
        static let userDidLogout = Notification.Name("userDidLogout")
    }
    
    // Health Data Sync Interval (in seconds)
    static let healthSyncInterval: TimeInterval = 3600 // 1 hour
    
    // API Timeouts
    static let requestTimeout: TimeInterval = 30
    static let resourceTimeout: TimeInterval = 60
}
