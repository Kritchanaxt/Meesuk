# 🧠 MindCare - Mental Health & Wellness App

<p align="center">
  <strong>แอปพลิเคชันดูแลสุขภาพจิตครบวงจร สำหรับ iOS และ Apple Watch</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" alt="iOS 17+">
  <img src="https://img.shields.io/badge/watchOS-10.0+-green.svg" alt="watchOS 10+">
  <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" alt="Swift 5.9">
  <img src="https://img.shields.io/badge/SwiftUI-5.0-purple.svg" alt="SwiftUI 5">
  <img src="https://img.shields.io/badge/SwiftData-1.0-red.svg" alt="SwiftData">
  <img src="https://img.shields.io/badge/Alamofire-5.8+-green.svg" alt="Alamofire">
</p>

---

## 📋 สารบัญ

- [คุณสมบัติหลัก](#-คุณสมบัติหลัก)
- [ความต้องการของระบบ](#-ความต้องการของระบบ)
- [การติดตั้ง](#-การติดตั้ง)
- [โครงสร้างโปรเจค](#-โครงสร้างโปรเจค)
- [รายละเอียดไฟล์](#-รายละเอียดไฟล์)
- [การตั้งค่า](#-การตั้งค่า)
- [การใช้งาน](#-การใช้งาน)
- [การทดสอบ](#-การทดสอบ)
- [Contributing](#-contributing)

---

## ✨ คุณสมบัติหลัก

### 🏥 ด้านสุขภาพ
- **HealthKit Integration** - ติดตามข้อมูลสุขภาพ (ก้าวเดิน, อัตราการเต้นหัวใจ, การนอน, แคลอรี่)
- **Apple Watch Support** - รองรับ Apple Watch สำหรับติดตาม Workout และข้อมูลสุขภาพแบบ Real-time
- **CoreMotion** - วิเคราะห์การเคลื่อนไหวและกิจกรรมประจำวัน

### 💭 ด้านสุขภาพจิต
- **Mood Tracking** - บันทึกอารมณ์และความรู้สึกประจำวัน
- **AI Chat** - สนทนากับ AI เพื่อรับคำปรึกษาเบื้องต้น
- **Psychiatrist Consultation** - นัดหมายปรึกษาจิตแพทย์ผ่าน Video Call

### 💳 ด้านการชำระเงิน
- **Apple Pay** - ชำระเงินผ่าน Apple Pay อย่างปลอดภัย
- **Subscription** - รองรับการสมัครสมาชิกรายเดือน/รายปี

### 🔔 การแจ้งเตือน
- **Local Notifications** - แจ้งเตือนกิจกรรมและการออกกำลังกาย
- **Push Notifications** - รับการแจ้งเตือนจากระบบ

### 💾 ด้านการจัดเก็บข้อมูล
- **SwiftData** - จัดเก็บข้อมูลแบบ Local (Mood entries, Health cache, User preferences)
- **iCloud Sync** - รองรับ Sync ข้อมูลผ่าน CloudKit (Optional)
- **Offline Support** - ใช้งานได้แม้ไม่มี Internet

---

## 📱 ความต้องการของระบบ

| Platform | Minimum Version |
|----------|-----------------|
| iOS | 17.0+ |
| watchOS | 10.0+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |

> ⚠️ **หมายเหตุ**: SwiftData ต้องการ iOS 17+ และ watchOS 10+ เป็นอย่างต่ำ

### Dependencies

| Package | Version | Description |
|---------|---------|-------------|
| [Alamofire](https://github.com/Alamofire/Alamofire) | 5.8+ | HTTP Networking |

---

## 🚀 การติดตั้ง

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/Mindcare.git
cd Mindcare
```

### 2. เปิด Project ใน Xcode

```bash
open Mindcare.xcodeproj
```

### 3. Resolve Swift Packages

ใน Xcode:
- ไปที่ **File → Packages → Resolve Package Versions**
- รอจนกว่า Alamofire จะถูกดาวน์โหลดเสร็จ

### 4. ตั้งค่า Signing & Capabilities

1. เลือก **Mindcare** target
2. ไปที่ **Signing & Capabilities**
3. เลือก **Team** ของคุณ
4. เปลี่ยน **Bundle Identifier** ให้เป็นของคุณ

### 5. เพิ่ม Capabilities ที่จำเป็น

กด **+ Capability** และเพิ่ม:
- ✅ HealthKit
- ✅ Apple Pay
- ✅ Push Notifications
- ✅ Sign in with Apple
- ✅ Background Modes (Background fetch, Remote notifications)

### 6. Build และ Run

```
⌘ + R
```

---

## 📁 โครงสร้างโปรเจค

```
Mindcare/
├── 📱 App/                          # Application Core
│   ├── AppDelegate.swift
│   └── AppEnvironment.swift
│
├── 📊 Models/                       # Data Models
│   ├── ActivityModels.swift
│   ├── AppointmentModels.swift
│   ├── AuthModels.swift
│   ├── ChatModels.swift
│   ├── HealthModels.swift
│   ├── MoodModels.swift
│   ├── PaymentModels.swift
│   └── UserModels.swift
│
├── ⚙️ Services/                     # Business Logic Services
│   ├── Auth/
│   │   ├── AuthService.swift
│   │   └── KeychainManager.swift
│   ├── CoreMotion/
│   │   └── CoreMotionManager.swift
│   ├── HealthKit/
│   │   ├── HealthKitManager.swift
│   │   └── WorkoutManager.swift
│   ├── Network/
│   │   ├── APIEndpoints.swift
│   │   ├── APIService.swift
│   │   └── NetworkManager.swift
│   ├── Notifications/
│   │   └── NotificationService.swift
│   ├── Payment/
│   │   └── ApplePayManager.swift
│   └── WatchConnectivity/
│       └── WatchConnectivityManager.swift
│
├── 🎨 Views/                        # SwiftUI Views
│   ├── Auth/
│   │   └── LoginView.swift          # Login, Sign Up, Forgot Password
│   ├── Main/
│   │   └── MainTabView.swift
│   ├── Onboarding/
│   │   └── HealthKitOnboardingView.swift
│   └── Payment/
│       └── ApplePayButtonView.swift
│
├── 🔄 ViewModels/                   # MVVM ViewModels
│   ├── BaseViewModel.swift
│   └── HealthViewModel.swift
│
├── 🛠 Utilities/                    # Helper Classes
│   ├── Extensions.swift
│   ├── Logger.swift
│   └── Validators.swift
│
├── 🎨 Assets.xcassets/              # Images & Colors
├── 📄 MindcareApp.swift             # App Entry Point
├── 📄 ContentView.swift             # Root View Controller
├── 📄 Item.swift                    # SwiftData Sample Model
└── 📄 Mindcare.entitlements         # App Entitlements
```

---

## 📖 รายละเอียดไฟล์

### 📱 App/

| ไฟล์ | หน้าที่ |
|------|--------|
| `AppDelegate.swift` | จัดการ App Lifecycle, Push Notifications, และ Background Tasks |
| `AppEnvironment.swift` | จัดการ Environment (Development, Staging, Production) และ Configuration |

### 📊 Models/ (SwiftData)

> 💡 **หมายเหตุ**: Models ใช้ `@Model` macro ของ SwiftData สำหรับ Local persistence

| ไฟล์ | หน้าที่ | SwiftData |
|------|--------|:---------:|
| `UserModels.swift` | โมเดลข้อมูลผู้ใช้ (`User`, `UserProfile`, `Gender`, `EmergencyContact`) | ✅ |
| `HealthModels.swift` | โมเดลข้อมูลสุขภาพ (`HealthData`, `HeartRateData`, `SleepData`, `StepData`) | ✅ |
| `MoodModels.swift` | โมเดลบันทึกอารมณ์ (`MoodEntry`, `MoodType`, `MoodTrigger`) | ✅ |
| `ChatModels.swift` | โมเดลการสนทนา (`ChatMessage`, `Conversation`, `ConversationType`) | ✅ |
| `ActivityModels.swift` | โมเดลกิจกรรม (`Activity`, `ActivityType`, `ActivityCompletion`) | ✅ |
| `AppointmentModels.swift` | โมเดลการนัดหมาย (`Appointment`, `Psychiatrist`, `Specialization`) | ✅ |
| `AuthModels.swift` | โมเดลการยืนยันตัวตน (`AuthToken`, `LoginRequest`, `RegisterRequest`) | ❌ |
| `PaymentModels.swift` | โมเดลการชำระเงิน (`PaymentTransaction`, `UserSubscription`, `TransactionStatus`) | ✅ |

### ⚙️ Services/

#### Auth/
| ไฟล์ | หน้าที่ |
|------|--------|
| `AuthService.swift` | จัดการ Login, Register, Logout, Apple Sign In, Token Management |
| `KeychainManager.swift` | เก็บข้อมูลที่ละเอียดอ่อน (Token, Password) ใน Keychain อย่างปลอดภัย |

#### CoreMotion/
| ไฟล์ | หน้าที่ |
|------|--------|
| `CoreMotionManager.swift` | ติดตามการเคลื่อนไหว, จำนวนก้าว, ระยะทาง, การวิ่ง, การเดิน |

#### HealthKit/
| ไฟล์ | หน้าที่ |
|------|--------|
| `HealthKitManager.swift` | เชื่อมต่อ HealthKit, ขอสิทธิ์, ดึงข้อมูลสุขภาพ (Heart Rate, Steps, Sleep, Calories) |
| `WorkoutManager.swift` | จัดการ Workout Sessions, ใช้กับ Apple Watch |

#### Network/
| ไฟล์ | หน้าที่ |
|------|--------|
| `NetworkManager.swift` | จัดการ HTTP Requests ด้วย Alamofire, Authentication Interceptor |
| `APIEndpoints.swift` | รวม API Endpoints ทั้งหมด (Auth, User, Health, Chat, Mood, Appointments, Payment) |
| `APIService.swift` | High-level API calls สำหรับแต่ละ feature |

#### Notifications/
| ไฟล์ | หน้าที่ |
|------|--------|
| `NotificationService.swift` | จัดการ Local/Push Notifications, แจ้งเตือนกิจกรรม, การนัดหมาย |

#### Payment/
| ไฟล์ | หน้าที่ |
|------|--------|
| `ApplePayManager.swift` | จัดการ Apple Pay, สร้าง Payment Request, ประมวลผลการชำระเงิน |

#### WatchConnectivity/
| ไฟล์ | หน้าที่ |
|------|--------|
| `WatchConnectivityManager.swift` | สื่อสารระหว่าง iPhone และ Apple Watch, ส่งข้อมูลสุขภาพ |

### 🎨 Views/

| ไฟล์ | หน้าที่ |
|------|--------|
| `LoginView.swift` | หน้า Login, Sign Up, Forgot Password พร้อม Demo Mode |
| `MainTabView.swift` | Tab Bar หลักของแอป (Home, Health, Mood, Chat, Profile) |
| `HealthKitOnboardingView.swift` | หน้าขอสิทธิ์ HealthKit ครั้งแรก |
| `ApplePayButtonView.swift` | ปุ่ม Apple Pay และหน้าชำระเงิน |

### 🔄 ViewModels/

| ไฟล์ | หน้าที่ |
|------|--------|
| `BaseViewModel.swift` | Base class สำหรับ ViewModels ทั้งหมด (Loading state, Error handling) |
| `HealthViewModel.swift` | ViewModel สำหรับข้อมูลสุขภาพ, Progress tracking |

### 🛠 Utilities/

| ไฟล์ | หน้าที่ |
|------|--------|
| `Extensions.swift` | Swift Extensions (Date, String, Color, View) |
| `Logger.swift` | Logging utility สำหรับ Debug/Release |
| `Validators.swift` | Validation functions (Email, Password, Phone, Name) |

---

## ⚙️ การตั้งค่า

### 1. Environment Configuration

แก้ไข `AppEnvironment.swift`:

```swift
// สลับ Environment
static var current: AppEnvironment {
    #if DEBUG
    return .development
    #else
    return .production
    #endif
}
```

### 2. API Base URL

แก้ไข URL ใน `AppEnvironment.swift`:

```swift
static let development = AppEnvironment(
    baseURL: "https://api-dev.mindcare.app/v1",
    ...
)

static let production = AppEnvironment(
    baseURL: "https://api.mindcare.app/v1",
    ...
)
```

### 3. Apple Pay Merchant ID

แก้ไข `ApplePayManager.swift`:

```swift
let merchantIdentifier = "merchant.com.yourcompany.mindcare"
```

**ขั้นตอนการตั้งค่า Apple Pay:**
1. ไปที่ [Apple Developer Portal](https://developer.apple.com)
2. สร้าง Merchant ID ใหม่
3. สร้าง Payment Processing Certificate
4. เพิ่ม Apple Pay Capability ใน Xcode
5. เพิ่ม Merchant ID ใน Xcode

### 4. HealthKit Configuration

ใน `Info.plist` ต้องมี:

```xml
<key>NSHealthShareUsageDescription</key>
<string>MindCare ต้องการเข้าถึงข้อมูลสุขภาพเพื่อติดตามสุขภาพของคุณ</string>

<key>NSHealthUpdateUsageDescription</key>
<string>MindCare ต้องการบันทึกข้อมูลสุขภาพของคุณ</string>
```

---

## 📱 การใช้งาน

### 🔑 Demo Mode (สำหรับทดสอบ)

เนื่องจากยังไม่มี Backend จริง สามารถทดสอบแอปได้ด้วย Demo Mode:

| Field | Value |
|-------|-------|
| **Email** | `demo@mindcare.com` |
| **Password** | `demo1234` |

หรือกดปุ่ม **"Fill Demo Credentials"** ในหน้า Login เพื่อกรอกอัตโนมัติ

> 💡 **หมายเหตุ**: Demo Mode จะสร้าง mock user และ bypass API calls ทั้งหมด

### การเริ่มต้นใช้งาน

1. **เปิดแอป** - แอปจะแสดงหน้า Onboarding (ครั้งแรก)
2. **เข้าสู่ระบบ** - ใช้ Demo credentials หรือ Sign in with Apple
3. **อนุญาต HealthKit** - อนุญาตให้เข้าถึงข้อมูลสุขภาพ
4. **เริ่มใช้งาน** - ติดตามสุขภาพและบันทึกอารมณ์ได้เลย

### ตัวอย่างการใช้ Services

#### HealthKit

```swift
// ขอสิทธิ์
await HealthKitManager.shared.requestAuthorization()

// ดึงข้อมูลก้าวเดินวันนี้
let steps = await HealthKitManager.shared.fetchTodaySteps()

// ดึงข้อมูล Heart Rate
let heartRates = await HealthKitManager.shared.fetchHeartRateData(
    startDate: startDate,
    endDate: endDate
)
```

#### Authentication

```swift
// Login
try await AuthService.shared.login(
    email: "user@example.com",
    password: "password123"
)

// Demo Mode Login (ไม่ต้องมี Backend)
// Email: demo@mindcare.com
// Password: demo1234

// Apple Sign In
try await AuthService.shared.signInWithApple()

// Check Auth State
if AuthService.shared.isAuthenticated {
    // User is logged in
}

// Logout
await AuthService.shared.logout()
```

#### Apple Pay

```swift
// สร้าง Payment Request
let request = ApplePayManager.shared.createConsultationPaymentRequest(
    psychiatristName: "นพ.สมชาย ใจดี",
    amount: 1500.0
)

// แสดง Payment Sheet
ApplePayManager.shared.presentPaymentSheet(request: request) { result in
    switch result {
    case .success(let transaction):
        print("Payment successful: \(transaction.id)")
    case .failure(let error):
        print("Payment failed: \(error)")
    }
}
```

#### Notifications

```swift
// ตั้งเวลาแจ้งเตือน
NotificationService.shared.scheduleMoodReminder(at: DateComponents(hour: 20, minute: 0))

// แจ้งเตือนการนัดหมาย
NotificationService.shared.scheduleAppointmentReminder(
    appointment: appointment,
    minutesBefore: 30
)
```

#### SwiftData

```swift
// Model Definition
@Model
final class MoodEntry {
    var id: UUID
    var mood: MoodType
    var intensity: Int
    var note: String?
    var timestamp: Date
    
    init(mood: MoodType, intensity: Int, note: String? = nil) {
        self.id = UUID()
        self.mood = mood
        self.intensity = intensity
        self.note = note
        self.timestamp = Date()
    }
}

// ใน View - ดึงข้อมูลด้วย @Query
struct MoodHistoryView: View {
    @Query(sort: \MoodEntry.timestamp, order: .reverse) 
    private var moodEntries: [MoodEntry]
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List(moodEntries) { entry in
            MoodRowView(entry: entry)
        }
    }
    
    // บันทึก Mood ใหม่
    func saveMood(_ mood: MoodType, intensity: Int, note: String?) {
        let entry = MoodEntry(mood: mood, intensity: intensity, note: note)
        modelContext.insert(entry)
    }
    
    // ลบ Mood
    func deleteMood(_ entry: MoodEntry) {
        modelContext.delete(entry)
    }
}

// ใน App - ตั้งค่า ModelContainer
@main
struct MindcareApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            MoodEntry.self,
            HealthData.self,
            ChatMessage.self
        ])
    }
}
```

---

## 🧪 การทดสอบ

### Unit Tests

```bash
# รัน Unit Tests ทั้งหมด
⌘ + U

# หรือใช้ command line
xcodebuild test -scheme Mindcare -destination 'platform=iOS Simulator,name=iPhone 15'
```

### UI Tests

```bash
# รัน UI Tests
xcodebuild test -scheme MindcareUITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Test Coverage

| Category | Test File | Coverage |
|----------|-----------|----------|
| Models | `MindcareTests.swift` | User, Health, Mood, Chat, Payment, Activity, Appointment |
| Services | `ServiceTests.swift` | Auth, Keychain, Network, HealthKit, Notifications, Payment |
| ViewModels | `ViewModelTests.swift` | Base, Health |
| UI | `MindcareUITests.swift` | Launch, Navigation, Onboarding, Accessibility |

---

## 🏗 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         Views (SwiftUI)                      │
│   MainTabView │ HealthKitOnboardingView │ ApplePayButtonView │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                      ViewModels (MVVM)                       │
│              BaseViewModel │ HealthViewModel                 │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                        Services                              │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────────┐│
│  │   Auth   │ │HealthKit │ │ Network  │ │   Notifications  ││
│  └──────────┘ └──────────┘ └──────────┘ └──────────────────┘│
│  ┌──────────┐ ┌──────────┐ ┌──────────┐                     │
│  │ Payment  │ │CoreMotion│ │  Watch   │                     │
│  └──────────┘ └──────────┘ └──────────┘                     │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                    Models (@Model SwiftData)                 │
│    User │ Health │ Mood │ Chat │ Activity │ Payment          │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                      SwiftData Storage                       │
│         ModelContainer │ ModelContext │ @Query               │
└─────────────────────────────────────────────────────────────┘
```

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style

- ใช้ Swift API Design Guidelines
- ใช้ `// MARK: -` สำหรับแบ่ง sections
- เขียน Comments เป็นภาษาไทยหรืออังกฤษก็ได้
- ใช้ `async/await` แทน Completion Handlers

---

## 🔌 Backend Integration Guide

### API Requirements

iOS app พร้อมเชื่อมต่อ Backend ที่รองรับ:

| Feature | Endpoints | Method |
|---------|-----------|--------|
| **Auth** | `/auth/login`, `/auth/register`, `/auth/apple`, `/auth/refresh` | POST |
| **User** | `/users/profile` | GET, PUT |
| **Health** | `/health/sync`, `/health/history`, `/health/analysis` | GET, POST |
| **Chat/AI** | `/ai/chat`, `/ai/suggestions`, `/ai/risk-assessment` | GET, POST |
| **Mood** | `/mood/check-in`, `/mood/history`, `/mood/trends` | GET, POST |
| **Activities** | `/activities`, `/activities/recommended` | GET, POST |
| **Appointments** | `/appointments`, `/appointments/:id` | GET, POST, DELETE |
| **Payment** | `/payments/process`, `/payments/subscriptions` | POST |

### Expected Response Format

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... },
  "meta": {
    "currentPage": 1,
    "totalPages": 10,
    "totalItems": 100
  }
}
```

### Authentication

- ใช้ **Bearer Token** ใน Header
- Access Token หมดอายุใน 15 นาที (แนะนำ)
- Refresh Token หมดอายุใน 7 วัน
- App จะ auto-refresh token เมื่อได้รับ 401

```
Authorization: Bearer <access_token>
Content-Type: application/json
```

### Backend Tech Stack ที่แนะนำ

| Option | Framework | Database | Realtime |
|--------|-----------|----------|----------|
| **Go** | Gin / Fiber | PostgreSQL / MongoDB| Gorilla WebSocket |

### Environment Configuration

แก้ไข URL ใน `AppEnvironment.swift`:

```swift
var baseURL: String {
    switch self {
    case .development:
        return "http://localhost:8080/api/v1"  // Local development
    case .staging:
        return "https://staging-api.mindcare.app/api/v1"
    case .production:
        return "https://api.mindcare.app/api/v1"
    }
}
```

### Response Models

ดูไฟล์ `Models/APIResponseModels.swift` สำหรับ Response structure ทั้งหมด:

- `AuthResponse` - Login/Register response
- `HealthMetrics` - Health data sync
- `ChatResponse` - AI chat response
- `MoodCheckInResponse` - Mood tracking
- `RiskAssessment` - AI risk analysis
- `PaymentProcessResponse` - Payment result

### WebSocket (Real-time)

สำหรับ Real-time features:

```swift
// Message Types
enum WebSocketMessageType {
    case chatMessage
    case typingIndicator
    case presenceUpdate
    case healthUpdate
    case alert
    case notification
}
```

---

<p align="center">
  Made with ❤️ for Mental Health Awareness
</p>
