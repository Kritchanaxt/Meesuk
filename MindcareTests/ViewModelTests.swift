//
//  ViewModelTests.swift
//  MindcareTests
//
//  Created for MindCareAI Project
//

import XCTest
@testable import Mindcare

// MARK: - BaseViewModel Tests
@MainActor
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
@MainActor
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
        XCTAssertNil(viewModel.healthMetrics)
        XCTAssertTrue(viewModel.heartRateHistory.isEmpty)
        XCTAssertTrue(viewModel.stepsHistory.isEmpty)
    }
}

// MARK: - Async ViewModel Tests
@MainActor
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
