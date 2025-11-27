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
    
    var body: some View {
        Group {
            if authService.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: authService.isAuthenticated)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
