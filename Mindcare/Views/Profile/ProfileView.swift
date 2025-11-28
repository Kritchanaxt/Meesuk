//
//  ProfileView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 60, height: 60)
                            .overlay(Text("K").font(.title).bold())
                        
                        VStack(alignment: .leading) {
                            Text("Kritchanat")
                                .font(.headline)
                            Text("kritchanat@example.com")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Settings") {
                    NavigationLink("Notifications") { Text("Notifications Settings") }
                    NavigationLink("Privacy") { Text("Privacy Settings") }
                    NavigationLink("Appearance") { Text("Appearance Settings") }
                }
                
                Section {
                    Button("Log Out") {
                        // Logout action
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
