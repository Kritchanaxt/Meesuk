//
//  MindcareApp.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI
import SwiftData

@main
struct MindcareApp: App {
    
    // MARK: - App Delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // MARK: - State Objects
    @StateObject private var authService = AuthService.shared
    @StateObject private var healthKitManager = HealthKitManager.shared
    
    // MARK: - App State
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false
    @AppStorage("isHealthKitAuthorized") private var isHealthKitAuthorized = false
    
    // MARK: - SwiftData Model Container
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
                .environmentObject(healthKitManager)
        }
        .modelContainer(sharedModelContainer)
    }
}

