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
        case health = "Health"
        case chat = "Chat"
        case activities = "Activities"
        case profile = "Profile"
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .health: return "heart.fill"
            case .chat: return "bubble.left.and.bubble.right.fill"
            case .activities: return "figure.walk"
            case .profile: return "person.fill"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(Tab.home.rawValue, systemImage: Tab.home.icon)
                }
                .tag(Tab.home)
            
            HealthDashboardView()
                .tabItem {
                    Label(Tab.health.rawValue, systemImage: Tab.health.icon)
                }
                .tag(Tab.health)
            
            ChatView()
                .tabItem {
                    Label(Tab.chat.rawValue, systemImage: Tab.chat.icon)
                }
                .tag(Tab.chat)
            
            ActivitiesView()
                .tabItem {
                    Label(Tab.activities.rawValue, systemImage: Tab.activities.icon)
                }
                .tag(Tab.activities)
            
            ProfileView()
                .tabItem {
                    Label(Tab.profile.rawValue, systemImage: Tab.profile.icon)
                }
                .tag(Tab.profile)
        }
        .tint(.accentColor)
    }
}

// MARK: - Placeholder Views

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Card
                    WelcomeCard()
                    
                    // Quick Stats
                    QuickStatsView()
                    
                    // Today's Mood
                    TodayMoodCard()
                    
                    // Recommended Activities
                    RecommendedActivitiesCard()
                }
                .padding()
            }
            .navigationTitle("MindCare")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Notifications
                    } label: {
                        Image(systemName: "bell.fill")
                    }
                }
            }
        }
    }
}

struct WelcomeCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Good Morning! 👋")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("How are you feeling today?")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.accentColor.opacity(0.1))
        .cornerRadius(16)
    }
}

struct QuickStatsView: View {
    var body: some View {
        HStack(spacing: 12) {
            StatCard(title: "Heart Rate", value: "72", unit: "BPM", icon: "heart.fill", color: .red)
            StatCard(title: "Steps", value: "5,432", unit: "steps", icon: "figure.walk", color: .green)
            StatCard(title: "Sleep", value: "7.5", unit: "hours", icon: "bed.double.fill", color: .purple)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(unit)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct TodayMoodCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Mood")
                    .font(.headline)
                Spacer()
                Button("Check-in") {
                    // Open mood check-in
                }
                .font(.subheadline)
            }
            
            HStack(spacing: 16) {
                ForEach(["😄", "🙂", "😐", "😔", "😢"], id: \.self) { emoji in
                    Text(emoji)
                        .font(.largeTitle)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct RecommendedActivitiesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recommended for You")
                .font(.headline)
            
            VStack(spacing: 8) {
                ActivityRow(title: "5-min Breathing", subtitle: "Reduce stress", icon: "wind", color: .cyan)
                ActivityRow(title: "Take a Walk", subtitle: "Get moving", icon: "figure.walk", color: .green)
                ActivityRow(title: "Journal Entry", subtitle: "Express yourself", icon: "book.fill", color: .orange)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct ActivityRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                SwiftUIView()
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct HealthDashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Health Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Coming soon...")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("Health")
        }
    }
}

struct ChatView: View {
    @State private var messages: [ChatBubble] = [
        .init(text: "Hi, I'm MindCare AI. How can I support you today?", role: .assistant, tone: "Calm"),
        .init(text: "I’ve been feeling a bit anxious lately and sleeping less.", role: .user, tone: "User"),
        .init(text: "Thanks for sharing. On a scale of 1-5, how intense is your anxiety right now?", role: .assistant, tone: "Coaching")
    ]
    @State private var input: String = ""
    @State private var isTyping = false
    @State private var suggestedPrompts = [
        "Guide me through 3-minute breathing",
        "Reflect on today’s mood",
        "Plan a gentle routine"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.15), Color.indigo.opacity(0.1), Color.cyan.opacity(0.08)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 12) {
                    header
                    quickActions
                    chatStream
                    inputBar
                }
                .padding()
            }
            .navigationTitle("AI Chat")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle().fill(Color.blue.opacity(0.15)).frame(width: 56, height: 56)
                Image(systemName: "sparkles")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("MindCare AI")
                    .font(.headline.weight(.semibold))
                Text("Empathetic • Secure • 24/7")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                Circle().fill(Color.green).frame(width: 8, height: 8)
                Text("Online")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.green)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.green.opacity(0.12))
            .clipShape(Capsule())
        }
    }
    
    private var quickActions: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(suggestedPrompts, id: \.self) { prompt in
                    Button {
                        send(prompt)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkle.magnifyingglass")
                            Text(prompt)
                                .font(.subheadline.weight(.medium))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var chatStream: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { bubble in
                        ChatBubbleView(bubble: bubble)
                            .id(bubble.id)
                    }
                    
                    if isTyping {
                        HStack {
                            TypingIndicator()
                            Spacer()
                        }
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                    }
                }
                .padding(.vertical, 6)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.white.opacity(0.2))
                    )
            )
            .onChange(of: messages.count) { _ in
                if let last = messages.last {
                    withAnimation(.easeOut(duration: 0.3)) {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    private var inputBar: some View {
        VStack(spacing: 10) {
            Divider().opacity(0.4)
            HStack(spacing: 12) {
                Button {
                    send("How can mindfulness help me right now?")
                } label: {
                    Image(systemName: "lightbulb.max.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.orange)
                }
                
                TextField("Share how you're feeling…", text: $input, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...3)
                
                Button(action: sendCurrentMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 42, height: 42)
                        .background(input.isEmpty ? Color.gray.opacity(0.6) : Color.blue)
                        .clipShape(Circle())
                }
                .disabled(input.isEmpty)
            }
        }
    }
    
    private func sendCurrentMessage() {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        send(trimmed)
        input = ""
    }
    
    private func send(_ text: String) {
        withAnimation {
            messages.append(.init(text: text, role: .user, tone: "You"))
            isTyping = true
        }
        
        // Mock AI reply
        Task {
            try await Task.sleep(nanoseconds: 600_000_000)
            let reply = "I hear you. Let's take a slow breath together. Inhale for 4, hold for 4, exhale for 6. Ready?"
            await MainActor.run {
                withAnimation {
                    messages.append(.init(text: reply, role: .assistant, tone: "MindCare AI"))
                    isTyping = false
                }
            }
        }
    }
}

// MARK: - Models & Subviews

private struct ChatBubble: Identifiable {
    let id = UUID()
    let text: String
    let role: Role
    let tone: String
    
    enum Role {
        case user
        case assistant
    }
}

private struct ChatBubbleView: View {
    let bubble: ChatBubble
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if bubble.role == .assistant { avatar }
            
            VStack(alignment: bubble.role == .user ? .trailing : .leading, spacing: 6) {
                Text(bubble.tone)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                
                Text(bubble.text)
                    .font(.body)
                    .foregroundColor(bubble.role == .user ? .white : .primary)
                    .padding(14)
                    .background(
                        AnyShapeStyle(
                            bubble.role == .user
                            ? AnyShapeStyle(LinearGradient(colors: [.blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                            : AnyShapeStyle(Color.white.opacity(0.9))
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(bubble.role == .user ? Color.white.opacity(0.2) : Color.black.opacity(0.05))
                    )
            }
            if bubble.role == .user { avatar }
        }
        .frame(maxWidth: .infinity, alignment: bubble.role == .user ? .trailing : .leading)
    }
    
    private var avatar: some View {
        ZStack {
            Circle()
                .fill(bubble.role == .user ? Color.blue.opacity(0.2) : Color.white)
                .frame(width: 36, height: 36)
            Image(systemName: bubble.role == .user ? "person.fill" : "sparkles")
                .foregroundStyle(bubble.role == .user ? Color.blue : Color.indigo)
                .font(.subheadline.weight(.bold))
        }
    }
}

private struct TypingIndicator: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.indigo)
                    .frame(width: 8, height: 8)
                    .opacity(0.6)
                    .offset(y: bobbingOffset(for: index))
                    .animation(
                        .easeInOut(duration: 0.8)
                        .repeatForever()
                        .delay(Double(index) * 0.12),
                        value: phase
                    )
            }
        }
        .onAppear {
            phase = 1
        }
    }
    
    private func bobbingOffset(for index: Int) -> CGFloat {
        sin(phase + CGFloat(index)) * 3
    }
}

struct ActivitiesView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Activities")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Coming soon...")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Activities")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Coming soon...")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    MainTabView()
}
