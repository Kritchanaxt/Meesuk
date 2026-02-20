import SwiftUI

struct RegisterPageView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var nickname = ""
    @State private var password = ""
    @State private var mobileNumber = ""
    @State private var dateOfBirth = ""
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
                            VStack(spacing: 12) {
                                MindcareTextField(
                                    label: "Nickname", placeholder: "Your Nickname", text: $nickname
                                )

                                MindcareTextField(
                                    label: "Password", placeholder: "**************",
                                    text: $password,
                                    isSecure: true)

                                MindcareTextField(
                                    label: "Mobile Number", placeholder: "Your Phone Number",
                                    text: $mobileNumber
                                )
                                .keyboardType(.phonePad)

                                MindcareTextField(
                                    label: "Date of birth", placeholder: "DD / MM / YY",
                                    text: $dateOfBirth)
                            }

                            // Terms & Privacy
                            VStack(spacing: 4) {
                                Text("By continuing, you agree to")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)

                                HStack(spacing: 4) {
                                    Button("Terms of Use") {}
                                    Text("and")
                                    Button("Privacy Policy") {}
                                }
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
                            }
                            .padding(.top, -5)

                            // Action Buttons
                            VStack(spacing: 20) {
                                MindcareButton(
                                    title: "Register",
                                    action: {
                                        // Handle registration logic
                                    }, isLoading: isLoading)

                                SocialLoginButtons(onGoogleTap: {}, onFacebookTap: {})
                            }

                            // Login Link
                            HStack(spacing: 4) {
                                Text("Already have an account?")
                                    .foregroundColor(.gray)

                                Button(action: {
                                    dismiss()
                                }) {
                                    Text("Log in")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
                                }
                            }
                            .font(.system(size: 14))
                            .padding(.bottom, 40)
                            .offset(y: -10)
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
                            .offset(y: 35)
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
    RegisterPageView()
}
