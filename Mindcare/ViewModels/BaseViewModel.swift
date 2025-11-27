//
//  BaseViewModel.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation
import Combine

/// Base ViewModel สำหรับ Features ทั่วไป
@MainActor
class BaseViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Cancellables
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Error Handling
    
    func handleError(_ error: Error) {
        isLoading = false
        errorMessage = error.localizedDescription
        showError = true
        logError(error.localizedDescription)
    }
    
    func clearError() {
        errorMessage = nil
        showError = false
    }
    
    // MARK: - Loading State
    
    func startLoading() {
        isLoading = true
        clearError()
    }
    
    func stopLoading() {
        isLoading = false
    }
    
    // MARK: - Async Task Wrapper
    
    func performTask(_ task: @escaping () async throws -> Void) {
        Task {
            startLoading()
            do {
                try await task()
                stopLoading()
            } catch {
                handleError(error)
            }
        }
    }
}
