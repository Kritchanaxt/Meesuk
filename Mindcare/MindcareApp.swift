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
            RootView()
                .environmentObject(authService)
                .environmentObject(healthKitManager)
        }
        .modelContainer(sharedModelContainer)
    }
}

// MARK: - Root View

struct RootView: View {
    @EnvironmentObject var authService: AuthService
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false
    
    var body: some View {
        Group {
            if !isOnboardingCompleted {
                OnboardingView(onComplete: {
                    isOnboardingCompleted = true
                })
            } else if authService.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: authService.isAuthenticated)
        .animation(.easeInOut, value: isOnboardingCompleted)
    }
}

// MARK: - Onboarding View

struct OnboardingView: View {
    var onComplete: () -> Void
    
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            // Page 1: Welcome
            OnboardingPage(
                image: "brain.head.profile",
                title: "Welcome to MindCare",
                description: "Your personal mental health companion. Track your mood, monitor your health, and get personalized support.",
                color: .purple
            )
            .tag(0)
            
            // Page 2: Health Tracking
            OnboardingPage(
                image: "heart.text.square.fill",
                title: "Health Insights",
                description: "Connect your Apple Watch to track heart rate, sleep, and activity for personalized health insights.",
                color: .red
            )
            .tag(1)
            
            // Page 3: AI Support
            OnboardingPage(
                image: "bubble.left.and.bubble.right.fill",
                title: "AI-Powered Support",
                description: "Chat with our AI assistant anytime, anywhere. Get helpful suggestions and coping strategies.",
                color: .blue
            )
            .tag(2)
            
            // Page 4: Get Started
            VStack(spacing: 32) {
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.green)
                
                Text("You're All Set!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Let's start your journey to better mental health.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    onComplete()
                } label: {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
            .tag(3)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OnboardingPage: View {
    let image: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: image)
                .font(.system(size: 100))
                .foregroundColor(color)
                .symbolRenderingMode(.hierarchical)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(description)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            Spacer()
        }
    }
}
