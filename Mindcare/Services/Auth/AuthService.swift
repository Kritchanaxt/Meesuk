//
//  AuthService.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation
import AuthenticationServices
import Combine

/// Authentication Service - จัดการการ Login/Logout
final class AuthService: NSObject, ObservableObject {
    
    // MARK: - Singleton
    static let shared = AuthService()
    
    // MARK: - Properties
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: UserProfile?
    @Published var userRole: UserRole = .patient
    
    private var authContinuation: CheckedContinuation<ASAuthorization, Error>?
    
    // MARK: - Demo Mode
    static let isDemoMode = true  // Set to false when backend is ready
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        checkAuthState()
    }
    
    // MARK: - Check Auth State
    
    /// ตรวจสอบสถานะการ Login
    private func checkAuthState() {
        if let token = KeychainManager.shared.get(key: AppConstants.Keychain.accessToken) {
            isAuthenticated = !token.isEmpty
            
            // Load cached user profile
            loadCachedUser()
        }
    }
    
    private func loadCachedUser() {
        // Load from UserDefaults or local storage
        if let roleString = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.userRole),
           let role = UserRole(rawValue: roleString) {
            userRole = role
        }
    }
    
    // MARK: - Email/Password Login
    
    /// Login ด้วย Email และ Password
    func login(email: String, password: String) async throws {
        let response = try await APIService.shared.login(email: email, password: password)
        await MainActor.run {
            self.handleAuthResponse(response)
        }
    }
    
    /// Register ด้วย Email และ Password
    func register(email: String, password: String, name: String) async throws {
        let response = try await APIService.shared.register(email: email, password: password, name: name)
        await MainActor.run {
            self.handleAuthResponse(response)
        }
    }
    
    // MARK: - Apple Sign In
    
    /// Login ด้วย Apple ID
    func signInWithApple() async throws {
        let authorization = try await performAppleSignIn()
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityTokenData = appleIDCredential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8),
              let authorizationCodeData = appleIDCredential.authorizationCode,
              let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) else {
            throw AuthError.invalidCredentials
        }
        
        // Get full name
        var fullName: String? = nil
        if let nameComponents = appleIDCredential.fullName {
            fullName = PersonNameComponentsFormatter().string(from: nameComponents)
        }
        
        // Send to backend
        let response = try await APIService.shared.appleLogin(
            identityToken: identityToken,
            authorizationCode: authorizationCode,
            fullName: fullName
        )
        
        await MainActor.run {
            self.handleAuthResponse(response)
        }
    }
    
    private func performAppleSignIn() async throws -> ASAuthorization {
        try await withCheckedThrowingContinuation { continuation in
            self.authContinuation = continuation
            
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        }
    }
    
    // MARK: - Token Refresh
    
    /// Refresh Token
    func refreshToken() async throws {
        guard let refreshToken = KeychainManager.shared.get(key: AppConstants.Keychain.refreshToken) else {
            throw AuthError.noRefreshToken
        }
        
        let response = try await APIService.shared.refreshToken(refreshToken: refreshToken)
        
        // Save new tokens
        KeychainManager.shared.save(key: AppConstants.Keychain.accessToken, value: response.accessToken)
        if let newRefreshToken = response.refreshToken {
            KeychainManager.shared.save(key: AppConstants.Keychain.refreshToken, value: newRefreshToken)
        }
    }
    
    // MARK: - Logout
    
    /// Logout
    func logout() async {
        do {
            try await APIService.shared.logout()
        } catch {
            print("Logout API error: \(error)")
        }
        
        // Clear local data
        clearAuthData()
    }
    
    private func clearAuthData() {
        KeychainManager.shared.delete(key: AppConstants.Keychain.accessToken)
        KeychainManager.shared.delete(key: AppConstants.Keychain.refreshToken)
        KeychainManager.shared.delete(key: AppConstants.Keychain.userID)
        
        UserDefaults.standard.removeObject(forKey: AppConstants.UserDefaultsKeys.userRole)
        
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.currentUser = nil
            self.userRole = .patient
        }
        
        NotificationCenter.default.post(name: AppConstants.NotificationNames.userDidLogout, object: nil)
    }
    
    // MARK: - Handle Auth Response
    
    private func handleAuthResponse(_ response: AuthResponse) {
        // Save tokens
        KeychainManager.shared.save(key: AppConstants.Keychain.accessToken, value: response.accessToken)
        if let refreshToken = response.refreshToken {
            KeychainManager.shared.save(key: AppConstants.Keychain.refreshToken, value: refreshToken)
        }
        
        // Save user info
        self.currentUser = response.user
        self.userRole = response.user.role
        self.isAuthenticated = true
        
        if let userId = response.user.id {
            KeychainManager.shared.save(key: AppConstants.Keychain.userID, value: userId)
        }
        
        UserDefaults.standard.set(response.user.role.rawValue, forKey: AppConstants.UserDefaultsKeys.userRole)
        
        NotificationCenter.default.post(name: AppConstants.NotificationNames.userDidLogin, object: nil)
    }
    
    // MARK: - Get Current User
    
    /// ดึงข้อมูล User ปัจจุบัน
    func fetchCurrentUser() async throws {
        let user = try await APIService.shared.getProfile()
        
        await MainActor.run {
            self.currentUser = user
            self.userRole = user.role
        }
    }
    
    // MARK: - Check Apple ID Credential State
    
    /// ตรวจสอบสถานะ Apple ID Credential
    func checkAppleIDCredentialState(userID: String) async -> ASAuthorizationAppleIDProvider.CredentialState {
        await withCheckedContinuation { continuation in
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID) { state, _ in
                continuation.resume(returning: state)
            }
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AuthService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        authContinuation?.resume(returning: authorization)
        authContinuation = nil
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authContinuation?.resume(throwing: error)
        authContinuation = nil
    }
}

// MARK: - Auth Errors

enum AuthError: LocalizedError {
    case invalidCredentials
    case noRefreshToken
    case tokenExpired
    case appleSignInFailed
    case accountDisabled
    case emailNotVerified
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .noRefreshToken:
            return "No refresh token available"
        case .tokenExpired:
            return "Session expired. Please login again"
        case .appleSignInFailed:
            return "Apple Sign In failed"
        case .accountDisabled:
            return "Your account has been disabled"
        case .emailNotVerified:
            return "Please verify your email"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

// MARK: - User Role

enum UserRole: String, Codable {
    case patient = "patient"
    case psychiatrist = "psychiatrist"
    case admin = "admin"
    
    var displayName: String {
        switch self {
        case .patient:
            return "Patient"
        case .psychiatrist:
            return "Psychiatrist"
        case .admin:
            return "Admin"
        }
    }
}
