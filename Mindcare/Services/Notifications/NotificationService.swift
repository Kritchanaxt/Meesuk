//
//  NotificationService.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation
import UserNotifications
import Combine

/// Notification Service - จัดการ Local & Push Notifications
final class NotificationService: NSObject, ObservableObject {
    
    // MARK: - Singleton
    static let shared = NotificationService()
    
    // MARK: - Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    
    @Published var isAuthorized: Bool = false
    @Published var pendingNotifications: [UNNotificationRequest] = []
    
    // MARK: - Notification Categories
    enum Category: String {
        case healthAlert = "HEALTH_ALERT"
        case reminder = "REMINDER"
        case chat = "CHAT"
        case appointment = "APPOINTMENT"
        case dailyCheckIn = "DAILY_CHECK_IN"
    }
    
    // MARK: - Notification Actions
    enum Action: String {
        case view = "VIEW_ACTION"
        case dismiss = "DISMISS_ACTION"
        case respond = "RESPOND_ACTION"
        case snooze = "SNOOZE_ACTION"
    }
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
        setupCategories()
    }
    
    // MARK: - Authorization
    
    /// ขอ Permission สำหรับ Notifications
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound, .provisional]
        
        notificationCenter.requestAuthorization(options: options) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
            }
            
            if let error = error {
                print("❌ Notification authorization error: \(error)")
            }
            
            completion(granted)
        }
    }
    
    /// ตรวจสอบสถานะ Authorization
    func checkAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await notificationCenter.notificationSettings()
        
        await MainActor.run {
            self.isAuthorized = settings.authorizationStatus == .authorized
        }
        
        return settings.authorizationStatus
    }
    
    // MARK: - Setup Categories
    
    private func setupCategories() {
        // Health Alert Category
        let viewAction = UNNotificationAction(
            identifier: Action.view.rawValue,
            title: "View",
            options: .foreground
        )
        
        let dismissAction = UNNotificationAction(
            identifier: Action.dismiss.rawValue,
            title: "Dismiss",
            options: .destructive
        )
        
        let healthCategory = UNNotificationCategory(
            identifier: Category.healthAlert.rawValue,
            actions: [viewAction, dismissAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        // Reminder Category
        let snoozeAction = UNNotificationAction(
            identifier: Action.snooze.rawValue,
            title: "Snooze (15 min)",
            options: []
        )
        
        let reminderCategory = UNNotificationCategory(
            identifier: Category.reminder.rawValue,
            actions: [viewAction, snoozeAction, dismissAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Chat Category with Text Input
        let respondAction = UNTextInputNotificationAction(
            identifier: Action.respond.rawValue,
            title: "Reply",
            options: [],
            textInputButtonTitle: "Send",
            textInputPlaceholder: "Type your message..."
        )
        
        let chatCategory = UNNotificationCategory(
            identifier: Category.chat.rawValue,
            actions: [respondAction, viewAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Daily Check-in Category
        let checkInCategory = UNNotificationCategory(
            identifier: Category.dailyCheckIn.rawValue,
            actions: [viewAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Register Categories
        notificationCenter.setNotificationCategories([
            healthCategory,
            reminderCategory,
            chatCategory,
            checkInCategory
        ])
    }
    
    // MARK: - Schedule Notifications
    
    /// Schedule Local Notification
    func scheduleNotification(
        id: String = UUID().uuidString,
        title: String,
        body: String,
        subtitle: String? = nil,
        category: Category? = nil,
        userInfo: [String: Any] = [:],
        trigger: UNNotificationTrigger,
        sound: UNNotificationSound = .default,
        badge: NSNumber? = nil
    ) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        
        if let category = category {
            content.categoryIdentifier = category.rawValue
        }
        
        if let badge = badge {
            content.badge = badge
        }
        
        content.userInfo = userInfo
        
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        
        try await notificationCenter.add(request)
        await refreshPendingNotifications()
    }
    
    /// Schedule Time Interval Notification
    func scheduleNotification(
        id: String = UUID().uuidString,
        title: String,
        body: String,
        category: Category? = nil,
        timeInterval: TimeInterval,
        repeats: Bool = false
    ) async throws {
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: repeats
        )
        
        try await scheduleNotification(
            id: id,
            title: title,
            body: body,
            category: category,
            trigger: trigger
        )
    }
    
    /// Schedule Calendar Notification
    func scheduleNotification(
        id: String = UUID().uuidString,
        title: String,
        body: String,
        category: Category? = nil,
        dateComponents: DateComponents,
        repeats: Bool = false
    ) async throws {
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: repeats
        )
        
        try await scheduleNotification(
            id: id,
            title: title,
            body: body,
            category: category,
            trigger: trigger
        )
    }
    
    /// Schedule Daily Check-in Notification
    func scheduleDailyCheckIn(hour: Int = 20, minute: Int = 0) async throws {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        try await scheduleNotification(
            id: "daily_check_in",
            title: "How are you feeling today?",
            body: "Take a moment to check in with yourself",
            category: .dailyCheckIn,
            dateComponents: dateComponents,
            repeats: true
        )
    }
    
    // MARK: - Health Alert Notifications
    
    /// ส่ง Health Alert Notification
    func sendHealthAlert(
        title: String,
        body: String,
        severity: HealthAlertSeverity,
        healthData: [String: Any] = [:]
    ) async throws {
        var userInfo = healthData
        userInfo["severity"] = severity.rawValue
        userInfo["alertType"] = "health"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        try await scheduleNotification(
            id: "health_alert_\(UUID().uuidString)",
            title: title,
            body: body,
            category: .healthAlert,
            userInfo: userInfo,
            trigger: trigger,
            sound: severity == .critical ? .defaultCritical : .default
        )
    }
    
    // MARK: - Manage Notifications
    
    /// รีเฟรชรายการ Pending Notifications
    func refreshPendingNotifications() async {
        let requests = await notificationCenter.pendingNotificationRequests()
        
        await MainActor.run {
            self.pendingNotifications = requests
        }
    }
    
    /// ยกเลิก Notification ด้วย ID
    func cancelNotification(id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
        Task {
            await refreshPendingNotifications()
        }
    }
    
    /// ยกเลิก Notifications หลายอัน
    func cancelNotifications(ids: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
        Task {
            await refreshPendingNotifications()
        }
    }
    
    /// ยกเลิก Notifications ทั้งหมด
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
        
        Task {
            await refreshPendingNotifications()
        }
    }
    
    /// Clear Badge Count
    func clearBadge() {
        #if os(iOS)
        Task { @MainActor in
            UNUserNotificationCenter.current().setBadgeCount(0)
        }
        #endif
    }
    
    /// Set Badge Count
    func setBadge(count: Int) {
        #if os(iOS)
        Task { @MainActor in
            try? await UNUserNotificationCenter.current().setBadgeCount(count)
        }
        #endif
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
    
    // เมื่อ Notification แสดงขณะ App อยู่ Foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // แสดง Notification แม้ App อยู่ Foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    // เมื่อผู้ใช้ Tap หรือ Interact กับ Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let categoryIdentifier = response.notification.request.content.categoryIdentifier
        
        switch response.actionIdentifier {
        case Action.view.rawValue:
            handleViewAction(userInfo: userInfo, category: categoryIdentifier)
            
        case Action.dismiss.rawValue:
            // Dismissed
            break
            
        case Action.snooze.rawValue:
            handleSnoozeAction(notification: response.notification)
            
        case Action.respond.rawValue:
            if let textResponse = response as? UNTextInputNotificationResponse {
                handleTextResponse(text: textResponse.userText, userInfo: userInfo)
            }
            
        case UNNotificationDefaultActionIdentifier:
            // User tapped notification
            handleNotificationTap(userInfo: userInfo, category: categoryIdentifier)
            
        default:
            break
        }
        
        completionHandler()
    }
    
    // MARK: - Action Handlers
    
    private func handleViewAction(userInfo: [AnyHashable: Any], category: String) {
        // Navigate to relevant screen
        NotificationCenter.default.post(
            name: Notification.Name("NotificationViewAction"),
            object: nil,
            userInfo: userInfo as? [String: Any]
        )
    }
    
    private func handleSnoozeAction(notification: UNNotification) {
        // Reschedule notification for 15 minutes later
        Task {
            try? await scheduleNotification(
                id: notification.request.identifier + "_snoozed",
                title: notification.request.content.title,
                body: notification.request.content.body,
                timeInterval: 15 * 60,
                repeats: false
            )
        }
    }
    
    private func handleTextResponse(text: String, userInfo: [AnyHashable: Any]) {
        // Handle text input response (e.g., send chat message)
        print("User responded with: \(text)")
    }
    
    private func handleNotificationTap(userInfo: [AnyHashable: Any], category: String) {
        // Handle tap based on category
        NotificationCenter.default.post(
            name: Notification.Name("NotificationTapped"),
            object: nil,
            userInfo: ["category": category, "data": userInfo]
        )
    }
}

// MARK: - Health Alert Severity

enum HealthAlertSeverity: String {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
}
