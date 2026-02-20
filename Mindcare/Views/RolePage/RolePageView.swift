//
//  RolePageView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI

struct RolePageView: View {

    var onRoleSelected: (UserRole) -> Void

    @State private var appearAnimation = false
    @State private var cardAppear = [false, false, false]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: - Full-screen Background Image
                Image("Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // MARK: - Logo Section (upper area)
                    VStack(spacing: 4) {
                        // MEESUK Logo image
                        Image("MEESUK")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30)
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : -10)

                        // Line and Thai text group
                        VStack(alignment: .trailing, spacing: -2) {
                            Image("Line 1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(x: -30, y: 10)

                            Image("MeeSukThai")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 26)
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(x: 30, y: -4)
                        }
                        .frame(width: 140)
                        .offset(y: appearAnimation ? 0 : 10)
                    }
                    .padding(.top, geo.size.height * 0.08)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .offset(x: 0, y: -10)

                    Spacer()

                    // MARK: - Role Cards Section (lower area)
                    VStack(spacing: 20) {
                        // Patient Card
                        RoleCardView(
                            imageName: "Patient",
                            title: "Patient",
                            subtitle: "Mental wellness tools and support",
                            imageSize: 80,
                            isVisible: cardAppear[0]
                        ) {
                            onRoleSelected(.patient)
                        }

                        // Psychiatrist Card
                        RoleCardView(
                            imageName: "Doctor",
                            title: "Psychiatrist",
                            subtitle: "Patient monitoring and care",
                            imageSize: 80,
                            isVisible: cardAppear[1]
                        ) {
                            onRoleSelected(.psychiatrist)
                        }

                        // Admin Card
                        RoleCardView(
                            imageName: "Admin",
                            title: "Admin",
                            subtitle: "System management",
                            imageSize: 80,
                            isVisible: cardAppear[2]
                        ) {
                            onRoleSelected(.admin)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 40)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // Logo animation
            withAnimation(.easeOut(duration: 0.8)) {
                appearAnimation = true
            }

            // Staggered card animations
            for index in 0..<3 {
                withAnimation(
                    .spring(response: 0.6, dampingFraction: 0.8).delay(0.3 + Double(index) * 0.15)
                ) {
                    cardAppear[index] = true
                }
            }
        }
    }
}

// MARK: - Role Card View

struct RoleCardView: View {
    let imageName: String
    let title: String
    let subtitle: String
    var imageSize: CGFloat = 60
    let isVisible: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Avatar Image — no clip, show original shape
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize, height: imageSize)

                Spacer()

                // Text Content
                VStack(alignment: .center, spacing: 5) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                // Pink chevron arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.55))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                ZStack {
                    // Glass material layer - adjusted for more clarity
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.ultraThinMaterial)
                        .opacity(0.6)

                    // Semi-transparent white tint for milky glass look
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.02))

                    // Glass highlight shimmer
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.02),
                                    Color.clear,
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    // Glass edge border
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.6),
                                    Color.white.opacity(0.1),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 2
                        )
                }
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 5)
            )
        }
        .buttonStyle(.plain)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 30)
    }
}

// MARK: - Preview

#Preview {
    RolePageView(onRoleSelected: { role in
        print("Selected role: \(role)")
    })
}
