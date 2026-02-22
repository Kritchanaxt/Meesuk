//
//  Extensions.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation
import SwiftUI

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

// MARK: - Date Extensions

extension Date {

    /// วันนี้เริ่มต้น
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// สิ้นสุดวัน
    var endOfDay: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
    }

    /// วันก่อนหน้า
    func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: self)!
    }

    /// Format เป็น String
    func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "th_TH")
        return formatter.string(from: self)
    }

    /// Relative time string
    var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    /// ตรวจสอบว่าเป็นวันนี้หรือไม่
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// ตรวจสอบว่าเป็นเมื่อวานหรือไม่
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    /// ตรวจสอบว่าอยู่ในสัปดาห์นี้หรือไม่
    var isThisWeek: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
}

// MARK: - String Extensions

extension String {

    /// ตรวจสอบว่าเป็น Email หรือไม่
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }

    /// ตรวจสอบความแข็งแรงของ Password
    var isStrongPassword: Bool {
        // ต้องมีอย่างน้อย 8 ตัวอักษร, 1 ตัวพิมพ์ใหญ่, 1 ตัวพิมพ์เล็ก, 1 ตัวเลข
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with: self)
    }

    /// Trim whitespace
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// ตัวอักษรตัวแรกเป็นตัวพิมพ์ใหญ่
    var capitalizedFirst: String {
        prefix(1).uppercased() + dropFirst()
    }
}

// MARK: - Double Extensions

extension Double {

    /// Format เป็น String พร้อมทศนิยม
    func formatted(decimals: Int = 1) -> String {
        String(format: "%.\(decimals)f", self)
    }

    /// Format เป็น Percentage
    var percentageString: String {
        String(format: "%.0f%%", self)
    }

    /// แปลงเป็น km (จาก meters)
    var metersToKilometers: Double {
        self / 1000.0
    }

    /// แปลงเป็น miles (จาก meters)
    var metersToMiles: Double {
        self / 1609.344
    }
}

// MARK: - Int Extensions

extension Int {

    /// Format เป็น String พร้อม comma separator
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

// MARK: - Color Extensions

extension Color {

    /// สร้าง Color จาก Hex
    public static func mindHexColor(_ hexString: String) -> Color {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        return Color(
            .sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255,
            opacity: Double(a) / 255)
    }

    // App Colors
    static let appPrimary = Color("AccentColor")
    #if canImport(UIKit)
        static let appBackground = Color(UIColor.systemBackground)
        static let appSecondaryBackground = Color(UIColor.secondarySystemBackground)
    #elseif canImport(AppKit)
        static let appBackground = Color(NSColor.windowBackgroundColor)
        static let appSecondaryBackground = Color(NSColor.controlBackgroundColor)
    #else
        static let appBackground = Color.white
        static let appSecondaryBackground = Color.gray
    #endif
}

#if canImport(UIKit)
    // MARK: - View Extensions

    extension View {

        /// Apply corner radius เฉพาะบางมุม
        func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
            clipShape(RoundedCorner(radius: radius, corners: corners))
        }

        /// ซ่อน Keyboard
        func hideKeyboard() {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }

        /// Conditional modifier
        @ViewBuilder
        func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
            if condition {
                transform(self)
            } else {
                self
            }
        }
    }

    // MARK: - RoundedCorner Shape

    struct RoundedCorner: Shape {
        var radius: CGFloat = .infinity
        var corners: UIRectCorner = .allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }
#endif

// MARK: - Array Extensions

extension Array {

    /// Safe subscript
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Data Extensions

extension Data {

    /// แปลง Data เป็น Hex String
    var hexString: String {
        map { String(format: "%02hhx", $0) }.joined()
    }
}

// MARK: - Optional Extensions

extension Optional where Wrapped == String {

    /// ตรวจสอบว่า nil หรือ empty
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
}

// MARK: - Bundle Extensions

extension Bundle {

    /// App Version
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    /// Build Number
    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    /// Full Version String
    var fullVersion: String {
        "\(appVersion) (\(buildNumber))"
    }
}
