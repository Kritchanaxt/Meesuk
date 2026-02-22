import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Layer 1: Background Watercolor & Back Button
                AuthHeaderView(
                    showBackButton: true,
                    onBackAction: {
                        dismiss()
                    }
                )
                .frame(height: geo.size.height * 0.35)
                .position(x: geo.size.width / 2, y: geo.size.height * 0.175)

                // Layer 2: Main Content (Scrollable Card)
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geo.size.height * 0.20)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Form Fields
                            VStack(spacing: 16) {
                                MindcareTextField(
                                    label: "New Password",
                                    placeholder: "Enter New Password",
                                    text: $newPassword,
                                    isSecure: true
                                )

                                MindcareTextField(
                                    label: "Confirm Password",
                                    placeholder: "Confirm Password",
                                    text: $confirmPassword,
                                    isSecure: true
                                )
                            }

                            MindcareButton(
                                title: "Create New Password",
                                action: {
                                    // Handle password reset
                                }, isLoading: isLoading)

                            Spacer()

                            // Back Button
//                            Button(action: {
//                                dismiss()
//                            }) {
//                                HStack(spacing: 8) {
//                                    Image(systemName: "chevron.left")
//                                    Text("Back")
//                                }
//                                .font(.system(size: 16, weight: .bold))
//                                .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
//                            }
//                            .padding(.bottom, 40)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.horizontal, 8)
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 30)
                    }
                    .background(
                        Color(red: 0.99, green: 0.97, blue: 0.9)
                            .cornerRadius(40, corners: [.topLeft, .topRight])
                    )
                    .ignoresSafeArea()
                }

                // Layer 3: Foreground Elements (Logos & Mascot)
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geo.size.height * 0.35)

                    HStack(alignment: .bottom) {
                        // MEESUK Logo & Thai Text
                        VStack(alignment: .trailing, spacing: -5) {
                            Text("หมีสุข")
                                .font(.custom("Arial", size: 18))
                                .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
                                .offset(x: 30, y: 50)

                            Image("MEESUK-B")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 55)
                                .offset(x: 20, y: 50)
                        }
                        .padding(.leading, 24)
                        .padding(.bottom, 100)  // Sit neatly on the card edge

                        Spacer()

                        // Bear Mascot
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .offset(y: 35)  // Overlap the card edge
                    }
                    .padding(.trailing, 10)
                    .offset(y: -280)

                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)

    }
}

#Preview {
    ResetPasswordView()
}
