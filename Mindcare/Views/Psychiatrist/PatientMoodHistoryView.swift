import SwiftUI

struct PatientMoodHistoryView: View {
    let moodEntries: [MoodEntry]
    let isLoading: Bool

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1.0, green: 0.97, blue: 0.88).ignoresSafeArea()

                if isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("กำลังโหลดข้อมูล...")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                } else if moodEntries.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "chart.bar.xaxis")
                            .font(.system(size: 48))
                            .foregroundColor(.gray.opacity(0.4))
                        Text("ยังไม่มีข้อมูล Mood")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 14) {
                            // Summary Bar
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("ค่าเฉลี่ย Mood")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                    Text(String(format: "%.1f / 5.0", averageMood))
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
                                }
                                Spacer()
                                Text(overallEmoji)
                                    .font(.system(size: 48))
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
                            )
                            .padding(.horizontal)

                            // Daily entries
                            ForEach(sortedEntries) { entry in
                                MoodEntryRow(entry: entry)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Mood ผู้ป่วย (7 วัน)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("ปิด") { dismiss() }
                        .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
                }
            }
        }
    }

    private var sortedEntries: [MoodEntry] {
        moodEntries.sorted { $0.createdAt > $1.createdAt }
    }

    private var averageMood: Double {
        guard !moodEntries.isEmpty else { return 0 }
        let total = moodEntries.reduce(0) { $0 + $1.moodLevel }
        return Double(total) / Double(moodEntries.count)
    }

    private var overallEmoji: String {
        let avg = averageMood
        if avg >= 4.5 { return "😄" }
        if avg >= 3.5 { return "🙂" }
        if avg >= 2.5 { return "😐" }
        if avg >= 1.5 { return "😔" }
        return "😢"
    }
}

// MARK: - Mood Entry Row

struct MoodEntryRow: View {
    let entry: MoodEntry

    var body: some View {
        HStack(spacing: 14) {
            Text(entry.moodEmoji)
                .font(.system(size: 32))

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(entry.moodText)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
                    Spacer()
                    Text(entry.createdAt.formatted(.dateTime.day().month().hour().minute()))
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }

                // Mood bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(moodColor(level: entry.moodLevel))
                            .frame(width: geo.size.width * CGFloat(entry.moodLevel) / 5.0, height: 6)
                    }
                }
                .frame(height: 6)

                // Emotions
                if !entry.emotions.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(entry.emotions, id: \.self) { emotion in
                                Text("\(emotion.emoji) \(emotion.displayName)")
                                    .font(.system(size: 11))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.08))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
        )
    }

    func moodColor(level: Int) -> Color {
        switch level {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green.opacity(0.7)
        case 5: return .green
        default: return .gray
        }
    }
}
