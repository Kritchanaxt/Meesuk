//
//  ContentView.swift
//  Mindcare
//
//  Created by Mr.Kritchant on 27/11/2568 BE.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @StateObject private var authService = AuthService.shared
    @State private var appState: AppState = .welcome
    @AppStorage("hasSeenJourney") private var hasSeenJourney: Bool = false

    enum AppState {
        case welcome
        case journey
        case role
        case auth
        case main
    }

    var body: some View {
        ZStack {
            switch appState {
            case .welcome:
                WelcomeView {
                    withAnimation {
                        appState = .journey
                    }
                }

            case .journey:
                JourneyView {
                    withAnimation {
                        appState = .role
                    }
                }

            case .role:
                RolePageView { role in
                    withAnimation {
                        appState = .auth
                    }
                }

            case .auth:
                if authService.isAuthenticated {
                    MainTabView()
                        .onAppear { appState = .main }
                } else {
                    LoginPageView()
                }

            case .main:
                if authService.isAuthenticated {
                    MainTabView()
                } else {
                    LoginPageView()
                        .onAppear { appState = .auth }
                }
            }
        }
        .transition(.opacity)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
