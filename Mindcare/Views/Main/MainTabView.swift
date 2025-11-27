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
        case chat = "Chat"
        case activities = "Activities"
        case profile = "Profile"
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .health: return "heart.fill"
            case .chat: return "bubble.left.and.bubble.right.fill"
            case .activities: return "figure.walk"
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
        .tint(.accentColor)
    }
}

// MARK: - Placeholder Views

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Card
                    WelcomeCard()
                    
                    // Quick Stats
                    QuickStatsView()
                    
                    // Today's Mood
                    TodayMoodCard()
                    
                    // Recommended Activities
                    RecommendedActivitiesCard()
                }
                .padding()
            }
            .navigationTitle("MindCare")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Notifications
                    } label: {
                        Image(systemName: "bell.fill")
                    }
                }
            }
        }
    }
}

struct WelcomeCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Good Morning! 👋")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("How are you feeling today?")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.accentColor.opacity(0.1))
        .cornerRadius(16)
    }
}

struct QuickStatsView: View {
    var body: some View {
        HStack(spacing: 12) {
            StatCard(title: "Heart Rate", value: "72", unit: "BPM", icon: "heart.fill", color: .red)
            StatCard(title: "Steps", value: "5,432", unit: "steps", icon: "figure.walk", color: .green)
            StatCard(title: "Sleep", value: "7.5", unit: "hours", icon: "bed.double.fill", color: .purple)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(unit)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct TodayMoodCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Mood")
                    .font(.headline)
                Spacer()
                Button("Check-in") {
                    // Open mood check-in
                }
                .font(.subheadline)
            }
            
            HStack(spacing: 16) {
                ForEach(["😄", "🙂", "😐", "😔", "😢"], id: \.self) { emoji in
                    Text(emoji)
                        .font(.largeTitle)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct RecommendedActivitiesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recommended for You")
                .font(.headline)
            
            VStack(spacing: 8) {
                ActivityRow(title: "5-min Breathing", subtitle: "Reduce stress", icon: "wind", color: .cyan)
                ActivityRow(title: "Take a Walk", subtitle: "Get moving", icon: "figure.walk", color: .green)
                ActivityRow(title: "Journal Entry", subtitle: "Express yourself", icon: "book.fill", color: .orange)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct ActivityRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct HealthDashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Health Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Coming soon...")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("Health")
        }
    }
}

struct ChatView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("AI Chat")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Coming soon...")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Chat")
        }
    }
}

struct ActivitiesView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Activities")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Coming soon...")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Activities")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Coming soon...")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    MainTabView()
}
