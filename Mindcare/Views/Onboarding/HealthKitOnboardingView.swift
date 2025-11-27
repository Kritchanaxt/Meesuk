//
//  HealthKitOnboardingView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI
import HealthKit

struct HealthKitOnboardingView: View {
    @StateObject private var healthKitManager = HealthKitManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var isRequestingPermission = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 80))
                .foregroundColor(.red)
                .symbolRenderingMode(.hierarchical)
            
            // Title
            VStack(spacing: 8) {
                Text("Connect Health Data")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("MindCare uses your health data to provide personalized insights and recommendations.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            // Features List
            VStack(alignment: .leading, spacing: 16) {
                HealthFeatureRow(icon: "heart.fill", color: .red, title: "Heart Rate", description: "Monitor your heart rate patterns")
                HealthFeatureRow(icon: "waveform.path.ecg", color: .green, title: "Heart Rate Variability", description: "Track stress and recovery")
                HealthFeatureRow(icon: "bed.double.fill", color: .purple, title: "Sleep Analysis", description: "Understand your sleep quality")
                HealthFeatureRow(icon: "figure.walk", color: .orange, title: "Activity", description: "Track your daily movement")
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
            .padding(.horizontal)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 12) {
                Button {
                    requestHealthKitAccess()
                } label: {
                    HStack {
                        if isRequestingPermission {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                        Text(isRequestingPermission ? "Requesting Access..." : "Allow Access")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(isRequestingPermission)
                
                Button("Skip for Now") {
                    onComplete()
                }
                .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
    
    private func requestHealthKitAccess() {
        guard healthKitManager.isHealthDataAvailable else {
            errorMessage = "Health data is not available on this device."
            showError = true
            return
        }
        
        isRequestingPermission = true
        
        Task {
            do {
                try await healthKitManager.requestAuthorization()
                await MainActor.run {
                    isRequestingPermission = false
                    onComplete()
                }
            } catch {
                await MainActor.run {
                    isRequestingPermission = false
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

struct HealthFeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    HealthKitOnboardingView {
        print("Completed")
    }
}
