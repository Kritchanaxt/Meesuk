//
//  MainTabView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var authService = AuthService.shared
    @State private var selectedTab: Tab = .home
    
    enum Tab: String, CaseIterable {
        case home = "Home"
        case health = "Health"
        case chat = "Chat" // Updated icon in enum property
        case activities = "Activities"
        case profile = "Profile"
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .health: return "heart.fill"
            case .chat: return "bubble.left.and.bubble.right.fill"
            case .activities: return "leaf.fill" // Changed to leaf for wellness
            case .profile: return "person.fill"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(Tab.home.rawValue, systemImage: Tab.home.icon)
                }
                .tag(Tab.home)
            
            HealthDashboardView()
                .tabItem {
                    Label(Tab.health.rawValue, systemImage: Tab.health.icon)
                }
                .tag(Tab.health)
            
            ChatView()
                .tabItem {
                    Label(Tab.chat.rawValue, systemImage: Tab.chat.icon)
                }
                .tag(Tab.chat)
            
            ActivitiesView()
                .tabItem {
                    Label(Tab.activities.rawValue, systemImage: Tab.activities.icon)
                }
                .tag(Tab.activities)
            
            ProfileView()
                .tabItem {
                    Label(Tab.profile.rawValue, systemImage: Tab.profile.icon)
                }
                .tag(Tab.profile)
        }
        .tint(.blue)
    }
}

#Preview {
    MainTabView()
}
