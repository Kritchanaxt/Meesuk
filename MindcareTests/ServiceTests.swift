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
        try? KeychainManager.shared.delete(key: testKey)
        try super.tearDownWithError()
    }
    
    func testSaveAndRetrieve() throws {
        // Save
        try KeychainManager.shared.save(key: testKey, value: testValue)
        
        // Retrieve
        let retrieved = try KeychainManager.shared.retrieve(key: testKey)
        XCTAssertEqual(retrieved, testValue)
    }
    
    func testDelete() throws {
        // Save first
        try KeychainManager.shared.save(key: testKey, value: testValue)
        
        // Delete
        try KeychainManager.shared.delete(key: testKey)
        
        // Should throw or return nil
        XCTAssertThrowsError(try KeychainManager.shared.retrieve(key: testKey))
    }
    
    func testUpdate() throws {
        let newValue = "new_test_value"
        
        // Save initial value
        try KeychainManager.shared.save(key: testKey, value: testValue)
        
        // Update
        try KeychainManager.shared.save(key: testKey, value: newValue)
        
        // Verify update
        let retrieved = try KeychainManager.shared.retrieve(key: testKey)
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
            try? await authService.logout()
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
        // Verify notification categories are defined
        XCTAssertFalse(NotificationService.NotificationCategory.allCases.isEmpty)
    }
}

// MARK: - ApplePayManager Tests
final class ApplePayManagerTests: XCTestCase {
    
    var applePayManager: ApplePayManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        applePayManager = ApplePayManager.shared
    }
    
    func testApplePayManagerInitialization() {
        XCTAssertNotNil(applePayManager)
    }
    
    func testMerchantIdentifierConfigured() {
        // Verify merchant identifier is set
        XCTAssertFalse(applePayManager.merchantIdentifier.isEmpty)
    }
    
    func testSupportedPaymentNetworks() {
        let networks = applePayManager.supportedNetworks
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
