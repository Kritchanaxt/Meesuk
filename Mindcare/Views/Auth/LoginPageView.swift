import SwiftUI

struct LoginPageView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showSignUp = false
    @State private var showForgotPassword = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Layer 1: Background Watercolor
                AuthHeaderView()
                    .frame(height: geo.size.height * 0.35)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.175)

                // Layer 2: Main Content (Scrollable Card)
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geo.size.height * 0.20)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            // Form Fields
                            VStack(spacing: 12) {
                                MindcareTextField(
                                    label: "Email",
                                    placeholder: "Your Email Address",
                                    text: $viewModel.email
                                )
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)

                                VStack(alignment: .trailing, spacing: 12) {
                                    MindcareTextField(
                                        label: "Password",
                                        placeholder: "**************",
                                        text: $viewModel.password,
                                        isSecure: true
                                    )

                                    Button(action: {
                                        showForgotPassword = true
                                    }) {
                                        Text("Forget Password")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(
                                                Color(red: 0.93, green: 0.45, blue: 0.35))
                                    }
                                }
                            }

                            // Demo credentials hint
                            VStack(spacing: 6) {
                                Text("For Testing / Demo Mode")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                
                                Button(action: {
                                    viewModel.fillDemoCredentials()
                                }) {
                                    Text("Use Demo: demo@mindcare.com / demo1234")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(
                                            Capsule().stroke(Color(red: 0.93, green: 0.45, blue: 0.35), lineWidth: 1)
                                        )
                                }
                            }
                            .padding(.top, -5)
                            .padding(.bottom, 5)

                            // Action Buttons
                            VStack(spacing: 20) {
                                MindcareButton(
                                    title: "Login",
                                    action: {
                                        Task {
                                            await viewModel.login()
                                        }
                                    },
                                    isLoading: viewModel.isLoading
                                )

                                SocialLoginButtons(
                                    onGoogleTap: { /* Handle Google */  },
                                    onFacebookTap: { /* Handle Facebook */  }
                                )
                            }

                            // Sign Up Link
                            HStack(spacing: 4) {
                                Text("Don't have an account?")
                                    .foregroundColor(.gray)

                                Button(action: {
                                    showSignUp = true
                                }) {
                                    Text("Sign Up")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
                                }
                            }
                            .font(.system(size: 14))
                            .padding(.top, 8)

                            // Compliance Badges
                            VStack(spacing: 8) {
                                BadgeItem(icon: "lock.fill", text: "HIPAA Compliant")
                                BadgeItem(
                                    icon: "checkmark.shield.fill", text: "End-to-End Encrypted")
                            }
                            .padding(.top, 20)

                            Spacer()
                                .frame(height: 40)
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

                // Layer 3: Foreground Elements (Logos & Mascot) - Rendered last to stay on top
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
                    .offset(y: -280)  // Match card's offset

                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
        .sheet(isPresented: $showSignUp) {
            RegisterPageView()
        }
        .sheet(isPresented: $showForgotPassword) {
            ResetPasswordView()
        }
    }
}

struct BadgeItem: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.green.opacity(0.6))
                .font(.system(size: 14))

            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.gray.opacity(0.8))

            Spacer()
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    LoginPageView()
}
