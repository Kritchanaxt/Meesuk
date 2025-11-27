//
//  AppDelegate.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import UIKit
import UserNotifications
import HealthKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Setup Notifications
        setupNotifications()
        
        // Setup HealthKit Background Delivery
        setupHealthKitBackgroundDelivery()
        
        return true
    }
    
    private func setupNotifications() {
        UNUserNotificationCenter.current().delegate = NotificationService.shared
        NotificationService.shared.requestAuthorization { granted in
            print("Notification permission granted: \(granted)")
        }
    }
    
    private func setupHealthKitBackgroundDelivery() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        Task {
            await HealthKitManager.shared.setupBackgroundDelivery()
        }
    }
    
    // MARK: - Remote Notifications
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
        // Send token to your backend
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
}
