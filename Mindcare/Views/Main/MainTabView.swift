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

        var icon: String {
            switch self {
            case .home: return "Home"
            case .chat: return "Chat_gray"
            case .psychiatrist: return "Psychiatrist_gray"
            case .profile: return "Profile_gray"
            }
        }

        var selectedIcon: String {
            switch self {
            case .home: return "Home"
            case .chat: return "Chat_Or"
            case .psychiatrist: return "Psychiatrist_Or"
            case .profile: return "Profile_Or"
            }
        }

        var systemIcon: String? {
            switch self {
            case .psychiatrist: return "heart"
            default: return nil
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
                            if let systemIcon = tab.systemIcon {
                                Image(
                                    systemName: selectedTab == tab
                                        ? "\(systemIcon).fill" : systemIcon
                                )
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(
                                    selectedTab == tab ? Color.mindHexColor("E67E22") : Color.gray)
                            } else {
                                Image(selectedTab == tab ? tab.selectedIcon : tab.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            }

                            Text(tab.rawValue)
                                .font(.custom("Outfit-Medium", size: 10))
                                .foregroundColor(
                                    selectedTab == tab ? Color.mindHexColor("E67E22") : Color.gray)
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
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    MainTabView()
}
