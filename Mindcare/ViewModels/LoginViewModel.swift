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
    private let doctorEmail = "doctor@mindcare.com"
    private let doctorPassword = "doctor1234"

    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }

    func fillDemoCredentials() {
        email = demoEmail
        password = demoPassword
    }

    func fillDoctorCredentials() {
        email = doctorEmail
        password = doctorPassword
    }

    func login() async {
        guard isFormValid else { return }

        isLoading = true

        // Check for demo mode
        if email == demoEmail && password == demoPassword {
            await loginWithDemoMode(role: UserRole.patient)
            isLoading = false
            return
        }

        if email == doctorEmail && password == doctorPassword {
            await loginWithDemoMode(role: UserRole.psychiatrist)
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

    private func loginWithDemoMode(role: UserRole) async {
        let isDoctor = role == .psychiatrist
        let demoId = isDoctor ? "doctor-001" : "demo-user-001"
        let demoName = isDoctor ? "Dr. Aris Thorne, MD" : "Demo User"
        let demoEmailValue = isDoctor ? doctorEmail : demoEmail
        let demoPasswordValue = isDoctor ? doctorPassword : demoPassword

        // ✅ Try real API login first
        do {
            try await authService.login(email: demoEmailValue, password: demoPasswordValue)
            // If success — real token saved, done
            print("✅ Demo login via real API successful")
            return
        } catch {
            // Backend has no demo account — fall back to local demo session
            print("ℹ️ Demo API login unavailable (\(error.localizedDescription)), using local demo session")
        }

        // Fallback: local-only demo session (no real token)
        let demoUser = UserProfile(
            id: demoId,
            email: demoEmailValue,
            name: demoName,
            avatar: isDoctor ? "Doctor" : nil,
            role: role,
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

        // No real token — clear any stale token so we don't send it
        KeychainManager.shared.delete(key: AppConstants.Keychain.accessToken)
        KeychainManager.shared.delete(key: AppConstants.Keychain.refreshToken)
        KeychainManager.shared.save(key: AppConstants.Keychain.userID, value: demoId)

        authService.isAuthenticated = true
        authService.currentUser = demoUser
        authService.userRole = role
        authService.isDemoSession = true  // Flag: API calls that require auth should be skipped

        UserDefaults.standard.set(role.rawValue, forKey: AppConstants.UserDefaultsKeys.userRole)
        NotificationCenter.default.post(name: AppConstants.NotificationNames.userDidLogin, object: nil)
    }


    func handleAppleSignIn(result: Result<ASAuthorization, Error>) async {
        isLoading = true

        switch result {
        case .success:
            // For demo, just log in with demo mode as patient
            await loginWithDemoMode(role: UserRole.patient)
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
