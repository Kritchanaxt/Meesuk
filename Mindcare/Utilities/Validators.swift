//
//  Validators.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation

/// Input Validators สำหรับ Form Validation
enum Validators {
    
    // MARK: - Email Validation
    
    struct Email {
        static func validate(_ email: String) -> ValidationResult {
            let trimmed = email.trimmed
            
            if trimmed.isEmpty {
                return .invalid("Email is required")
            }
            
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            
            if !predicate.evaluate(with: trimmed) {
                return .invalid("Please enter a valid email address")
            }
            
            return .valid
        }
    }
    
    // MARK: - Password Validation
    
    struct Password {
        static let minLength = 8
        
        static func validate(_ password: String) -> ValidationResult {
            if password.isEmpty {
                return .invalid("Password is required")
            }
            
            if password.count < minLength {
                return .invalid("Password must be at least \(minLength) characters")
            }
            
            // Check for at least one uppercase letter
            if !password.contains(where: { $0.isUppercase }) {
                return .invalid("Password must contain at least one uppercase letter")
            }
            
            // Check for at least one lowercase letter
            if !password.contains(where: { $0.isLowercase }) {
                return .invalid("Password must contain at least one lowercase letter")
            }
            
            // Check for at least one digit
            if !password.contains(where: { $0.isNumber }) {
                return .invalid("Password must contain at least one number")
            }
            
            return .valid
        }
        
        static func validateMatch(_ password: String, confirmPassword: String) -> ValidationResult {
            if password != confirmPassword {
                return .invalid("Passwords do not match")
            }
            return .valid
        }
    }
    
    // MARK: - Name Validation
    
    struct Name {
        static let minLength = 2
        static let maxLength = 50
        
        static func validate(_ name: String) -> ValidationResult {
            let trimmed = name.trimmed
            
            if trimmed.isEmpty {
                return .invalid("Name is required")
            }
            
            if trimmed.count < minLength {
                return .invalid("Name must be at least \(minLength) characters")
            }
            
            if trimmed.count > maxLength {
                return .invalid("Name must be less than \(maxLength) characters")
            }
            
            // Check for valid characters (letters, spaces, hyphens)
            let nameRegex = "^[a-zA-Zก-๙\\s\\-\\.]+$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
            
            if !predicate.evaluate(with: trimmed) {
                return .invalid("Name can only contain letters, spaces, and hyphens")
            }
            
            return .valid
        }
    }
    
    // MARK: - Phone Number Validation
    
    struct PhoneNumber {
        static func validate(_ phone: String) -> ValidationResult {
            let trimmed = phone.trimmed
            
            if trimmed.isEmpty {
                return .valid // Phone is optional
            }
            
            // Remove common formatting characters
            let digitsOnly = trimmed.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            
            // Thai phone numbers: 9-10 digits
            if digitsOnly.count < 9 || digitsOnly.count > 10 {
                return .invalid("Please enter a valid phone number")
            }
            
            return .valid
        }
    }
    
    // MARK: - Note/Text Validation
    
    struct Text {
        static func validate(_ text: String, maxLength: Int = 1000, required: Bool = false) -> ValidationResult {
            let trimmed = text.trimmed
            
            if required && trimmed.isEmpty {
                return .invalid("This field is required")
            }
            
            if trimmed.count > maxLength {
                return .invalid("Text must be less than \(maxLength) characters")
            }
            
            return .valid
        }
    }
    
    // MARK: - Date Validation
    
    struct DateValidator {
        static func validateDateOfBirth(_ date: Date) -> ValidationResult {
            let now = Date()
            
            if date > now {
                return .invalid("Date of birth cannot be in the future")
            }
            
            // Check if age is reasonable (e.g., between 13 and 120 years)
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: date, to: now)
            
            guard let age = ageComponents.year else {
                return .invalid("Invalid date")
            }
            
            if age < 13 {
                return .invalid("You must be at least 13 years old")
            }
            
            if age > 120 {
                return .invalid("Please enter a valid date of birth")
            }
            
            return .valid
        }
        
        static func validateAppointmentDate(_ date: Date) -> ValidationResult {
            let now = Date()
            
            if date < now {
                return .invalid("Appointment date must be in the future")
            }
            
            // Check if not too far in the future (e.g., within 1 year)
            let calendar = Calendar.current
            let oneYearFromNow = calendar.date(byAdding: .year, value: 1, to: now)!
            
            if date > oneYearFromNow {
                return .invalid("Appointment must be within the next year")
            }
            
            return .valid
        }
    }
    
    // MARK: - Health Data Validation
    
    struct HealthData {
        static func validateHeartRate(_ value: Double) -> ValidationResult {
            if value < 30 || value > 250 {
                return .invalid("Heart rate should be between 30 and 250 BPM")
            }
            return .valid
        }
        
        static func validateWeight(_ value: Double) -> ValidationResult {
            if value < 20 || value > 500 {
                return .invalid("Weight should be between 20 and 500 kg")
            }
            return .valid
        }
        
        static func validateHeight(_ value: Double) -> ValidationResult {
            if value < 50 || value > 300 {
                return .invalid("Height should be between 50 and 300 cm")
            }
            return .valid
        }
    }
}

// MARK: - Validation Result

enum ValidationResult: Equatable {
    case valid
    case invalid(String)
    
    var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }
    
    var errorMessage: String? {
        switch self {
        case .valid:
            return nil
        case .invalid(let message):
            return message
        }
    }
}

// MARK: - Form Validation Helper

struct FormValidator {
    private var validations: [(String, ValidationResult)] = []
    
    mutating func add(field: String, result: ValidationResult) {
        validations.append((field, result))
    }
    
    var isValid: Bool {
        validations.allSatisfy { $0.1.isValid }
    }
    
    var firstError: (field: String, message: String)? {
        for (field, result) in validations {
            if case .invalid(let message) = result {
                return (field, message)
            }
        }
        return nil
    }
    
    var allErrors: [(field: String, message: String)] {
        validations.compactMap { field, result in
            if case .invalid(let message) = result {
                return (field, message)
            }
            return nil
        }
    }
}
