//
//  HealthDashboardView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI

struct HealthDashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Weekly Summary Chart Placeholder
                    WeeklySummaryCard()
                    
                    // Detailed Metrics
                    VStack(spacing: 16) {
                        MetricRow(title: "Heart Rate", value: "72 bpm", icon: "heart.fill", color: .red, detail: "Normal Range")
                        MetricRow(title: "Steps", value: "6,540", icon: "figure.walk", color: .green, detail: "Goal: 10,000")
                        MetricRow(title: "Sleep Analysis", value: "7h 12m", icon: "bed.double.fill", color: .purple, detail: "Deep Sleep: 2h")
                        MetricRow(title: "Blood Oxygen", value: "98%", icon: "lungs.fill", color: .blue, detail: "Average")
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Health")
        }
    }
}

struct WeeklySummaryCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Activity")
                .font(.headline)
            
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(0..<7) { day in
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 4)
                            .fill(day == 4 ? Color.blue : Color.blue.opacity(0.3))
                            .frame(height: CGFloat.random(in: 30...100))
                        Text(["M", "T", "W", "T", "F", "S", "S"][day])
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 150)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct MetricRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let detail: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(color)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                Text(detail)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 1)
    }
}

#Preview {
    HealthDashboardView()
}
