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
        case chat = "Chat"
        case psychiatrist = "Psychiatrist"
        case profile = "Profile"

        // Unused when all tabs use SF Symbols; keep if you later add asset-based icons
        var icon: String {
            switch self {
            case .home: return "house"
            case .chat: return "ellipsis.message"
            case .psychiatrist: return "heart"
            case .profile: return "person"
            }
        }

        // Name for selected state (SF Symbol names)
        var selectedIcon: String {
            switch self {
            case .home: return "house"
            case .chat: return "ellipsis.message"
            case .psychiatrist: return "heart"
            case .profile: return "person"
            }
        }

        // Use SF Symbols for all tabs
        var systemIcon: String {
            switch self {
            case .home: return "house"
            case .chat: return "ellipsis.message"
            case .psychiatrist: return "heart"
            case .profile: return "person"
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .chat:
                    ChatView()
                case .psychiatrist:
                    PsychiatristView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom Tab Bar
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Spacer()
                    Button(action: {
                        withAnimation {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image(
                                systemName: selectedTab == tab
                                    ? tab.selectedIcon
                                    : tab.systemIcon
                            )
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(
                                selectedTab == tab ? Color.mindHexColor("E67E22") : Color.gray
                            )

                            Text(tab.rawValue)
                                .font(.custom("Outfit-Medium", size: 10))
                                .foregroundColor(
                                    selectedTab == tab ? Color.mindHexColor("E67E22") : Color.gray
                                )
                        }
                    }
                    Spacer()
                }
            }
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // Ensure tab bar stays behind keyboard
    }
}

#Preview {
    MainTabView()
}
