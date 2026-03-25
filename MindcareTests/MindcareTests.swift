//
//  MindcareTests.swift
//  MindcareTests
//
//  Created for MindCareAI Project
//

import XCTest
@testable import Mindcare

// MARK: - Base Test Case

class MindcareBaseTestCase: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }
}

// MARK: - Validators Tests

final class ValidatorsTests: MindcareBaseTestCase {
    func testValidEmail() {
        XCTAssertTrue(Validators.Email.validate("test@example.com").isValid)
        XCTAssertTrue(Validators.Email.validate("user.name@domain.co.th").isValid)
        XCTAssertTrue(Validators.Email.validate("user+tag@example.org").isValid)
    }

    func testInvalidEmail() {
        XCTAssertFalse(Validators.Email.validate("").isValid)
        XCTAssertFalse(Validators.Email.validate("invalid").isValid)
        XCTAssertFalse(Validators.Email.validate("@example.com").isValid)
        XCTAssertFalse(Validators.Email.validate("test@").isValid)
    }

    func testValidPassword() {
        XCTAssertTrue(Validators.Password.validate("Password123!").isValid)
        XCTAssertTrue(Validators.Password.validate("MySecure@Pass1").isValid)
    }

    func testInvalidPassword() {
        XCTAssertFalse(Validators.Password.validate("").isValid)
        XCTAssertFalse(Validators.Password.validate("short").isValid)
        XCTAssertFalse(Validators.Password.validate("nouppercase1!").isValid)
        XCTAssertFalse(Validators.Password.validate("NOLOWERCASE1!").isValid)
        XCTAssertFalse(Validators.Password.validate("NoNumbers!").isValid)
    }

    func testValidThaiPhone() {
        XCTAssertTrue(Validators.PhoneNumber.validate("0812345678").isValid)
        XCTAssertTrue(Validators.PhoneNumber.validate("091-234-5678").isValid)
    }

    func testInvalidThaiPhone() {
        XCTAssertFalse(Validators.PhoneNumber.validate("12345678").isValid)
        XCTAssertFalse(Validators.PhoneNumber.validate("081234567").isValid)
        XCTAssertFalse(Validators.PhoneNumber.validate("08123456789").isValid)
    }

    func testValidName() {
        XCTAssertTrue(Validators.Name.validate("John").isValid)
        XCTAssertTrue(Validators.Name.validate("สมชาย").isValid)
        XCTAssertTrue(Validators.Name.validate("Mary Jane").isValid)
    }

    func testInvalidName() {
        XCTAssertFalse(Validators.Name.validate("").isValid)
        XCTAssertFalse(Validators.Name.validate("A").isValid)
    }
}

// MARK: - User Models Tests

final class UserModelsTests: MindcareBaseTestCase {
    func testUserProfileInitialization() {
        let profile = UserProfile(
            id: "user123",
            email: "test@example.com",
            name: "John Doe",
            avatar: nil,
            role: .patient,
            dateOfBirth: Date(),
            gender: .male,
            phoneNumber: nil,
            createdAt: Date(),
            updatedAt: Date(),
            height: 175,
            weight: 70,
            bloodType: "O",
            emergencyContact: nil
        )

        XCTAssertEqual(profile.id, "user123")
        XCTAssertEqual(profile.role, .patient)
        XCTAssertEqual(profile.gender, .male)
    }
}

// MARK: - Health Models Tests

final class HealthModelsTests: MindcareBaseTestCase {
    func testHealthMetricsInitialization() {
        let metrics = HealthMetrics(
            timestamp: Date(),
            heartRate: 72,
            hrv: nil,
            oxygenSaturation: nil,
            steps: 10_000,
            activeEnergy: nil,
            restingHeartRate: nil,
            vo2Max: nil,
            sleepHours: 7.5,
            sleepQuality: nil
        )

        XCTAssertEqual(metrics.heartRate, 72)
        XCTAssertEqual(metrics.steps, 10000)
        XCTAssertEqual(metrics.sleepHours, 7.5)
    }

    func testSleepDataDuration() {
        let start = Date()
        let end = start.addingTimeInterval(8 * 3600)
        let sleep = SleepData(startDate: start, endDate: end, stage: .rem)

        XCTAssertEqual(sleep.duration, 8 * 3600)
        XCTAssertEqual(sleep.stage, .rem)
    }
}

// MARK: - Mood Models Tests

final class MoodModelsTests: MindcareBaseTestCase {
    func testMoodEntryDerivedValues() {
        let entry = MoodEntry(
            id: "mood123",
            userId: "user123",
            moodLevel: 5,
            emotions: [.happy, .calm],
            activities: ["walk"],
            notes: "Feeling great",
            sleepQuality: 4,
            energyLevel: 4,
            stressLevel: 2,
            createdAt: Date()
        )

        XCTAssertEqual(entry.moodEmoji, "😄")
        XCTAssertEqual(entry.moodText, "Great")
        XCTAssertTrue(entry.emotions.contains(.happy))
    }
}

// MARK: - Chat Models Tests

final class ChatModelsTests: MindcareBaseTestCase {
    func testChatMessageInitialization() {
        let now = Date()
        let message = ChatMessage(
            id: "msg123",
            conversationId: "conv123",
            role: .user,
            content: "Hello",
            createdAt: now,
            isRead: false
        )

        XCTAssertEqual(message.role, .user)
        XCTAssertEqual(message.content, "Hello")
    }

    func testConversationInitialization() {
        let now = Date()
        let conversation = Conversation(
            id: "conv123",
            userId: "user1",
            title: "Chat",
            lastMessage: nil,
            messageCount: 0,
            createdAt: now,
            updatedAt: now
        )

        XCTAssertEqual(conversation.userId, "user1")
        XCTAssertEqual(conversation.messageCount, 0)
    }
}

// MARK: - Payment Models Tests

final class PaymentModelsTests: MindcareBaseTestCase {
    func testPaymentTransactionInitialization() {
        let txn = PaymentTransaction(
            id: "txn123",
            userId: "user123",
            amount: 1500,
            currency: "THB",
            status: .completed,
            paymentMethod: "apple_pay",
            paymentType: .consultation,
            description: "Consultation fee",
            metadata: nil,
            createdAt: Date(),
            updatedAt: Date()
        )

        XCTAssertEqual(txn.status, .completed)
        XCTAssertEqual(txn.paymentType, .consultation)
    }
}

// MARK: - Activity Models Tests

final class ActivityModelsTests: MindcareBaseTestCase {
    func testActivityInitialization() {
        let activity = Activity(
            id: "act123",
            title: "Morning Meditation",
            description: "A short breathing exercise",
            category: .meditation,
            duration: 10,
            difficulty: .easy,
            benefits: ["Reduce stress"],
            instructions: ["Breathe in", "Breathe out"],
            imageUrl: nil,
            videoUrl: nil,
            isCompleted: false
        )

        XCTAssertEqual(activity.category, .meditation)
        XCTAssertEqual(activity.difficulty, .easy)
    }
}

// MARK: - Appointment Models Tests

final class AppointmentModelsTests: MindcareBaseTestCase {
    func testAppointmentInitialization() {
        let start = Date().addingTimeInterval(3600)
        let appointment = Appointment(
            id: "apt123",
            patientId: "patient123",
            psychiatristId: "psych123",
            psychiatristName: "Dr. Smith",
            patientName: "John Doe",
            scheduledAt: start,
            duration: 60,
            type: .consultation,
            status: .scheduled,
            notes: nil,
            meetingUrl: nil,
            createdAt: Date()
        )

        XCTAssertEqual(appointment.status, .scheduled)
        XCTAssertTrue(appointment.isUpcoming)
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

    func testHealthEndpoints() {
        XCTAssertTrue(APIEndpoints.Health.metrics.contains("/health/metrics"))
        XCTAssertTrue(APIEndpoints.Health.sync.contains("/health/sync"))
        XCTAssertTrue(APIEndpoints.Health.history.contains("/health/history"))
    }
}

// MARK: - Logger Tests

final class LoggerTests: MindcareBaseTestCase {
    func testLoggerConvenienceFunctions() {
        // These should not crash when called
        logDebug("Debug message")
        logInfo("Info message")
        logWarning("Warning message")
        logError("Error message")
        XCTAssertTrue(true)
    }
}

// MARK: - Performance Tests

final class PerformanceTests: MindcareBaseTestCase {
    func testEmailValidationPerformance() {
        measure {
            for _ in 0..<500 {
                _ = Validators.Email.validate("test@example.com").isValid
            }
        }
    }

    func testPasswordValidationPerformance() {
        measure {
            for _ in 0..<500 {
                _ = Validators.Password.validate("Password123!").isValid
            }
        }
    }
}
