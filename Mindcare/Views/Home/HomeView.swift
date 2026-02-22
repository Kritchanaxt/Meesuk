//
//  HomeView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.mindHexColor("FFF8E7")  // Light cream background
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    // Header
                    HomeHeaderView()

                    // Daily Check-in
                    DailyCheckInView()

                    // Health Stats Section
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            AppleWatchCard()
                            HeartRateCard()
                        }

                        HStack(spacing: 16) {
                            StressLevelCard()
                            HRVCard()
                        }

                        SleepCard()
                    }

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
}

// MARK: - Subviews

struct HomeHeaderView: View {
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good Morning,")
                    .font(.custom("Outfit-Bold", size: 28))
                    .foregroundColor(Color.mindHexColor("4A3422"))

                Text("Max")
                    .font(.custom("Outfit-Bold", size: 28))
                    .foregroundColor(Color.mindHexColor("4A3422"))

                Text("How are you feeling today?")
                    .font(.custom("Outfit-Regular", size: 16))
                    .foregroundColor(Color.mindHexColor("7C6A5B"))
                    .padding(.top, 4)
            }

            Spacer()

            Button(action: {}) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 45, height: 45)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                    Image("Notification")  // Asset: Session2/Page1_homepage/Notification
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .offset(x: -10.5, y: 10.5)  // Center manually if position() was problematic

                    Circle()
                        .fill(Color.orange)
                        .frame(width: 10, height: 10)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: -2, y: 2)
                }
            }
        }
        .padding(.top, 10)
    }
}

struct DailyCheckInView: View {
    let moods = [
        ("Mee_Great", "Great!", Color.mindHexColor("92E1A7")),
        ("Mee_Good", "Good", Color.mindHexColor("BFDFEF")),
        ("Mee_Okay", "Okay", Color.mindHexColor("F9E296")),
        ("Mee_Low", "Low", Color.mindHexColor("F9C3B9")),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Daily Check-in")
                .font(.custom("Outfit-Bold", size: 20))
                .foregroundColor(Color.mindHexColor("4A3422"))

            Text("Take a moment to reflect on how you're feeling")
                .font(.custom("Outfit-Regular", size: 14))
                .foregroundColor(Color.mindHexColor("7C6A5B"))

            HStack(spacing: 15) {
                ForEach(moods, id: \.0) { mood in
                    VStack(spacing: 8) {
                        Image(mood.0)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(10)
                            .background(mood.2)
                            .clipShape(Circle())

                        Text(mood.1)
                            .font(.custom("Outfit-Medium", size: 12))
                            .foregroundColor(Color.mindHexColor("4A3422"))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
    }
}

struct AppleWatchCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Apple Watch\nSeries 9")
                .font(.custom("Outfit-SemiBold", size: 16))
                .foregroundColor(Color.mindHexColor("4A3422"))

            HStack(spacing: 6) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text("Connected")
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(Color.mindHexColor("7C6A5B"))
            }

            Text("Bettery: 89%")
                .font(.custom("Outfit-Medium", size: 12))
                .foregroundColor(Color.mindHexColor("7C6A5B"))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.mindHexColor("FDF1E5"))
        .cornerRadius(25)
    }
}

struct HeartRateCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("HeartRate")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                Spacer()

                Text("Normal")
                    .font(.custom("Outfit-Medium", size: 10))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(Color.green)
                    .cornerRadius(10)
            }

            Text("Heart Rate")
                .font(.custom("Outfit-Regular", size: 14))
                .foregroundColor(Color.mindHexColor("7C6A5B"))

            HStack(alignment: .bottom, spacing: 4) {
                Text("72")
                    .font(.custom("Outfit-Bold", size: 28))
                Text("BPM")
                    .font(.custom("Outfit-Medium", size: 14))
                    .padding(.bottom, 4)
            }
            .foregroundColor(Color.mindHexColor("4A3422"))

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Resting")
                        .font(.custom("Outfit-Regular", size: 10))
                        .foregroundColor(Color.mindHexColor("9A8B7F"))
                    Text("58 BPM")
                        .font(.custom("Outfit-SemiBold", size: 12))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("Updated")
                        .font(.custom("Outfit-Regular", size: 10))
                        .foregroundColor(Color.mindHexColor("9A8B7F"))
                    Text("2 min ago")
                        .font(.custom("Outfit-SemiBold", size: 12))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                }
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
    }
}

struct StressLevelCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image("Stress")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                Text("Stress Level")
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(Color.mindHexColor("7C6A5B"))

                Spacer()

                Text("Low")
                    .font(.custom("Outfit-Medium", size: 10))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .foregroundColor(Color.orange)
                    .cornerRadius(10)
            }

            HStack(alignment: .bottom, spacing: 4) {
                Text("32")
                    .font(.custom("Outfit-Bold", size: 28))
                Text("%")
                    .font(.custom("Outfit-Medium", size: 14))
                    .padding(.bottom, 4)
            }
            .foregroundColor(Color.mindHexColor("4A3422"))

            // Progress Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.mindHexColor("F2F2F2"))
                        .frame(height: 8)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.green, Color.green.opacity(0.7)],
                                startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: geo.size.width * 0.32, height: 8)
                }
            }
            .frame(height: 8)

            HStack {
                Text("Relaxed")
                    .font(.custom("Outfit-Regular", size: 10))
                    .foregroundColor(Color.mindHexColor("9A8B7F"))
                Spacer()
                Text("High Stress")
                    .font(.custom("Outfit-Regular", size: 10))
                    .foregroundColor(Color.mindHexColor("9A8B7F"))
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
    }
}

struct HRVCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image("HRV")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                Spacer()

                Text("HRV")
                    .font(.custom("Outfit-Medium", size: 12))
                    .foregroundColor(Color.mindHexColor("7C6A5B"))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("45ms")
                    .font(.custom("Outfit-Bold", size: 24))
                    .foregroundColor(Color.mindHexColor("4A3422"))

                Text("Good")
                    .font(.custom("Outfit-Medium", size: 10))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(10)
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
    }
}

struct SleepCard: View {
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                Image("Sleep")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Sleep")
                        .font(.custom("Outfit-Regular", size: 14))
                        .foregroundColor(Color.mindHexColor("7C6A5B"))
                    Text("7.5 hrs")
                        .font(.custom("Outfit-Bold", size: 16))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                }

                Spacer()

                Text("Good")
                    .font(.custom("Outfit-Medium", size: 10))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(10)
            }

            VStack(spacing: 10) {
                SleepProgressRow(
                    label: "Deep Sleep", value: "2.1h", progress: 0.6,
                    color: Color.mindHexColor("AFC8FF"))
                SleepProgressRow(
                    label: "REM Sleep", value: "1.8h", progress: 0.4,
                    color: Color.mindHexColor("D6E4FF")
                )
                SleepProgressRow(
                    label: "Light Sleep", value: "3.6h", progress: 0.8,
                    color: Color.mindHexColor("4D8DFF"))
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
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
                Text(label)
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(Color.mindHexColor("7C6A5B"))
                Spacer()
                Text(value)
                    .font(.custom("Outfit-SemiBold", size: 12))
                    .foregroundColor(Color.mindHexColor("4A3422"))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.mindHexColor("F2F2F2"))
                        .frame(height: 6)

                    Capsule()
                        .fill(color)
                        .frame(width: geo.size.width * progress, height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

#Preview {
    HomeView()
}
