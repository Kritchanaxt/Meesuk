//
//  MindcareUITestsLaunchTests.swift
//  MindcareUITests
//
//  Created by Mr.Kritchant on 27/11/2568 BE.
//

import XCTest

final class MindcareUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Capture launch screen screenshot
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    @MainActor
    func testLaunchInDarkMode() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UIUserInterfaceStyleDark"]
        app.launch()
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen - Dark Mode"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    @MainActor
    func testLaunchInLightMode() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UIUserInterfaceStyleLight"]
        app.launch()
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen - Light Mode"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    @MainActor
    func testLaunchWithThaiLanguage() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(th)"]
        app.launch()
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen - Thai"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    @MainActor
    func testLaunchWithEnglishLanguage() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen - English"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    // MARK: - Device Orientation Tests
    
    @MainActor
    func testLaunchPortrait() throws {
        let app = XCUIApplication()
        XCUIDevice.shared.orientation = .portrait
        app.launch()
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen - Portrait"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    @MainActor
    func testLaunchLandscape() throws {
        let app = XCUIApplication()
        XCUIDevice.shared.orientation = .landscapeLeft
        app.launch()
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen - Landscape"
        attachment.lifetime = .keepAlways
        add(attachment)
        
        // Reset to portrait
        XCUIDevice.shared.orientation = .portrait
    }
}
