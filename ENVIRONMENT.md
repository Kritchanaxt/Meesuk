# Environment Configuration

โปรเจค Mindcare มีการจัดการ **Environment** ในรูปแบบของโค้ด Swift โดยตรง (ไม่ได้ใช้งานไฟล์ `.env` หรือ `.xcconfig` แยกต่างหาก) 

คุณสามารถดูและแก้ไขการตั้งค่าทั้งหมดได้ที่ไฟล์:
[`Mindcare/App/AppEnvironment.swift`](Mindcare/App/AppEnvironment.swift)

ด้วยการใช้ `enum AppEnvironment` โมเดลนี้ได้ถูกกำหนดไว้ 3 โหมดหลัก ดังนี้:

### 1. Development (`.development`)
- **API Base URL:** `http://localhost:8080/api/v1`
- **การใช้งาน:** โหมดนี้จะถูกเลือกใช้งานอัตโนมัติเมื่อทำการ Build โปรเจคในโหมด **Debug** (เช็คเงื่อนไขจาก `#if DEBUG`)

### 2. Staging (`.staging`)
- **API Base URL:** `https://staging-api.mindcare.app/api/v1`
- **การใช้งาน:** โหมดจำลองสำหรับทดสอบบน TestFlight หรือเซิร์ฟเวอร์ก่อนขึ้นระบบจริง

### 3. Production (`.production`)
- **API Base URL:** `https://api.mindcare.app/api/v1`
- **การใช้งาน:** โหมดนี้จะถูกเลือกใช้งานอัตโนมัติเมื่อทำการ Build โปรเจคในโหมด **Release** (ตอน Build ขึ้น App Store)

---

## App Constants

นอกจากค่า Environment ในไฟล์เดียวกันนี้ยังมีส่วนของ `AppConstants` ที่ใช้เก็บค่าคงที่และ Configurations อื่นๆ ของแอปพลิเคชัน เช่น:
- **Keychain Keys:** เก็บ Access Token, Refresh Token หรือ User ID แบบปลอดภัย
- **UserDefaults Keys:** เช็คสถานะ Onboarding, การยอมรับสิทธิ์ HealthKit, และบทบาทของผู้ใช้ (Role)
- **Timeouts:** ตั้งค่า Request Timeout (`30s`) และ Resource Timeout (`60s`) สำหรับ API
- **Health Sync Interval:** ระยะเวลาในการซิงค์ข้อมูลสุขภาพตั้งไว้ที่ 1 ชั่วโมง (`3600` วินาที)

---

## วิธีการปรับเปลี่ยน URL ทดสอบ

หากในอนาคตต้องการเปลี่ยน URL สำหรับเชื่อมต่อ API แบบกำหนดเอง (เช่น `http://[REDACTED_IP]:9999/chat` ในช่วงการพัฒนา)
คุณสามารถเข้าไปแก้ไขค่า String ต่อท้าย `return` ของ `case .development:` ในไฟล์ `AppEnvironment.swift` ได้โดยตรง ตัวระบบจัดการเครือข่าย (`NetworkManager`) จะเรียกใช้ URL หมวดหมู่นี้ไปต่อท้าย API Endpoint ที่ร้องขอโดยอัตโนมัติครับ
