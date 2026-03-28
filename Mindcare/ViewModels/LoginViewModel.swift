import AuthenticationServices
import Combine
import SwiftUI

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
        !email.isEmpty && !password.isEmpty
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
        KeychainManager.shared.save(
            key: AppConstants.Keychain.accessToken, value: "demo-access-token")
        KeychainManager.shared.save(
            key: AppConstants.Keychain.refreshToken, value: "demo-refresh-token")
        KeychainManager.shared.save(key: AppConstants.Keychain.userID, value: "demo-user-001")

        // Update auth state
        authService.isAuthenticated = true
        authService.currentUser = demoUser
        authService.userRole = .patient

        UserDefaults.standard.set(
            UserRole.patient.rawValue, forKey: AppConstants.UserDefaultsKeys.userRole)

        NotificationCenter.default.post(
            name: AppConstants.NotificationNames.userDidLogin, object: nil)
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

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var nickname = ""
    @Published var password = ""
    @Published var email = ""
    @Published var dateOfBirth = ""
    
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var isRegistrationSuccessful = false
    
    private let authService = AuthService.shared
    
    var isFormValid: Bool {
        !nickname.isEmpty && !password.isEmpty && !email.isEmpty && !dateOfBirth.isEmpty
    }
    
    func register() async {
        guard isFormValid else {
            errorMessage = "Please fill in all fields"
            showError = true
            return
        }
        
        isLoading = true
        showError = false
        
        do {
            try await authService.register(email: email, password: password, name: nickname)
            
            // Assuming successful registration logs the user in automatically or we flag success to dismiss
            isRegistrationSuccessful = true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isLoading = false
    }
}
