//
//  ViewModelTests.swift
//  MindcareTests
//
//  Created for MindCareAI Project
//

import XCTest
@testable import Mindcare

// MARK: - BaseViewModel Tests
final class BaseViewModelTests: XCTestCase {
    
    var viewModel: BaseViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = BaseViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    func testInitialState() {
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testSetLoading() {
        viewModel.isLoading = true
        XCTAssertTrue(viewModel.isLoading)
        
        viewModel.isLoading = false
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testSetError() {
        let errorMessage = "Test error message"
        viewModel.errorMessage = errorMessage
        viewModel.showError = true
        
        XCTAssertEqual(viewModel.errorMessage, errorMessage)
        XCTAssertTrue(viewModel.showError)
    }
    
    func testClearError() {
        viewModel.errorMessage = "Some error"
        viewModel.showError = true
        
        viewModel.clearError()
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
}

// MARK: - HealthViewModel Tests
final class HealthViewModelTests: XCTestCase {
    
    var viewModel: HealthViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = HealthViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    func testInitialState() {
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testHealthDataBinding() {
        // Test that health data properties can be accessed
        XCTAssertNotNil(viewModel.todaySteps)
        XCTAssertNotNil(viewModel.todayHeartRate)
        XCTAssertNotNil(viewModel.todaySleepHours)
    }
    
    func testStepsGoalProgress() {
        // Default goal is usually 10,000 steps
        viewModel.todaySteps = 5000
        let progress = viewModel.stepsProgress
        
        XCTAssertGreaterThanOrEqual(progress, 0.0)
        XCTAssertLessThanOrEqual(progress, 1.0)
    }
    
    func testSleepGoalProgress() {
        // Default goal is usually 8 hours
        viewModel.todaySleepHours = 6.0
        let progress = viewModel.sleepProgress
        
        XCTAssertGreaterThanOrEqual(progress, 0.0)
        XCTAssertLessThanOrEqual(progress, 1.0)
    }
}

// MARK: - Async ViewModel Tests
final class AsyncViewModelTests: XCTestCase {
    
    func testAsyncLoadingState() async throws {
        let viewModel = BaseViewModel()
        
        XCTAssertFalse(viewModel.isLoading)
        
        // Simulate async operation
        await MainActor.run {
            viewModel.isLoading = true
        }
        
        XCTAssertTrue(viewModel.isLoading)
        
        await MainActor.run {
            viewModel.isLoading = false
        }
        
        XCTAssertFalse(viewModel.isLoading)
    }
}
