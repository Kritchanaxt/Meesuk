//
//  HomeView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI

struct HomeView: View {
    @State private var showNotifications = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        HomeHeaderView()
                        
                        // Mood Check-in
                        MoodCheckInCard()
                        
                        // Quick Stats Grid
                        HealthStatsGrid()
                        
                        // Recommended Activities
                        RecommendedSection()
                        
                        Spacer(minLength: 80)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Subviews

struct HomeHeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good Morning,")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Kritchanat")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell.badge.fill")
                    .foregroundColor(.orange)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
    }
}

struct MoodCheckInCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("How are you feeling?")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundColor(.white.opacity(0.8))
            }
            
            HStack(spacing: 20) {
                ForEach(["😁", "🙂", "😐", "😔", "😣"], id: \.self) { emoji in
                    Text(emoji)
                        .font(.system(size: 32))
                        .padding(10)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(24)
        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

struct HealthStatsGrid: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Health Overview")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                StatBox(icon: "heart.fill", title: "Heart Rate", value: "72", unit: "bpm", color: .red)
                StatBox(icon: "moon.fill", title: "Sleep", value: "7h 30m", unit: "hours", color: .purple)
                StatBox(icon: "flame.fill", title: "Calories", value: "450", unit: "kcal", color: .orange)
                 StatBox(icon: "figure.walk", title: "Steps", value: "5,230", unit: "steps", color: .green)
            }
        }
    }
}

struct StatBox: View {
    let icon: String
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .padding(8)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct RecommendedSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recommended Activities")
                    .font(.headline)
                Spacer()
                Text("See All")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ActivityCard(title: "Meditation", subtitle: "10 min • Relax", image: "leaf.fill", color: .green)
                    ActivityCard(title: "Yoga", subtitle: "20 min • Flex", image: "figure.yoga", color: .orange)
                    ActivityCard(title: "Reading", subtitle: "15 min • Focus", image: "book.fill", color: .blue)
                }
            }
        }
    }
}

struct ActivityCard: View {
    let title: String
    let subtitle: String
    let image: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: image)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(color)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 100, alignment: .leading)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
}
