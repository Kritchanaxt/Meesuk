//
//  LoginView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI
import AuthenticationServices
import Combine

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showSignUp = false
    @State private var showForgotPassword = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo
                    VStack(spacing: 16) {
                        Image(systemName: "brain.head.profile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.blue)
                        
                        Text("MindCare")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                    // Login Form
                    VStack(spacing: 16) {
                        // Email Field
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                        
                        // Password Field
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.password)
                        
                        // Sign In Button
                        Button(action: {
                            Task {
                                await viewModel.login()
                            }
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Sign In")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .disabled(viewModel.isLoading || !viewModel.isFormValid)
                        
                        // Sign in with Apple
                        SignInWithAppleButton(.signIn) { request in
                            request.requestedScopes = [.email, .fullName]
                        } onCompletion: { result in
                            Task {
                                await viewModel.handleAppleSignIn(result: result)
                            }
                        }
                        .signInWithAppleButtonStyle(.black)
                        .frame(height: 50)
                        .cornerRadius(12)
                        
                        // Forgot Password & Sign Up
                        HStack {
                            Button("Forgot Password?") {
                                showForgotPassword = true
                            }
                            .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Button("Sign Up") {
                                showSignUp = true
                            }
                            .foregroundColor(.blue)
                        }
                        .font(.subheadline)
                    }
                    .padding(.horizontal)
                    
                    // Demo Mode Info
                    VStack(spacing: 8) {
                        Divider()
                            .padding(.vertical)
                        
                        Text("Demo Mode")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Email: demo@mindcare.com")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Password: demo1234")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button("Fill Demo Credentials") {
                            viewModel.fillDemoCredentials()
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
}

// MARK: - Login ViewModel

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let authService = AuthService.shared
    
    // Demo credentials
    private let demoEmail = "demo@mindcare.com"
    private let demoPassword = "demo1234"
    
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && email.contains("@")
    }
    
    func fillDemoCredentials() {
        email = demoEmail
        password = demoPassword
    }
    
    func login() async {
        guard isFormValid else { return }
        
        isLoading = true
        
        // Check for demo mode
        if email == demoEmail && password == demoPassword {
            await loginWithDemoMode()
            isLoading = false
            return
        }
        
        do {
            try await authService.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isLoading = false
    }
    
    private func loginWithDemoMode() async {
        // Create demo user profile
        let demoUser = UserProfile(
            id: "demo-user-001",
            email: demoEmail,
            name: "Demo User",
            avatar: nil,
            role: .patient,
            dateOfBirth: nil,
            gender: nil,
            phoneNumber: nil,
            createdAt: Date(),
            updatedAt: Date(),
            height: nil,
            weight: nil,
            bloodType: nil,
            emergencyContact: nil
        )
        
        // Save demo token
        KeychainManager.shared.save(key: AppConstants.Keychain.accessToken, value: "demo-access-token")
        KeychainManager.shared.save(key: AppConstants.Keychain.refreshToken, value: "demo-refresh-token")
        KeychainManager.shared.save(key: AppConstants.Keychain.userID, value: "demo-user-001")
        
        // Update auth state
        authService.isAuthenticated = true
        authService.currentUser = demoUser
        authService.userRole = .patient
        
        UserDefaults.standard.set(UserRole.patient.rawValue, forKey: AppConstants.UserDefaultsKeys.userRole)
        
        NotificationCenter.default.post(name: AppConstants.NotificationNames.userDidLogin, object: nil)
    }
    
    func handleAppleSignIn(result: Result<ASAuthorization, Error>) async {
        isLoading = true
        
        switch result {
        case .success:
            // For demo, just log in with demo mode
            await loginWithDemoMode()
        case .failure(let error):
            if (error as NSError).code != ASAuthorizationError.canceled.rawValue {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
        
        isLoading = false
    }
}

// MARK: - Sign Up View

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && email.contains("@") &&
        !password.isEmpty && password == confirmPassword && password.count >= 6
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                    
                    VStack(spacing: 16) {
                        TextField("Full Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.name)
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.newPassword)
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.newPassword)
                        
                        if !password.isEmpty && password != confirmPassword {
                            Text("Passwords do not match")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        Button(action: signUp) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Sign Up")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .background(isFormValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .disabled(!isFormValid || isLoading)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func signUp() {
        isLoading = true
        
        Task {
            do {
                try await AuthService.shared.register(email: email, password: password, name: name)
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Forgot Password View

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var isLoading = false
    @State private var showSuccess = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                Text("Enter your email address and we'll send you a link to reset your password.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                Button(action: sendResetEmail) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Send Reset Link")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(email.contains("@") ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .disabled(!email.contains("@") || isLoading)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Email Sent", isPresented: $showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Check your email for password reset instructions.")
            }
        }
    }
    
    private func sendResetEmail() {
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            showSuccess = true
        }
    }
}

#Preview {
    LoginView()
}
