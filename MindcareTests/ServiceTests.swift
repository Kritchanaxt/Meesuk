//
//  ServiceTests.swift
//  MindcareTests
//
//  Created for MindCareAI Project
//

import XCTest
@testable import Mindcare

// MARK: - KeychainManager Tests
final class KeychainManagerTests: XCTestCase {
    
    let testKey = "test_key"
    let testValue = "test_value"
    
    override func tearDownWithError() throws {
        // Clean up test data
        _ = KeychainManager.shared.delete(key: testKey)
        try super.tearDownWithError()
    }
    
    func testSaveAndRetrieve() {
        XCTAssertTrue(KeychainManager.shared.save(key: testKey, value: testValue))
        let retrieved = KeychainManager.shared.get(key: testKey)
        XCTAssertEqual(retrieved, testValue)
    }
    
    func testDelete() {
        _ = KeychainManager.shared.save(key: testKey, value: testValue)
        XCTAssertTrue(KeychainManager.shared.delete(key: testKey))
        XCTAssertNil(KeychainManager.shared.get(key: testKey))
    }
    
    func testUpdate() {
        let newValue = "new_test_value"
        
        XCTAssertTrue(KeychainManager.shared.save(key: testKey, value: testValue))
        XCTAssertTrue(KeychainManager.shared.update(key: testKey, value: newValue))
        let retrieved = KeychainManager.shared.get(key: testKey)
        XCTAssertEqual(retrieved, newValue)
    }
}

// MARK: - AuthService Tests
final class AuthServiceTests: XCTestCase {
    
    var authService: AuthService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        authService = AuthService.shared
    }
    
    override func tearDownWithError() throws {
        // Logout after each test
        Task {
            await authService.logout()
        }
        try super.tearDownWithError()
    }
    
    func testInitialState() {
        // Initially should not be authenticated
        XCTAssertFalse(authService.isAuthenticated)
        XCTAssertNil(authService.currentUser)
    }
    
    func testLoginWithInvalidCredentials() async {
        do {
            _ = try await authService.login(email: "", password: "")
            XCTFail("Should throw error for empty credentials")
        } catch {
            // Expected behavior
            XCTAssertNotNil(error)
        }
    }
    
    func testEmailValidationOnLogin() async {
        do {
            _ = try await authService.login(email: "invalid-email", password: "password123")
            XCTFail("Should throw error for invalid email")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}

// MARK: - NetworkManager Tests
final class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkManager = NetworkManager.shared
    }
    
    func testNetworkManagerInitialization() {
        XCTAssertNotNil(networkManager)
    }
    
    func testBaseURLConfiguration() {
        let baseURL = APIEndpoints.baseURL
        XCTAssertFalse(baseURL.isEmpty)
        XCTAssertTrue(baseURL.hasPrefix("http"))
    }
}

// MARK: - HealthKitManager Tests
final class HealthKitManagerTests: XCTestCase {
    
    var healthKitManager: HealthKitManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        healthKitManager = HealthKitManager.shared
    }
    
    func testHealthKitManagerInitialization() {
        XCTAssertNotNil(healthKitManager)
    }
    
    func testHealthKitAvailability() {
        // This will vary by device/simulator
        let isAvailable = healthKitManager.isHealthDataAvailable
        // Just verify the property exists and returns a boolean
        XCTAssertNotNil(isAvailable)
    }
}

// MARK: - NotificationService Tests
final class NotificationServiceTests: XCTestCase {
    
    var notificationService: NotificationService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        notificationService = NotificationService.shared
    }
    
    func testNotificationServiceInitialization() {
        XCTAssertNotNil(notificationService)
    }
    
    func testNotificationCategoryTypes() {
        XCTAssertFalse(NotificationService.Category.healthAlert.rawValue.isEmpty)
        XCTAssertFalse(NotificationService.Category.reminder.rawValue.isEmpty)
        XCTAssertFalse(NotificationService.Category.chat.rawValue.isEmpty)
        XCTAssertFalse(NotificationService.Category.dailyCheckIn.rawValue.isEmpty)
    }
}

// MARK: - ApplePayManager Tests
final class ApplePayManagerTests: XCTestCase {
    
    func testMerchantIdentifierConfigured() {
        XCTAssertFalse(ApplePayManager.merchantIdentifier.isEmpty)
    }
    
    func testSupportedPaymentNetworks() {
        let networks = ApplePayManager.supportedNetworks
        XCTAssertFalse(networks.isEmpty)
        // Should at least support Visa and Mastercard
        XCTAssertTrue(networks.contains(.visa))
        XCTAssertTrue(networks.contains(.masterCard))
    }
}

// MARK: - WatchConnectivityManager Tests
final class WatchConnectivityManagerTests: XCTestCase {
    
    var watchManager: WatchConnectivityManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        watchManager = WatchConnectivityManager.shared
    }
    
    func testWatchConnectivityManagerInitialization() {
        XCTAssertNotNil(watchManager)
    }
}

// MARK: - CoreMotionManager Tests
final class CoreMotionManagerTests: XCTestCase {
    
    var motionManager: CoreMotionManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        motionManager = CoreMotionManager.shared
    }
    
    func testCoreMotionManagerInitialization() {
        XCTAssertNotNil(motionManager)
    }
}

// MARK: - AppEnvironment Tests
final class AppEnvironmentTests: XCTestCase {
    
    func testCurrentEnvironment() {
        let current = AppEnvironment.current
        XCTAssertNotNil(current)
    }
    
    func testEnvironmentBaseURL() {
        let baseURL = AppEnvironment.current.baseURL
        XCTAssertFalse(baseURL.isEmpty)
    }
    
    func testEnvironmentTypes() {
        // Verify all environment types exist
        XCTAssertNotNil(AppEnvironment.development)
        XCTAssertNotNil(AppEnvironment.staging)
        XCTAssertNotNil(AppEnvironment.production)
    }
    
    func testDevelopmentEnvironment() {
        let dev = AppEnvironment.development
        XCTAssertTrue(dev.baseURL.contains("localhost") || dev.baseURL.contains("dev"))
    }
}
