//
//  ActivitiesView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI

struct ActivitiesView: View {
    @State private var selectedCategory = "All"
    let categories = ["All", "Meditation", "Exercise", "Sleep", "Focus"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            CategoryPill(title: category, isSelected: selectedCategory == category) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.white)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ActivityGridItem(title: "Morning Calm", duration: "10 min", icon: "sun.max.fill", color: .orange)
                        ActivityGridItem(title: "Deep Sleep", duration: "45 min", icon: "moon.stars.fill", color: .indigo)
                        ActivityGridItem(title: "Box Breathing", duration: "5 min", icon: "wind", color: .cyan)
                        ActivityGridItem(title: "Stretch", duration: "15 min", icon: "figure.flexibility", color: .green)
                        ActivityGridItem(title: "Focus Music", duration: "60 min", icon: "headphones", color: .pink)
                        ActivityGridItem(title: "Gratitude", duration: "3 min", icon: "heart.text.square.fill", color: .purple)
                    }
                    .padding()
                }
                .background(Color(UIColor.systemGroupedBackground))
            }
            .navigationTitle("Activities")
        }
    }
}

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(UIColor.secondarySystemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

struct ActivityGridItem: View {
    let title: String
    let duration: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(color)
                    .clipShape(Circle())
                Spacer()
                Image(systemName: "play.circle.fill")
                    .foregroundColor(color)
                    .font(.title2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(duration)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ActivitiesView()
}
