//
//  MindcareTests.swift
//  MindcareTests
//
//  Created by Mr.Kritchant on 27/11/2568 BE.
//

import XCTest
@testable import Mindcare

// MARK: - Base Test Case
class MindcareBaseTestCase: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
}

// MARK: - Validators Tests
final class ValidatorsTests: MindcareBaseTestCase {
    
    // MARK: - Email Validation Tests
    func testValidEmail() {
        XCTAssertTrue(Validators.isValidEmail("test@example.com"))
        XCTAssertTrue(Validators.isValidEmail("user.name@domain.co.th"))
        XCTAssertTrue(Validators.isValidEmail("user+tag@example.org"))
    }
    
    func testInvalidEmail() {
        XCTAssertFalse(Validators.isValidEmail(""))
        XCTAssertFalse(Validators.isValidEmail("invalid"))
        XCTAssertFalse(Validators.isValidEmail("@example.com"))
        XCTAssertFalse(Validators.isValidEmail("test@"))
        XCTAssertFalse(Validators.isValidEmail("test @example.com"))
    }
    
    // MARK: - Password Validation Tests
    func testValidPassword() {
        XCTAssertTrue(Validators.isValidPassword("Password123!"))
        XCTAssertTrue(Validators.isValidPassword("MySecure@Pass1"))
        XCTAssertTrue(Validators.isValidPassword("Test1234#"))
    }
    
    func testInvalidPassword() {
        XCTAssertFalse(Validators.isValidPassword(""))
        XCTAssertFalse(Validators.isValidPassword("short"))
        XCTAssertFalse(Validators.isValidPassword("nouppercase1!"))
        XCTAssertFalse(Validators.isValidPassword("NOLOWERCASE1!"))
        XCTAssertFalse(Validators.isValidPassword("NoNumbers!"))
    }
    
    // MARK: - Phone Validation Tests
    func testValidThaiPhone() {
        XCTAssertTrue(Validators.isValidThaiPhone("0812345678"))
        XCTAssertTrue(Validators.isValidThaiPhone("0912345678"))
        XCTAssertTrue(Validators.isValidThaiPhone("0612345678"))
    }
    
    func testInvalidThaiPhone() {
        XCTAssertFalse(Validators.isValidThaiPhone(""))
        XCTAssertFalse(Validators.isValidThaiPhone("12345678"))
        XCTAssertFalse(Validators.isValidThaiPhone("081234567")) // too short
        XCTAssertFalse(Validators.isValidThaiPhone("08123456789")) // too long
    }
    
    // MARK: - Name Validation Tests
    func testValidName() {
        XCTAssertTrue(Validators.isValidName("John"))
        XCTAssertTrue(Validators.isValidName("สมชาย"))
        XCTAssertTrue(Validators.isValidName("Mary Jane"))
    }
    
    func testInvalidName() {
        XCTAssertFalse(Validators.isValidName(""))
        XCTAssertFalse(Validators.isValidName("A")) // too short
    }
}

// MARK: - User Models Tests
final class UserModelsTests: MindcareBaseTestCase {
    
    func testUserInitialization() {
        let user = User(
            id: "user123",
            email: "test@example.com",
            firstName: "John",
            lastName: "Doe"
        )
        
        XCTAssertEqual(user.id, "user123")
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.firstName, "John")
        XCTAssertEqual(user.lastName, "Doe")
        XCTAssertEqual(user.fullName, "John Doe")
    }
    
    func testUserProfileInitialization() {
        let profile = UserProfile(
            userId: "user123",
            dateOfBirth: Date(),
            gender: .male,
            emergencyContact: nil
        )
        
        XCTAssertEqual(profile.userId, "user123")
        XCTAssertEqual(profile.gender, .male)
        XCTAssertNil(profile.emergencyContact)
    }
}

// MARK: - Health Models Tests
final class HealthModelsTests: MindcareBaseTestCase {
    
    func testHealthDataInitialization() {
        let now = Date()
        let healthData = HealthData(
            id: "health123",
            userId: "user123",
            date: now,
            steps: 10000,
            heartRate: 72.0,
            sleepHours: 7.5,
            activeCalories: 500.0
        )
        
        XCTAssertEqual(healthData.steps, 10000)
        XCTAssertEqual(healthData.heartRate, 72.0)
        XCTAssertEqual(healthData.sleepHours, 7.5)
        XCTAssertEqual(healthData.activeCalories, 500.0)
    }
    
    func testHeartRateDataInitialization() {
        let now = Date()
        let heartRate = HeartRateData(
            value: 75.0,
            date: now,
            context: .resting
        )
        
        XCTAssertEqual(heartRate.value, 75.0)
        XCTAssertEqual(heartRate.context, .resting)
    }
    
    func testSleepDataInitialization() {
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(8 * 3600) // 8 hours
        
        let sleep = SleepData(
            startDate: startDate,
            endDate: endDate,
            sleepStage: .rem,
            duration: 8 * 3600
        )
        
        XCTAssertEqual(sleep.sleepStage, .rem)
        XCTAssertEqual(sleep.duration, 8 * 3600)
    }
}

// MARK: - Mood Models Tests
final class MoodModelsTests: MindcareBaseTestCase {
    
    func testMoodEntryInitialization() {
        let entry = MoodEntry(
            id: "mood123",
            userId: "user123",
            mood: .happy,
            intensity: 8,
            note: "Feeling great today!",
            timestamp: Date()
        )
        
        XCTAssertEqual(entry.mood, .happy)
        XCTAssertEqual(entry.intensity, 8)
        XCTAssertEqual(entry.note, "Feeling great today!")
    }
    
    func testMoodIntensityValidation() {
        // Intensity should be clamped between 1-10
        let lowEntry = MoodEntry(
            id: "mood1",
            userId: "user1",
            mood: .neutral,
            intensity: 0,
            timestamp: Date()
        )
        
        let highEntry = MoodEntry(
            id: "mood2",
            userId: "user2",
            mood: .neutral,
            intensity: 15,
            timestamp: Date()
        )
        
        XCTAssertGreaterThanOrEqual(lowEntry.intensity, 1)
        XCTAssertLessThanOrEqual(highEntry.intensity, 10)
    }
    
    func testMoodTypeProperties() {
        XCTAssertEqual(MoodType.happy.emoji, "😊")
        XCTAssertEqual(MoodType.sad.emoji, "😢")
        XCTAssertEqual(MoodType.anxious.emoji, "😰")
        XCTAssertEqual(MoodType.calm.emoji, "😌")
        XCTAssertEqual(MoodType.angry.emoji, "😠")
    }
}

// MARK: - Chat Models Tests
final class ChatModelsTests: MindcareBaseTestCase {
    
    func testChatMessageInitialization() {
        let message = ChatMessage(
            id: "msg123",
            conversationId: "conv123",
            senderId: "user123",
            content: "Hello, how are you?",
            timestamp: Date(),
            isFromUser: true
        )
        
        XCTAssertEqual(message.content, "Hello, how are you?")
        XCTAssertTrue(message.isFromUser)
    }
    
    func testConversationInitialization() {
        let conversation = Conversation(
            id: "conv123",
            participantIds: ["user1", "ai"],
            type: .aiChat,
            createdAt: Date()
        )
        
        XCTAssertEqual(conversation.type, .aiChat)
        XCTAssertEqual(conversation.participantIds.count, 2)
    }
}

// MARK: - Payment Models Tests
final class PaymentModelsTests: MindcareBaseTestCase {
    
    func testPaymentTransactionInitialization() {
        let transaction = PaymentTransaction(
            id: "txn123",
            userId: "user123",
            amount: 1500.0,
            currency: "THB",
            status: .completed,
            paymentMethod: .applePay,
            createdAt: Date()
        )
        
        XCTAssertEqual(transaction.amount, 1500.0)
        XCTAssertEqual(transaction.currency, "THB")
        XCTAssertEqual(transaction.status, .completed)
        XCTAssertEqual(transaction.paymentMethod, .applePay)
    }
    
    func testTransactionStatusValues() {
        XCTAssertEqual(TransactionStatus.pending.rawValue, "pending")
        XCTAssertEqual(TransactionStatus.completed.rawValue, "completed")
        XCTAssertEqual(TransactionStatus.failed.rawValue, "failed")
        XCTAssertEqual(TransactionStatus.refunded.rawValue, "refunded")
    }
}

// MARK: - Activity Models Tests
final class ActivityModelsTests: MindcareBaseTestCase {
    
    func testActivityInitialization() {
        let activity = Activity(
            id: "act123",
            name: "Morning Meditation",
            type: .meditation,
            duration: 600,
            scheduledTime: Date()
        )
        
        XCTAssertEqual(activity.name, "Morning Meditation")
        XCTAssertEqual(activity.type, .meditation)
        XCTAssertEqual(activity.duration, 600)
    }
    
    func testActivityCompletionInitialization() {
        let completion = ActivityCompletion(
            id: "comp123",
            activityId: "act123",
            userId: "user123",
            completedAt: Date(),
            duration: 620,
            rating: 4
        )
        
        XCTAssertEqual(completion.rating, 4)
        XCTAssertEqual(completion.duration, 620)
    }
}

// MARK: - Appointment Models Tests
final class AppointmentModelsTests: MindcareBaseTestCase {
    
    func testAppointmentInitialization() {
        let startTime = Date()
        let endTime = startTime.addingTimeInterval(3600) // 1 hour
        
        let appointment = Appointment(
            id: "apt123",
            patientId: "patient123",
            psychiatristId: "psych123",
            scheduledStartTime: startTime,
            scheduledEndTime: endTime,
            status: .scheduled,
            type: .video
        )
        
        XCTAssertEqual(appointment.status, .scheduled)
        XCTAssertEqual(appointment.type, .video)
    }
    
    func testPsychiatristInitialization() {
        let psychiatrist = Psychiatrist(
            id: "psych123",
            userId: "user123",
            licenseNumber: "PSY-12345",
            specializations: [.depression, .anxiety],
            yearsOfExperience: 10,
            consultationFee: 2000.0
        )
        
        XCTAssertEqual(psychiatrist.licenseNumber, "PSY-12345")
        XCTAssertEqual(psychiatrist.specializations.count, 2)
        XCTAssertEqual(psychiatrist.consultationFee, 2000.0)
    }
}

// MARK: - API Endpoints Tests
final class APIEndpointsTests: MindcareBaseTestCase {
    
    func testAuthEndpoints() {
        XCTAssertTrue(APIEndpoints.Auth.login.contains("/auth/login"))
        XCTAssertTrue(APIEndpoints.Auth.register.contains("/auth/register"))
        XCTAssertTrue(APIEndpoints.Auth.logout.contains("/auth/logout"))
        XCTAssertTrue(APIEndpoints.Auth.refreshToken.contains("/auth/refresh"))
    }
    
    func testUserEndpoints() {
        XCTAssertTrue(APIEndpoints.User.profile.contains("/users/profile"))
        XCTAssertTrue(APIEndpoints.User.updateProfile.contains("/users/profile"))
    }
    
    func testHealthEndpoints() {
        XCTAssertTrue(APIEndpoints.Health.syncData.contains("/health/sync"))
        XCTAssertTrue(APIEndpoints.Health.getData.contains("/health/data"))
    }
    
    func testPaymentEndpoints() {
        XCTAssertTrue(APIEndpoints.Payment.process.contains("/payments/process"))
        XCTAssertTrue(APIEndpoints.Payment.verify.contains("/payments/verify"))
    }
}

// MARK: - Logger Tests
final class LoggerTests: MindcareBaseTestCase {
    
    func testLoggerLevels() {
        // These should not crash
        Logger.debug("Debug message")
        Logger.info("Info message")
        Logger.warning("Warning message")
        Logger.error("Error message")
        
        // If we get here, logging works
        XCTAssertTrue(true)
    }
}

// MARK: - Extensions Tests
final class ExtensionsTests: MindcareBaseTestCase {
    
    func testDateFormatting() {
        let date = Date()
        let formatted = date.formatted(date: .abbreviated, time: .shortened)
        XCTAssertFalse(formatted.isEmpty)
    }
    
    func testStringTrimming() {
        let string = "  Hello World  "
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        XCTAssertEqual(trimmed, "Hello World")
    }
}

// MARK: - Performance Tests
final class PerformanceTests: MindcareBaseTestCase {
    
    func testEmailValidationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = Validators.isValidEmail("test@example.com")
            }
        }
    }
    
    func testPasswordValidationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = Validators.isValidPassword("Password123!")
            }
        }
    }
}
