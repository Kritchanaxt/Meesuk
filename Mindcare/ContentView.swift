//
//  ContentView.swift
//  Mindcare
//
//  Created by Mr.Kritchant on 27/11/2568 BE.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var authService = AuthService.shared
    @State private var appState: AppState = .welcome
    @AppStorage("hasSeenJourney") private var hasSeenJourney: Bool = false
    
    enum AppState {
        case welcome
        case journey
        case main
    }
    
    var body: some View {
        ZStack {
            switch appState {
            case .welcome:
                WelcomeView {
                    // Transition to Journey or Main based on logic
                    if !hasSeenJourney {
                        withAnimation {
                            appState = .journey
                        }
                    } else {
                        withAnimation {
                            appState = .main
                        }
                    }
                }
                
            case .journey:
                JourneyView {
                    // Mark journey as seen and go to main
                    hasSeenJourney = true
                    withAnimation {
                        appState = .main
                    }
                }
                
            case .main:
                Group {
                    if authService.isAuthenticated {
                        MainTabView()
                    } else {
                        
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
