//
//  HomeView.swift
//  Mindcare
//
//  Redesigned with premium UI, charts, and real-time watch data
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel = HealthViewModel()
    
    var body: some View {
        ZStack {
            Color.mindHexColor("FFF8E7")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HomeHeaderView()
                    DailyCheckInView()
                    
                    // Watch + Heart Rate Row
                    HStack(spacing: 14) {
                        AppleWatchCard(
                            isPaired: viewModel.isWatchPaired,
                            isReachable: viewModel.isWatchReachable,
                            isAppInstalled: viewModel.isWatchAppInstalled
                        )
                        HeartRateCard(
                            bpm: viewModel.healthMetrics?.heartRate,
                            restingBPM: viewModel.healthMetrics?.restingHeartRate,
                            history: viewModel.heartRateHistory
                        )
                    }

                    // Heart Rate Chart Full
                    HeartRateChartCard(history: viewModel.heartRateHistory)

                    // Steps
                    StepsCard(
                        steps: viewModel.healthMetrics?.steps,
                        history: viewModel.stepsHistory
                    )

                    // Stress + HRV
                    HStack(spacing: 14) {
                        StressLevelCard(
                            stressScore: viewModel.healthAnalysis?.stressScore,
                            level: viewModel.stressLevel
                        )
                        HRVCard(hrv: viewModel.healthMetrics?.hrv)
                    }

                    // Sleep
                    SleepCard(
                        sleepHours: viewModel.healthMetrics?.sleepHours,
                        sleepData: viewModel.sleepData
                    )

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .onAppear {
            Task {
                await viewModel.requestHealthKitAuthorization()
                await viewModel.fetchAllHealthData()
                viewModel.startHeartRateMonitoring()
                await HealthKitManager.shared.setupBackgroundDelivery()
            }
        }
        .onDisappear {
            viewModel.stopMonitoring()
        }
    }
}

// MARK: - Header

struct HomeHeaderView: View {
    @State private var currentDate = Date()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: currentDate)
        switch hour {
        case 5..<12:  return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<21: return "Good Evening"
        default:      return "Good Night"
        }
    }

    private var timeString: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm"
        return fmt.string(from: currentDate)
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting)
                    .font(.custom("Outfit-Regular", size: 15))
                    .foregroundColor(Color.mindHexColor("7C6A5B"))
                Text("I'M MEESUK")
                    .font(.custom("Outfit-Bold", size: 28))
                    .foregroundColor(Color.mindHexColor("4A3422"))
                Text("Take care of your mental health today.")
                    .font(.custom("Outfit-Regular", size: 13))
                    .foregroundColor(Color.mindHexColor("7C6A5B"))
                    .padding(.top, 2)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Button(action: {}) {
                    ZStack(alignment: .topTrailing) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 46, height: 46)
                            .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 4)
                        Image(systemName: "bell.fill")
                            .foregroundColor(Color.mindHexColor("EB6538"))
                            .font(.system(size: 18))
                            .frame(width: 46, height: 46)
                        Circle()
                            .fill(Color.red)
                            .frame(width: 9, height: 9)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .offset(x: -5, y: 5)
                    }
                }
                Text(timeString)
                    .font(.custom("Outfit-Medium", size: 12))
                    .foregroundColor(Color.mindHexColor("9A8B7F"))
            }
        }
        .padding(.top, 10)
        .onReceive(timer) { _ in currentDate = Date() }
    }
}

// MARK: - Daily Check-in

struct DailyCheckInView: View {
    let moods: [(String, String, Color)] = [
        ("Mee_Great", "Great!", Color.mindHexColor("92E1A7")),
        ("Mee_Good", "Good", Color.mindHexColor("BFDFEF")),
        ("Mee_Okay", "Okay", Color.mindHexColor("F9E296")),
        ("Mee_Low", "Low", Color.mindHexColor("F9C3B9")),
    ]
    @State private var selected: Int? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Daily Check-in")
                        .font(.custom("Outfit-Bold", size: 18))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                    Text("Tap to log your mood")
                        .font(.custom("Outfit-Regular", size: 13))
                        .foregroundColor(Color.mindHexColor("9A8B7F"))
                }
                Spacer()
                Text(Date(), style: .date)
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(Color.mindHexColor("9A8B7F"))
            }

            HStack(spacing: 10) {
                ForEach(moods.indices, id: \.self) { i in
                    let mood = moods[i]
                    Button(action: { withAnimation(.spring()) { selected = i } }) {
                        VStack(spacing: 6) {
                            Image(mood.0)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 46, height: 46)
                                .padding(8)
                                .background(mood.2)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(
                                        selected == i ? Color.mindHexColor("EB6538") : Color.clear,
                                        lineWidth: 2.5)
                                )
                                .scaleEffect(selected == i ? 1.08 : 1.0)
                            Text(mood.1)
                                .font(.custom("Outfit-Medium", size: 11))
                                .foregroundColor(Color.mindHexColor("4A3422"))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Apple Watch Card

struct AppleWatchCard: View {
    let isPaired: Bool
    let isReachable: Bool
    let isAppInstalled: Bool
    @State private var isPulsing = false

    var statusColor: Color {
        if isReachable { return Color.mindHexColor("3AB05D") }
        if isPaired    { return Color.mindHexColor("F5A623") }
        return Color.mindHexColor("C0B0A0")
    }
    var statusText: String {
        if isReachable { return "Connected" }
        if isPaired    { return "Reconnecting" }
        return "Not Paired"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(
                            colors: [Color.mindHexColor("4A3422").opacity(0.9), Color.mindHexColor("7C5C3E")],
                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 38, height: 38)
                    Image(systemName: "applewatch")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
                Spacer()
                ZStack {
                    if isReachable {
                        Circle()
                            .fill(statusColor.opacity(0.3))
                            .frame(width: 18, height: 18)
                            .scaleEffect(isPulsing ? 1.6 : 1.0)
                            .opacity(isPulsing ? 0 : 1)
                            .animation(.easeOut(duration: 1.3).repeatForever(autoreverses: false), value: isPulsing)
                    }
                    Circle().fill(statusColor).frame(width: 9, height: 9)
                }
                .onAppear { isPulsing = true }
            }
            .padding(.bottom, 10)

            Text("Apple Watch")
                .font(.custom("Outfit-SemiBold", size: 14))
                .foregroundColor(Color.mindHexColor("4A3422"))
            Text(statusText)
                .font(.custom("Outfit-Regular", size: 11))
                .foregroundColor(statusColor)
                .padding(.top, 1)

            Spacer(minLength: 8)

            if !isAppInstalled && isPaired {
                HStack(spacing: 3) {
                    Image(systemName: "arrow.down.circle.fill").font(.system(size: 10))
                    Text("Install App").font(.custom("Outfit-Medium", size: 10))
                }
                .foregroundColor(Color.mindHexColor("EB6538"))
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(Color.mindHexColor("EB6538").opacity(0.12))
                .cornerRadius(8)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 128, alignment: .leading)
        .background(LinearGradient(
            colors: [Color.mindHexColor("FDF6EC"), Color.mindHexColor("FFF0DC")],
            startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(22)
        .overlay(RoundedRectangle(cornerRadius: 22)
            .stroke(statusColor.opacity(isReachable ? 0.4 : 0.1), lineWidth: 1.5))
    }
}

// MARK: - Heart Rate Card (compact)

struct HeartRateCard: View {
    let bpm: Double?
    let restingBPM: Double?
    let history: [HealthDataPoint]
    @State private var heartPulse = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color.mindHexColor("E8503A"))
                    .scaleEffect(heartPulse ? 1.25 : 1.0)
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: heartPulse)
                    .onAppear { heartPulse = true }
                Spacer()
                if let bpm = bpm {
                    Text(bpm < 100 && bpm > 50 ? "Normal" : "Review")
                        .font(.custom("Outfit-Medium", size: 10))
                        .padding(.horizontal, 7).padding(.vertical, 3)
                        .background((bpm < 100 && bpm > 50 ? Color.green : Color.orange).opacity(0.12))
                        .foregroundColor(bpm < 100 && bpm > 50 ? .green : .orange)
                        .cornerRadius(8)
                }
            }
            .padding(.bottom, 6)

            Text("Heart Rate")
                .font(.custom("Outfit-Regular", size: 12))
                .foregroundColor(Color.mindHexColor("9A8B7F"))

            HStack(alignment: .bottom, spacing: 2) {
                Text(bpm != nil ? String(format: "%.0f", bpm!) : "--")
                    .font(.custom("Outfit-Bold", size: 28))
                    .foregroundColor(Color.mindHexColor("4A3422"))
                Text("BPM")
                    .font(.custom("Outfit-Medium", size: 12))
                    .foregroundColor(Color.mindHexColor("9A8B7F"))
                    .padding(.bottom, 4)
            }

            // Mini sparkline
            if !history.isEmpty {
                MiniLineChart(data: history.map { $0.value }, color: Color.mindHexColor("E8503A"))
                    .frame(height: 28)
                    .padding(.top, 4)
            }

            HStack {
                Label(restingBPM != nil ? String(format: "%.0f", restingBPM!) + " resting" : "-- resting",
                      systemImage: "bed.double.fill")
                    .font(.custom("Outfit-Regular", size: 10))
                    .foregroundColor(Color.mindHexColor("9A8B7F"))
                Spacer()
                Circle().fill(Color.red).frame(width: 6, height: 6)
                Text("Live").font(.custom("Outfit-Regular", size: 10))
                    .foregroundColor(Color.mindHexColor("9A8B7F"))
            }
            .padding(.top, 4)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 128, alignment: .leading)
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Heart Rate Chart Full Card

struct HeartRateChartCard: View {
    let history: [HealthDataPoint]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Heart Rate History")
                        .font(.custom("Outfit-Bold", size: 16))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                    Text("Last 7 days")
                        .font(.custom("Outfit-Regular", size: 12))
                        .foregroundColor(Color.mindHexColor("9A8B7F"))
                }
                Spacer()
                if let max = history.map({ $0.value }).max(),
                   let min = history.map({ $0.value }).min() {
                    VStack(alignment: .trailing, spacing: 2) {
                        Label(String(format: "%.0f", max), systemImage: "arrow.up")
                            .font(.custom("Outfit-Medium", size: 12))
                            .foregroundColor(Color.mindHexColor("E8503A"))
                        Label(String(format: "%.0f", min), systemImage: "arrow.down")
                            .font(.custom("Outfit-Medium", size: 12))
                            .foregroundColor(Color.mindHexColor("3AB05D"))
                    }
                }
            }

            if history.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "waveform.path.ecg")
                            .font(.system(size: 30))
                            .foregroundColor(Color.mindHexColor("D0C0B0"))
                        Text("No heart rate data yet")
                            .font(.custom("Outfit-Regular", size: 13))
                            .foregroundColor(Color.mindHexColor("9A8B7F"))
                    }
                    Spacer()
                }
                .frame(height: 100)
            } else {
                BarChart(data: history, color: Color.mindHexColor("E8503A"))
                    .frame(height: 100)
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Steps Card

struct StepsCard: View {
    let steps: Int?
    let history: [HealthDataPoint]

    let goal = 10000

    var progress: CGFloat {
        guard let s = steps, goal > 0 else { return 0 }
        return min(CGFloat(s) / CGFloat(goal), 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(
                            colors: [Color.mindHexColor("5B8EF0"), Color.mindHexColor("7EAAFF")],
                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 38, height: 38)
                    Image(systemName: "figure.walk")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 1) {
                    Text("Steps Today")
                        .font(.custom("Outfit-SemiBold", size: 15))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                    Text("Goal: \(goal.formattedWithSeparator) steps")
                        .font(.custom("Outfit-Regular", size: 12))
                        .foregroundColor(Color.mindHexColor("9A8B7F"))
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(steps != nil ? steps!.formattedWithSeparator : "--")
                        .font(.custom("Outfit-Bold", size: 24))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                    Text("\(Int(progress * 100))% of goal")
                        .font(.custom("Outfit-Regular", size: 11))
                        .foregroundColor(Color.mindHexColor("5B8EF0"))
                }
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.mindHexColor("EEF2FF")).frame(height: 10)
                    Capsule()
                        .fill(LinearGradient(colors: [Color.mindHexColor("5B8EF0"), Color.mindHexColor("7EAAFF")],
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * progress, height: 10)
                }
            }
            .frame(height: 10)

            // Bar chart
            if !history.isEmpty {
                BarChart(data: history, color: Color.mindHexColor("5B8EF0"))
                    .frame(height: 60)
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Stress Level Card

struct StressLevelCard: View {
    let stressScore: Double?
    let level: StressLevel

    var statusColor: Color {
        switch level {
        case .low: return .green
        case .moderate: return Color.mindHexColor("F5A623")
        case .high: return .orange
        case .veryHigh: return .red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(
                            colors: [Color.mindHexColor("E8503A").opacity(0.85), Color.mindHexColor("FF7A59")],
                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 38, height: 38)
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                Spacer()
                Text(level.displayName)
                    .font(.custom("Outfit-Medium", size: 10))
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(statusColor.opacity(0.12))
                    .foregroundColor(statusColor)
                    .cornerRadius(8)
            }

            Text("Stress")
                .font(.custom("Outfit-Regular", size: 12))
                .foregroundColor(Color.mindHexColor("9A8B7F"))

            HStack(alignment: .bottom, spacing: 2) {
                Text(stressScore != nil ? String(format: "%.0f", stressScore!) : "--")
                    .font(.custom("Outfit-Bold", size: 26))
                    .foregroundColor(Color.mindHexColor("4A3422"))
                Text("%").font(.custom("Outfit-Medium", size: 12))
                    .foregroundColor(Color.mindHexColor("9A8B7F")).padding(.bottom, 3)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.mindHexColor("F2F2F2")).frame(height: 7)
                    Capsule()
                        .fill(LinearGradient(colors: [statusColor.opacity(0.6), statusColor],
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * CGFloat((stressScore ?? 0) / 100.0), height: 7)
                }
            }
            .frame(height: 7)

            HStack {
                Text("Relaxed").font(.custom("Outfit-Regular", size: 9)).foregroundColor(Color.mindHexColor("9A8B7F"))
                Spacer()
                Text("High").font(.custom("Outfit-Regular", size: 9)).foregroundColor(Color.mindHexColor("9A8B7F"))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

// MARK: - HRV Card

struct HRVCard: View {
    let hrv: Double?

    var hrvColor: Color {
        guard let h = hrv else { return Color.mindHexColor("3AB05D") }
        if h > 50 { return Color.mindHexColor("3AB05D") }
        if h > 30 { return Color.mindHexColor("F5A623") }
        return .red
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(
                            colors: [Color.mindHexColor("3AB05D").opacity(0.85), Color.mindHexColor("5DD98A")],
                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 38, height: 38)
                    Image(systemName: "waveform.path.ecg.rectangle")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                }
                Spacer()
                Text("HRV").font(.custom("Outfit-Medium", size: 12))
                    .foregroundColor(Color.mindHexColor("9A8B7F"))
            }

            Text("Variability")
                .font(.custom("Outfit-Regular", size: 12))
                .foregroundColor(Color.mindHexColor("9A8B7F"))

            HStack(alignment: .bottom, spacing: 2) {
                Text(hrv != nil ? String(format: "%.0f", hrv!) : "--")
                    .font(.custom("Outfit-Bold", size: 26))
                    .foregroundColor(Color.mindHexColor("4A3422"))
                Text("ms").font(.custom("Outfit-Medium", size: 12))
                    .foregroundColor(Color.mindHexColor("9A8B7F")).padding(.bottom, 3)
            }

            if let h = hrv {
                Text(h > 50 ? "Excellent" : h > 30 ? "Normal" : "Low")
                    .font(.custom("Outfit-Medium", size: 10))
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(hrvColor.opacity(0.12))
                    .foregroundColor(hrvColor)
                    .cornerRadius(8)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Sleep Card

struct SleepCard: View {
    let sleepHours: Double?
    let sleepData: [SleepData]

    var sleepColor: Color {
        guard let h = sleepHours else { return Color.mindHexColor("8B79E0") }
        if h >= 7 { return Color.mindHexColor("3AB05D") }
        if h >= 5 { return Color.mindHexColor("F5A623") }
        return .red
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(
                            colors: [Color.mindHexColor("8B79E0"), Color.mindHexColor("A99AFF")],
                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 38, height: 38)
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 1) {
                    Text("Sleep")
                        .font(.custom("Outfit-SemiBold", size: 15))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                    Text("Last night")
                        .font(.custom("Outfit-Regular", size: 12))
                        .foregroundColor(Color.mindHexColor("9A8B7F"))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 1) {
                    Text(sleepHours != nil ? String(format: "%.1f hrs", sleepHours!) : "-- hrs")
                        .font(.custom("Outfit-Bold", size: 22))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                    if let h = sleepHours {
                        Text(h >= 7 ? "Good" : h >= 5 ? "Fair" : "Poor")
                            .font(.custom("Outfit-Medium", size: 11))
                            .foregroundColor(sleepColor)
                    }
                }
            }

            if !sleepData.isEmpty {
                VStack(spacing: 8) {
                    SleepProgressRow(
                        label: "Deep Sleep",
                        value: String(format: "%.1fh", sleepDuration(for: .deep)),
                        progress: sleepProgress(for: .deep),
                        color: Color.mindHexColor("4D44B5"))
                    SleepProgressRow(
                        label: "REM Sleep",
                        value: String(format: "%.1fh", sleepDuration(for: .rem)),
                        progress: sleepProgress(for: .rem),
                        color: Color.mindHexColor("8B79E0"))
                    SleepProgressRow(
                        label: "Light Sleep",
                        value: String(format: "%.1fh", sleepDuration(for: .core)),
                        progress: sleepProgress(for: .core),
                        color: Color.mindHexColor("A99AFF"))
                }
            } else {
                HStack {
                    Spacer()
                    VStack(spacing: 6) {
                        Image(systemName: "moon.zzz.fill")
                            .font(.system(size: 26))
                            .foregroundColor(Color.mindHexColor("D0C0E0"))
                        Text("No sleep data for tonight")
                            .font(.custom("Outfit-Regular", size: 13))
                            .foregroundColor(Color.mindHexColor("9A8B7F"))
                    }
                    Spacer()
                }
                .padding(.vertical, 10)
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 4)
    }

    private func sleepDuration(for stage: SleepStage) -> Double {
        sleepData.filter { $0.stage == stage }.reduce(0) { $0 + $1.durationInHours }
    }
    private func sleepProgress(for stage: SleepStage) -> CGFloat {
        let total = sleepData.reduce(0) { $0 + $1.durationInHours }
        guard total > 0 else { return 0 }
        return CGFloat(sleepDuration(for: stage) / total)
    }
}

struct SleepProgressRow: View {
    let label: String
    let value: String
    let progress: CGFloat
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                HStack(spacing: 5) {
                    Circle().fill(color).frame(width: 7, height: 7)
                    Text(label)
                        .font(.custom("Outfit-Regular", size: 12))
                        .foregroundColor(Color.mindHexColor("7C6A5B"))
                }
                Spacer()
                Text(value)
                    .font(.custom("Outfit-SemiBold", size: 12))
                    .foregroundColor(Color.mindHexColor("4A3422"))
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.mindHexColor("F2F2F2")).frame(height: 7)
                    Capsule().fill(color).frame(width: geo.size.width * progress, height: 7)
                }
            }
            .frame(height: 7)
        }
    }
}

// MARK: - Charts

/// Mini sparkline chart (compact, for card headers)
struct MiniLineChart: View {
    let data: [Double]
    let color: Color

    var body: some View {
        GeometryReader { geo in
            if let minVal = data.min(), let maxVal = data.max(), maxVal > minVal {
                Path { path in
                    for (i, val) in data.enumerated() {
                        let x = geo.size.width * CGFloat(i) / CGFloat(max(data.count - 1, 1))
                        let y = geo.size.height * (1 - CGFloat((val - minVal) / (maxVal - minVal)))
                        if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                        else { path.addLine(to: CGPoint(x: x, y: y)) }
                    }
                }
                .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            }
        }
    }
}

/// Bar chart for history data
struct BarChart: View {
    let data: [HealthDataPoint]
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let vals = data.map { $0.value }
            let maxVal = vals.max() ?? 1
            let barW = (geo.size.width / CGFloat(data.count)) * 0.55
            let gap = (geo.size.width / CGFloat(data.count)) * 0.45

            HStack(alignment: .bottom, spacing: gap) {
                ForEach(data) { point in
                    let h = geo.size.height * CGFloat(point.value / maxVal)
                    VStack(spacing: 3) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(color.opacity(0.75))
                            .frame(width: barW, height: h)
                        Text(point.date.formatted("EEE"))
                            .font(.custom("Outfit-Regular", size: 8))
                            .foregroundColor(Color.mindHexColor("9A8B7F"))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    HomeView()
}
