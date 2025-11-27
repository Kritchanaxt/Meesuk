//
//  AuthModels.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation

// MARK: - Auth Response

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: Int
    let user: UserProfile
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case user
    }
}

// MARK: - Token Response

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}

// MARK: - Register Request

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let name: String
    let role: UserRole?
    
    init(email: String, password: String, name: String, role: UserRole? = .patient) {
        self.email = email
        self.password = password
        self.name = name
        self.role = role
    }
}

// MARK: - Apple Login Request

struct AppleLoginRequest: Codable {
    let identityToken: String
    let authorizationCode: String
    let fullName: String?
    
    enum CodingKeys: String, CodingKey {
        case identityToken = "identity_token"
        case authorizationCode = "authorization_code"
        case fullName = "full_name"
    }
}

// MARK: - Password Reset Request

struct PasswordResetRequest: Codable {
    let email: String
}

// MARK: - Password Reset Confirm Request

struct PasswordResetConfirmRequest: Codable {
    let token: String
    let newPassword: String
    
    enum CodingKeys: String, CodingKey {
        case token
        case newPassword = "new_password"
    }
}

// MARK: - Change Password Request

struct ChangePasswordRequest: Codable {
    let currentPassword: String
    let newPassword: String
    
    enum CodingKeys: String, CodingKey {
        case currentPassword = "current_password"
        case newPassword = "new_password"
    }
}
