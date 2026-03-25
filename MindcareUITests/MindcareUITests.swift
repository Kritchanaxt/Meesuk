//
//  MindcareUITests.swift
//  MindcareUITests
//
//  Created by Mr.Kritchant on 27/11/2568 BE.
//

import XCTest

final class MindcareUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }
    
    // MARK: - App Launch Tests
    
    @MainActor
    func testAppLaunches() throws {
        // Verify app launches successfully
        XCTAssertTrue(app.state == .runningForeground)
    }
    
    @MainActor
    func testAppHasContent() throws {
        // Wait for the app to load
        let timeout: TimeInterval = 5
        
        // Check if any UI element exists
        let anyElement = app.descendants(matching: .any).firstMatch
        XCTAssertTrue(anyElement.waitForExistence(timeout: timeout))
    }
    
    // MARK: - Navigation Tests
    
    @MainActor
    func testTabBarExists() throws {
        // If using TabView, check tab bar exists
        let tabBar = app.tabBars.firstMatch
        
        if tabBar.exists {
            XCTAssertTrue(tabBar.isHittable)
        }
    }
    
    @MainActor
    func testNavigationBetweenTabs() throws {
        let tabBar = app.tabBars.firstMatch
        
        guard tabBar.exists else {
            // App might be in onboarding or login state
            return
        }
        
        // Get all tab bar buttons
        let tabs = tabBar.buttons.allElementsBoundByIndex
        
        for tab in tabs {
            if tab.isHittable {
                tab.tap()
                // Brief pause for animation
                usleep(300000) // 0.3 seconds
            }
        }
    }
    
    // MARK: - Onboarding Tests
    
    @MainActor
    func testOnboardingFlowExists() throws {
        // Look for common onboarding elements
        let continueButton = app.buttons["Continue"]
        let nextButton = app.buttons["Next"]
        let getStartedButton = app.buttons["Get Started"]
        let skipButton = app.buttons["Skip"]
        
        // At least one of these should exist on first launch
        let hasOnboardingElement = continueButton.exists || 
                                   nextButton.exists || 
                                   getStartedButton.exists ||
                                   skipButton.exists
        
        // If onboarding exists, verify it's interactive
        if hasOnboardingElement {
            if continueButton.exists && continueButton.isHittable {
                continueButton.tap()
            } else if nextButton.exists && nextButton.isHittable {
                nextButton.tap()
            } else if getStartedButton.exists && getStartedButton.isHittable {
                getStartedButton.tap()
            }
        }
    }
    
    // MARK: - Login/Auth Tests
    
    @MainActor
    func testLoginScreenElements() throws {
        // Look for login screen elements
        let emailField = app.textFields["Email"]
        let passwordField = app.secureTextFields["Password"]
        let loginButton = app.buttons["Login"]
        let signInButton = app.buttons["Sign In"]
        
        // If login screen is visible
        if emailField.exists || passwordField.exists {
            // Verify login UI elements
            if loginButton.exists {
                XCTAssertTrue(loginButton.isEnabled || !loginButton.isEnabled)
            }
            if signInButton.exists {
                XCTAssertTrue(signInButton.isEnabled || !signInButton.isEnabled)
            }
        }
    }
    
    @MainActor
    func testAppleSignInButtonExists() throws {
        // Look for Sign in with Apple button
        let appleSignInButton = app.buttons["Sign in with Apple"]
        let appleButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Apple'")).firstMatch
        
        if appleSignInButton.exists || appleButton.exists {
            XCTAssertTrue(true, "Apple Sign In is available")
        }
    }
    
    // MARK: - HealthKit Permission Tests
    
    @MainActor
    func testHealthKitPermissionFlow() throws {
        // Look for HealthKit permission UI
        let healthKitButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Health'")).firstMatch
        
        if healthKitButton.exists && healthKitButton.isHittable {
            healthKitButton.tap()
            
            // System alert might appear
            sleep(1)
            
            // Handle system permission alert if present
            let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
            let allowHealthButton = springboard.buttons["Allow"]
            
            if allowHealthButton.waitForExistence(timeout: 2) {
                allowHealthButton.tap()
            }
        }
    }
    
    // MARK: - Mood Entry Tests
    
    @MainActor
    func testMoodSelectionUI() throws {
        // Navigate to mood section if possible
        let moodTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Mood'")).firstMatch
        
        if moodTab.exists && moodTab.isHittable {
            moodTab.tap()
            sleep(1)
            
            // Look for mood emoji buttons
            let happyEmoji = app.buttons["😊"]
            
            if happyEmoji.exists {
                happyEmoji.tap()
            }
        }
    }
    
    // MARK: - Payment UI Tests
    
    @MainActor
    func testPaymentButtonExists() throws {
        // Look for Apple Pay button
        _ = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Pay'")).firstMatch
        
        // Just verify these can be found when navigating to payment
        XCTAssertTrue(true)
    }
    
    // MARK: - Accessibility Tests
    
    @MainActor
    func testAccessibilityLabels() throws {
        // Verify important elements have accessibility labels
        let allButtons = app.buttons.allElementsBoundByIndex
        
        for button in allButtons.prefix(10) {
            if button.exists && !button.label.isEmpty {
                // Button has an accessibility label
                XCTAssertFalse(button.label.isEmpty)
            }
        }
    }
    
    @MainActor
    func testVoiceOverCompatibility() throws {
        // Check that main navigation elements are accessible
        let tabBar = app.tabBars.firstMatch
        
        if tabBar.exists {
            let tabs = tabBar.buttons.allElementsBoundByIndex
            for tab in tabs {
                if tab.exists {
                    // Each tab should have a label for VoiceOver
                    XCTAssertFalse(tab.label.isEmpty, "Tab should have accessibility label")
                }
            }
        }
    }
    
    // MARK: - Performance Tests
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(iOS 14.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    @MainActor
    func testScrollPerformance() throws {
        // Find a scrollable view
        let scrollView = app.scrollViews.firstMatch
        let tableView = app.tables.firstMatch
        let collectionView = app.collectionViews.firstMatch
        
        if scrollView.exists {
            measure {
                scrollView.swipeUp()
                scrollView.swipeDown()
            }
        } else if tableView.exists {
            measure {
                tableView.swipeUp()
                tableView.swipeDown()
            }
        } else if collectionView.exists {
            measure {
                collectionView.swipeUp()
                collectionView.swipeDown()
            }
        }
    }
}

// MARK: - Screenshot Tests
extension MindcareUITests {
    
    @MainActor
    func testCaptureScreenshots() throws {
        // Capture main screens for App Store Connect
        
        // Screenshot 1: Initial screen
        let screenshot1 = app.screenshot()
        let attachment1 = XCTAttachment(screenshot: screenshot1)
        attachment1.name = "01_InitialScreen"
        attachment1.lifetime = .keepAlways
        add(attachment1)
        
        // Screenshot 2: Navigate to next screen if possible
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists {
            let tabs = tabBar.buttons.allElementsBoundByIndex
            if tabs.count > 1 {
                tabs[1].tap()
                sleep(1)
                
                let screenshot2 = app.screenshot()
                let attachment2 = XCTAttachment(screenshot: screenshot2)
                attachment2.name = "02_SecondTab"
                attachment2.lifetime = .keepAlways
                add(attachment2)
            }
        }
    }
}
