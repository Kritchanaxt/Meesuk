//
//  JourneyView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI

struct JourneyView: View {
    @State private var currentPage = 0
    var onFinished: () -> Void

    private let pages: [JourneyPage] = [
        JourneyPage(
            imageName: "Journey-1",
            title: "Your AI companion\nis here",
            description: "Get 24/7 support from a compassionate AI\nthat truly listens",
            buttonText: "Next",
            showArrow: true
        ),
        JourneyPage(
            imageName: "Journey-2",
            title: "Welcome to your\nsafe space",
            description: "A calm, supportive environment designed just\nfor you",
            buttonText: "Next",
            showArrow: true
        ),
        JourneyPage(
            imageName: "Journey-3",
            title: "Track your journey",
            description: "Monitor your mood, build healthy habits, and\ncelebrate progress",
            buttonText: "Get Started",
            showArrow: false
        ),
    ]

    var body: some View {
        ZStack {
            // Page Content (Full Screen Background)
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    JourneyPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            // Bottom Controls Overlay
            VStack {
                Spacer()

                VStack(spacing: 24) {
                    // Page Indicators
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(
                                    currentPage == index
                                        ? Color.mindHexColor("FF8FA3") : Color.mindHexColor("E0E0E0")
                                )
                                .frame(width: currentPage == index ? 24 : 8, height: 8)
                                .animation(
                                    .spring(response: 0.3, dampingFraction: 0.7), value: currentPage
                                )
                                .onTapGesture {
                                    withAnimation {
                                        currentPage = index
                                    }
                                }
                        }
                    }

                    // Button
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            withAnimation {
                                onFinished()
                            }
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text(pages[currentPage].buttonText)
                                .font(.system(size: 16, weight: .semibold))

                            if pages[currentPage].showArrow {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [Color.mindHexColor("5ED4B8"), Color.mindHexColor("7DD9C8")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(28)
                        .shadow(
                            color: Color.mindHexColor("5ED4B8").opacity(0.3), radius: 3, x: 0, y: 4
                        )
                        .shadow(
                            color: Color.mindHexColor("5ED4B8").opacity(0.3), radius: 7.5, x: 0, y: 10
                        )
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 20)
            }
        }
        .transition(.opacity)
    }
}

// MARK: - Subviews & Data Models

struct JourneyPageView: View {
    let page: JourneyPage

    var body: some View {
        ZStack(alignment: .bottom) {
            // Full Screen Background Image
            Image(page.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()

            // Text Content Positioned appropriately
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                Text(page.description)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 180)  // Space for bottom controls
        }
    }
}

struct JourneyPage {
    let imageName: String
    let title: String
    let description: String
    let buttonText: String
    let showArrow: Bool
}

#Preview {
    JourneyView(onFinished: {})
}
