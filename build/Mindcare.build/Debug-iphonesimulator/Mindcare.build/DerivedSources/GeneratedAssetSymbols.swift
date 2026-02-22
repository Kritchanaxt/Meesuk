import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "Admin" asset catalog image resource.
    static let admin = DeveloperToolsSupport.ImageResource(name: "Admin", bundle: resourceBundle)

    /// The "Ai_icon" asset catalog image resource.
    static let aiIcon = DeveloperToolsSupport.ImageResource(name: "Ai_icon", bundle: resourceBundle)

    /// The "Background" asset catalog image resource.
    static let background = DeveloperToolsSupport.ImageResource(name: "Background", bundle: resourceBundle)

    /// The "Background-Page3" asset catalog image resource.
    static let backgroundPage3 = DeveloperToolsSupport.ImageResource(name: "Background-Page3", bundle: resourceBundle)

    /// The "Chat_Or" asset catalog image resource.
    static let chatOr = DeveloperToolsSupport.ImageResource(name: "Chat_Or", bundle: resourceBundle)

    /// The "Chat_gray" asset catalog image resource.
    static let chatGray = DeveloperToolsSupport.ImageResource(name: "Chat_gray", bundle: resourceBundle)

    /// The "Credentrails" asset catalog image resource.
    static let credentrails = DeveloperToolsSupport.ImageResource(name: "Credentrails", bundle: resourceBundle)

    /// The "Doctor" asset catalog image resource.
    static let doctor = DeveloperToolsSupport.ImageResource(name: "Doctor", bundle: resourceBundle)

    /// The "Dr" asset catalog image resource.
    static let dr = DeveloperToolsSupport.ImageResource(name: "Dr", bundle: resourceBundle)

    /// The "Dr_img" asset catalog image resource.
    static let drImg = DeveloperToolsSupport.ImageResource(name: "Dr_img", bundle: resourceBundle)

    /// The "EN" asset catalog image resource.
    static let EN = DeveloperToolsSupport.ImageResource(name: "EN", bundle: resourceBundle)

    /// The "Emergency" asset catalog image resource.
    static let emergency = DeveloperToolsSupport.ImageResource(name: "Emergency", bundle: resourceBundle)

    /// The "Facebook Icon" asset catalog image resource.
    static let facebookIcon = DeveloperToolsSupport.ImageResource(name: "Facebook Icon", bundle: resourceBundle)

    /// The "Google Icon" asset catalog image resource.
    static let googleIcon = DeveloperToolsSupport.ImageResource(name: "Google Icon", bundle: resourceBundle)

    /// The "Graph_Optional" asset catalog image resource.
    static let graphOptional = DeveloperToolsSupport.ImageResource(name: "Graph_Optional", bundle: resourceBundle)

    /// The "HRV" asset catalog image resource.
    static let HRV = DeveloperToolsSupport.ImageResource(name: "HRV", bundle: resourceBundle)

    /// The "HeartRate" asset catalog image resource.
    static let heartRate = DeveloperToolsSupport.ImageResource(name: "HeartRate", bundle: resourceBundle)

    /// The "Home" asset catalog image resource.
    static let home = DeveloperToolsSupport.ImageResource(name: "Home", bundle: resourceBundle)

    /// The "Home_gray" asset catalog image resource.
    static let homeGray = DeveloperToolsSupport.ImageResource(name: "Home_gray", bundle: resourceBundle)

    /// The "Icon" asset catalog image resource.
    static let icon = DeveloperToolsSupport.ImageResource(name: "Icon", bundle: resourceBundle)

    /// The "Icon-1" asset catalog image resource.
    static let icon1 = DeveloperToolsSupport.ImageResource(name: "Icon-1", bundle: resourceBundle)

    /// The "Journey-1" asset catalog image resource.
    static let journey1 = DeveloperToolsSupport.ImageResource(name: "Journey-1", bundle: resourceBundle)

    /// The "Journey-2" asset catalog image resource.
    static let journey2 = DeveloperToolsSupport.ImageResource(name: "Journey-2", bundle: resourceBundle)

    /// The "Journey-3" asset catalog image resource.
    static let journey3 = DeveloperToolsSupport.ImageResource(name: "Journey-3", bundle: resourceBundle)

    /// The "Line 1" asset catalog image resource.
    static let line1 = DeveloperToolsSupport.ImageResource(name: "Line 1", bundle: resourceBundle)

    /// The "Location" asset catalog image resource.
    static let location = DeveloperToolsSupport.ImageResource(name: "Location", bundle: resourceBundle)

    /// The "Logo" asset catalog image resource.
    static let logo = DeveloperToolsSupport.ImageResource(name: "Logo", bundle: resourceBundle)

    /// The "MEESUK" asset catalog image resource.
    static let MEESUK = DeveloperToolsSupport.ImageResource(name: "MEESUK", bundle: resourceBundle)

    /// The "MEESUK-B" asset catalog image resource.
    static let MEESUK_B = DeveloperToolsSupport.ImageResource(name: "MEESUK-B", bundle: resourceBundle)

    /// The "MeeSukThai" asset catalog image resource.
    static let meeSukThai = DeveloperToolsSupport.ImageResource(name: "MeeSukThai", bundle: resourceBundle)

    /// The "Mee_Good" asset catalog image resource.
    static let meeGood = DeveloperToolsSupport.ImageResource(name: "Mee_Good", bundle: resourceBundle)

    /// The "Mee_Great" asset catalog image resource.
    static let meeGreat = DeveloperToolsSupport.ImageResource(name: "Mee_Great", bundle: resourceBundle)

    /// The "Mee_Low" asset catalog image resource.
    static let meeLow = DeveloperToolsSupport.ImageResource(name: "Mee_Low", bundle: resourceBundle)

    /// The "Mee_Okay" asset catalog image resource.
    static let meeOkay = DeveloperToolsSupport.ImageResource(name: "Mee_Okay", bundle: resourceBundle)

    /// The "Microphone Icon" asset catalog image resource.
    static let microphoneIcon = DeveloperToolsSupport.ImageResource(name: "Microphone Icon", bundle: resourceBundle)

    /// The "Notification" asset catalog image resource.
    static let notification = DeveloperToolsSupport.ImageResource(name: "Notification", bundle: resourceBundle)

    /// The "P1" asset catalog image resource.
    static let P_1 = DeveloperToolsSupport.ImageResource(name: "P1", bundle: resourceBundle)

    /// The "P1.1" asset catalog image resource.
    static let P_1_1 = DeveloperToolsSupport.ImageResource(name: "P1.1", bundle: resourceBundle)

    /// The "P1.2" asset catalog image resource.
    static let P_1_2 = DeveloperToolsSupport.ImageResource(name: "P1.2", bundle: resourceBundle)

    /// The "P1.3" asset catalog image resource.
    static let P_1_3 = DeveloperToolsSupport.ImageResource(name: "P1.3", bundle: resourceBundle)

    /// The "P2" asset catalog image resource.
    static let P_2 = DeveloperToolsSupport.ImageResource(name: "P2", bundle: resourceBundle)

    /// The "P3" asset catalog image resource.
    static let P_3 = DeveloperToolsSupport.ImageResource(name: "P3", bundle: resourceBundle)

    /// The "P4" asset catalog image resource.
    static let P_4 = DeveloperToolsSupport.ImageResource(name: "P4", bundle: resourceBundle)

    /// The "Patient" asset catalog image resource.
    static let patient = DeveloperToolsSupport.ImageResource(name: "Patient", bundle: resourceBundle)

    /// The "Personal" asset catalog image resource.
    static let personal = DeveloperToolsSupport.ImageResource(name: "Personal", bundle: resourceBundle)

    /// The "Profile" asset catalog image resource.
    static let profile = DeveloperToolsSupport.ImageResource(name: "Profile", bundle: resourceBundle)

    /// The "Profile_Or" asset catalog image resource.
    static let profileOr = DeveloperToolsSupport.ImageResource(name: "Profile_Or", bundle: resourceBundle)

    /// The "Profile_gray" asset catalog image resource.
    static let profileGray = DeveloperToolsSupport.ImageResource(name: "Profile_gray", bundle: resourceBundle)

    /// The "Psychiatrist_Or" asset catalog image resource.
    static let psychiatristOr = DeveloperToolsSupport.ImageResource(name: "Psychiatrist_Or", bundle: resourceBundle)

    /// The "Psychiatrist_gray" asset catalog image resource.
    static let psychiatristGray = DeveloperToolsSupport.ImageResource(name: "Psychiatrist_gray", bundle: resourceBundle)

    /// The "Request" asset catalog image resource.
    static let request = DeveloperToolsSupport.ImageResource(name: "Request", bundle: resourceBundle)

    /// The "Send Icon" asset catalog image resource.
    static let sendIcon = DeveloperToolsSupport.ImageResource(name: "Send Icon", bundle: resourceBundle)

    /// The "Setting" asset catalog image resource.
    static let setting = DeveloperToolsSupport.ImageResource(name: "Setting", bundle: resourceBundle)

    /// The "Show Off" asset catalog image resource.
    static let showOff = DeveloperToolsSupport.ImageResource(name: "Show Off", bundle: resourceBundle)

    /// The "Sleep" asset catalog image resource.
    static let sleep = DeveloperToolsSupport.ImageResource(name: "Sleep", bundle: resourceBundle)

    /// The "Stress" asset catalog image resource.
    static let stress = DeveloperToolsSupport.ImageResource(name: "Stress", bundle: resourceBundle)

    /// The "Subcription" asset catalog image resource.
    static let subcription = DeveloperToolsSupport.ImageResource(name: "Subcription", bundle: resourceBundle)

    /// The "Verify" asset catalog image resource.
    static let verify = DeveloperToolsSupport.ImageResource(name: "Verify", bundle: resourceBundle)

    /// The "chat" asset catalog image resource.
    static let chat = DeveloperToolsSupport.ImageResource(name: "chat", bundle: resourceBundle)

    /// The "logo-ku" asset catalog image resource.
    static let logoKu = DeveloperToolsSupport.ImageResource(name: "logo-ku", bundle: resourceBundle)

    /// The "logo-meesuk" asset catalog image resource.
    static let logoMeesuk = DeveloperToolsSupport.ImageResource(name: "logo-meesuk", bundle: resourceBundle)

    /// The "protect" asset catalog image resource.
    static let protect = DeveloperToolsSupport.ImageResource(name: "protect", bundle: resourceBundle)

    /// The "signout" asset catalog image resource.
    static let signout = DeveloperToolsSupport.ImageResource(name: "signout", bundle: resourceBundle)

    /// The "หมีสุข" asset catalog image resource.
    static let หมีสุข = DeveloperToolsSupport.ImageResource(name: "หมีสุข", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "Admin" asset catalog image.
    static var admin: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .admin)
#else
        .init()
#endif
    }

    /// The "Ai_icon" asset catalog image.
    static var aiIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .aiIcon)
#else
        .init()
#endif
    }

    /// The "Background" asset catalog image.
    static var background: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .background)
#else
        .init()
#endif
    }

    /// The "Background-Page3" asset catalog image.
    static var backgroundPage3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .backgroundPage3)
#else
        .init()
#endif
    }

    /// The "Chat_Or" asset catalog image.
    static var chatOr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chatOr)
#else
        .init()
#endif
    }

    /// The "Chat_gray" asset catalog image.
    static var chatGray: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chatGray)
#else
        .init()
#endif
    }

    /// The "Credentrails" asset catalog image.
    static var credentrails: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .credentrails)
#else
        .init()
#endif
    }

    /// The "Doctor" asset catalog image.
    static var doctor: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .doctor)
#else
        .init()
#endif
    }

    /// The "Dr" asset catalog image.
    static var dr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dr)
#else
        .init()
#endif
    }

    /// The "Dr_img" asset catalog image.
    static var drImg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .drImg)
#else
        .init()
#endif
    }

    /// The "EN" asset catalog image.
    static var EN: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .EN)
#else
        .init()
#endif
    }

    /// The "Emergency" asset catalog image.
    static var emergency: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emergency)
#else
        .init()
#endif
    }

    /// The "Facebook Icon" asset catalog image.
    static var facebookIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .facebookIcon)
#else
        .init()
#endif
    }

    /// The "Google Icon" asset catalog image.
    static var googleIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .googleIcon)
#else
        .init()
#endif
    }

    /// The "Graph_Optional" asset catalog image.
    static var graphOptional: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .graphOptional)
#else
        .init()
#endif
    }

    /// The "HRV" asset catalog image.
    static var HRV: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .HRV)
#else
        .init()
#endif
    }

    /// The "HeartRate" asset catalog image.
    static var heartRate: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .heartRate)
#else
        .init()
#endif
    }

    /// The "Home" asset catalog image.
    static var home: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .home)
#else
        .init()
#endif
    }

    /// The "Home_gray" asset catalog image.
    static var homeGray: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .homeGray)
#else
        .init()
#endif
    }

    /// The "Icon" asset catalog image.
    static var icon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .icon)
#else
        .init()
#endif
    }

    /// The "Icon-1" asset catalog image.
    static var icon1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .icon1)
#else
        .init()
#endif
    }

    /// The "Journey-1" asset catalog image.
    static var journey1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .journey1)
#else
        .init()
#endif
    }

    /// The "Journey-2" asset catalog image.
    static var journey2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .journey2)
#else
        .init()
#endif
    }

    /// The "Journey-3" asset catalog image.
    static var journey3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .journey3)
#else
        .init()
#endif
    }

    /// The "Line 1" asset catalog image.
    static var line1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .line1)
#else
        .init()
#endif
    }

    /// The "Location" asset catalog image.
    static var location: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .location)
#else
        .init()
#endif
    }

    /// The "Logo" asset catalog image.
    static var logo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logo)
#else
        .init()
#endif
    }

    /// The "MEESUK" asset catalog image.
    static var MEESUK: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .MEESUK)
#else
        .init()
#endif
    }

    /// The "MEESUK-B" asset catalog image.
    static var MEESUK_B: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .MEESUK_B)
#else
        .init()
#endif
    }

    /// The "MeeSukThai" asset catalog image.
    static var meeSukThai: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .meeSukThai)
#else
        .init()
#endif
    }

    /// The "Mee_Good" asset catalog image.
    static var meeGood: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .meeGood)
#else
        .init()
#endif
    }

    /// The "Mee_Great" asset catalog image.
    static var meeGreat: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .meeGreat)
#else
        .init()
#endif
    }

    /// The "Mee_Low" asset catalog image.
    static var meeLow: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .meeLow)
#else
        .init()
#endif
    }

    /// The "Mee_Okay" asset catalog image.
    static var meeOkay: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .meeOkay)
#else
        .init()
#endif
    }

    /// The "Microphone Icon" asset catalog image.
    static var microphoneIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .microphoneIcon)
#else
        .init()
#endif
    }

    /// The "Notification" asset catalog image.
    static var notification: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .notification)
#else
        .init()
#endif
    }

    /// The "P1" asset catalog image.
    static var P_1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .P_1)
#else
        .init()
#endif
    }

    /// The "P1.1" asset catalog image.
    static var P_1_1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .P_1_1)
#else
        .init()
#endif
    }

    /// The "P1.2" asset catalog image.
    static var P_1_2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .P_1_2)
#else
        .init()
#endif
    }

    /// The "P1.3" asset catalog image.
    static var P_1_3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .P_1_3)
#else
        .init()
#endif
    }

    /// The "P2" asset catalog image.
    static var P_2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .P_2)
#else
        .init()
#endif
    }

    /// The "P3" asset catalog image.
    static var P_3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .P_3)
#else
        .init()
#endif
    }

    /// The "P4" asset catalog image.
    static var P_4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .P_4)
#else
        .init()
#endif
    }

    /// The "Patient" asset catalog image.
    static var patient: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .patient)
#else
        .init()
#endif
    }

    /// The "Personal" asset catalog image.
    static var personal: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .personal)
#else
        .init()
#endif
    }

    /// The "Profile" asset catalog image.
    static var profile: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .profile)
#else
        .init()
#endif
    }

    /// The "Profile_Or" asset catalog image.
    static var profileOr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .profileOr)
#else
        .init()
#endif
    }

    /// The "Profile_gray" asset catalog image.
    static var profileGray: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .profileGray)
#else
        .init()
#endif
    }

    /// The "Psychiatrist_Or" asset catalog image.
    static var psychiatristOr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .psychiatristOr)
#else
        .init()
#endif
    }

    /// The "Psychiatrist_gray" asset catalog image.
    static var psychiatristGray: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .psychiatristGray)
#else
        .init()
#endif
    }

    /// The "Request" asset catalog image.
    static var request: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .request)
#else
        .init()
#endif
    }

    /// The "Send Icon" asset catalog image.
    static var sendIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sendIcon)
#else
        .init()
#endif
    }

    /// The "Setting" asset catalog image.
    static var setting: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .setting)
#else
        .init()
#endif
    }

    /// The "Show Off" asset catalog image.
    static var showOff: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .showOff)
#else
        .init()
#endif
    }

    /// The "Sleep" asset catalog image.
    static var sleep: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sleep)
#else
        .init()
#endif
    }

    /// The "Stress" asset catalog image.
    static var stress: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .stress)
#else
        .init()
#endif
    }

    /// The "Subcription" asset catalog image.
    static var subcription: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .subcription)
#else
        .init()
#endif
    }

    /// The "Verify" asset catalog image.
    static var verify: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .verify)
#else
        .init()
#endif
    }

    /// The "chat" asset catalog image.
    static var chat: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chat)
#else
        .init()
#endif
    }

    /// The "logo-ku" asset catalog image.
    static var logoKu: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoKu)
#else
        .init()
#endif
    }

    /// The "logo-meesuk" asset catalog image.
    static var logoMeesuk: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoMeesuk)
#else
        .init()
#endif
    }

    /// The "protect" asset catalog image.
    static var protect: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .protect)
#else
        .init()
#endif
    }

    /// The "signout" asset catalog image.
    static var signout: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .signout)
#else
        .init()
#endif
    }

    /// The "หมีสุข" asset catalog image.
    static var หมีสุข: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .หมีสุข)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "Admin" asset catalog image.
    static var admin: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .admin)
#else
        .init()
#endif
    }

    /// The "Ai_icon" asset catalog image.
    static var aiIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .aiIcon)
#else
        .init()
#endif
    }

    /// The "Background" asset catalog image.
    static var background: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .background)
#else
        .init()
#endif
    }

    /// The "Background-Page3" asset catalog image.
    static var backgroundPage3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .backgroundPage3)
#else
        .init()
#endif
    }

    /// The "Chat_Or" asset catalog image.
    static var chatOr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chatOr)
#else
        .init()
#endif
    }

    /// The "Chat_gray" asset catalog image.
    static var chatGray: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chatGray)
#else
        .init()
#endif
    }

    /// The "Credentrails" asset catalog image.
    static var credentrails: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .credentrails)
#else
        .init()
#endif
    }

    /// The "Doctor" asset catalog image.
    static var doctor: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .doctor)
#else
        .init()
#endif
    }

    /// The "Dr" asset catalog image.
    static var dr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dr)
#else
        .init()
#endif
    }

    /// The "Dr_img" asset catalog image.
    static var drImg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .drImg)
#else
        .init()
#endif
    }

    /// The "EN" asset catalog image.
    static var EN: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .EN)
#else
        .init()
#endif
    }

    /// The "Emergency" asset catalog image.
    static var emergency: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emergency)
#else
        .init()
#endif
    }

    /// The "Facebook Icon" asset catalog image.
    static var facebookIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .facebookIcon)
#else
        .init()
#endif
    }

    /// The "Google Icon" asset catalog image.
    static var googleIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .googleIcon)
#else
        .init()
#endif
    }

    /// The "Graph_Optional" asset catalog image.
    static var graphOptional: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .graphOptional)
#else
        .init()
#endif
    }

    /// The "HRV" asset catalog image.
    static var HRV: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .HRV)
#else
        .init()
#endif
    }

    /// The "HeartRate" asset catalog image.
    static var heartRate: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .heartRate)
#else
        .init()
#endif
    }

    /// The "Home" asset catalog image.
    static var home: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .home)
#else
        .init()
#endif
    }

    /// The "Home_gray" asset catalog image.
    static var homeGray: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .homeGray)
#else
        .init()
#endif
    }

    /// The "Icon" asset catalog image.
    static var icon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .icon)
#else
        .init()
#endif
    }

    /// The "Icon-1" asset catalog image.
    static var icon1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .icon1)
#else
        .init()
#endif
    }

    /// The "Journey-1" asset catalog image.
    static var journey1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .journey1)
#else
        .init()
#endif
    }

    /// The "Journey-2" asset catalog image.
    static var journey2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .journey2)
#else
        .init()
#endif
    }

    /// The "Journey-3" asset catalog image.
    static var journey3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .journey3)
#else
        .init()
#endif
    }

    /// The "Line 1" asset catalog image.
    static var line1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .line1)
#else
        .init()
#endif
    }

    /// The "Location" asset catalog image.
    static var location: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .location)
#else
        .init()
#endif
    }

    /// The "Logo" asset catalog image.
    static var logo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logo)
#else
        .init()
#endif
    }

    /// The "MEESUK" asset catalog image.
    static var MEESUK: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .MEESUK)
#else
        .init()
#endif
    }

    /// The "MEESUK-B" asset catalog image.
    static var MEESUK_B: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .MEESUK_B)
#else
        .init()
#endif
    }

    /// The "MeeSukThai" asset catalog image.
    static var meeSukThai: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .meeSukThai)
#else
        .init()
#endif
    }

    /// The "Mee_Good" asset catalog image.
    static var meeGood: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .meeGood)
#else
        .init()
#endif
    }

    /// The "Mee_Great" asset catalog image.
    static var meeGreat: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .meeGreat)
#else
        .init()
#endif
    }

    /// The "Mee_Low" asset catalog image.
    static var meeLow: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .meeLow)
#else
        .init()
#endif
    }

    /// The "Mee_Okay" asset catalog image.
    static var meeOkay: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .meeOkay)
#else
        .init()
#endif
    }

    /// The "Microphone Icon" asset catalog image.
    static var microphoneIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .microphoneIcon)
#else
        .init()
#endif
    }

    /// The "Notification" asset catalog image.
    static var notification: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .notification)
#else
        .init()
#endif
    }

    /// The "P1" asset catalog image.
    static var P_1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .P_1)
#else
        .init()
#endif
    }

    /// The "P1.1" asset catalog image.
    static var P_1_1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .P_1_1)
#else
        .init()
#endif
    }

    /// The "P1.2" asset catalog image.
    static var P_1_2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .P_1_2)
#else
        .init()
#endif
    }

    /// The "P1.3" asset catalog image.
    static var P_1_3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .P_1_3)
#else
        .init()
#endif
    }

    /// The "P2" asset catalog image.
    static var P_2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .P_2)
#else
        .init()
#endif
    }

    /// The "P3" asset catalog image.
    static var P_3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .P_3)
#else
        .init()
#endif
    }

    /// The "P4" asset catalog image.
    static var P_4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .P_4)
#else
        .init()
#endif
    }

    /// The "Patient" asset catalog image.
    static var patient: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .patient)
#else
        .init()
#endif
    }

    /// The "Personal" asset catalog image.
    static var personal: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .personal)
#else
        .init()
#endif
    }

    /// The "Profile" asset catalog image.
    static var profile: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .profile)
#else
        .init()
#endif
    }

    /// The "Profile_Or" asset catalog image.
    static var profileOr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .profileOr)
#else
        .init()
#endif
    }

    /// The "Profile_gray" asset catalog image.
    static var profileGray: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .profileGray)
#else
        .init()
#endif
    }

    /// The "Psychiatrist_Or" asset catalog image.
    static var psychiatristOr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .psychiatristOr)
#else
        .init()
#endif
    }

    /// The "Psychiatrist_gray" asset catalog image.
    static var psychiatristGray: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .psychiatristGray)
#else
        .init()
#endif
    }

    /// The "Request" asset catalog image.
    static var request: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .request)
#else
        .init()
#endif
    }

    /// The "Send Icon" asset catalog image.
    static var sendIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sendIcon)
#else
        .init()
#endif
    }

    /// The "Setting" asset catalog image.
    static var setting: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .setting)
#else
        .init()
#endif
    }

    /// The "Show Off" asset catalog image.
    static var showOff: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .showOff)
#else
        .init()
#endif
    }

    /// The "Sleep" asset catalog image.
    static var sleep: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sleep)
#else
        .init()
#endif
    }

    /// The "Stress" asset catalog image.
    static var stress: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .stress)
#else
        .init()
#endif
    }

    /// The "Subcription" asset catalog image.
    static var subcription: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .subcription)
#else
        .init()
#endif
    }

    /// The "Verify" asset catalog image.
    static var verify: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .verify)
#else
        .init()
#endif
    }

    /// The "chat" asset catalog image.
    static var chat: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chat)
#else
        .init()
#endif
    }

    /// The "logo-ku" asset catalog image.
    static var logoKu: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoKu)
#else
        .init()
#endif
    }

    /// The "logo-meesuk" asset catalog image.
    static var logoMeesuk: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoMeesuk)
#else
        .init()
#endif
    }

    /// The "protect" asset catalog image.
    static var protect: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .protect)
#else
        .init()
#endif
    }

    /// The "signout" asset catalog image.
    static var signout: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .signout)
#else
        .init()
#endif
    }

    /// The "หมีสุข" asset catalog image.
    static var หมีสุข: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .หมีสุข)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

