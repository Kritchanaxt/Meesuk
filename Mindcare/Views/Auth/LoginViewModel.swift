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
