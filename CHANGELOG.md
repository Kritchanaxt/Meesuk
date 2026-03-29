# Mindcare Version History (Changelog)

เอกสารสรุปประวัติเวอร์ชันและการอัปเดตฟีเจอร์หลัก (Version History) ของโปรเจกต์ **Mindcare** โดยระบุตามลำดับการพัฒนาและอิงจากบันทึกใน Git Commits ล่าสุด ข้อมูลอ้างอิงรวมถึงเวอร์ชันของระบบ สภาพแวดลลอง และอุปกรณ์ที่รองรับทั้งหมด

---

## 🛠 System Environment & Tools
* **macOS**: `26.3.1` (ARM 64-bit, Build 25D771280a)
* **Xcode**: `26.1.1` (Build 17B100)
* **Swift Compiler**: เวอร์ชัน `6.2.1` (กำหนดการใช้งานภาษา Swift `5.0` ใน Project Settings)

## 📱 Supported Devices & Deployment Targets
* **Supported Devices** (`TARGETED_DEVICE_FAMILY = 1, 2, 7`):
  * **iPhone**
  * **iPad**
  * **Apple Vision / visionOS** (xrOS)
* **Minimum OS Target**:
  * **iOS**: `18.6` ขึ้นไป
  * **macOS**: `26.1` ขึ้นไป
  * **visionOS / xrOS**: `26.1` ขึ้นไป

## 📦 Dependencies & Packages (แพ็กเกจที่ใช้งาน)
* **Alamofire**: เวอร์ชัน `5.10.2` (ตั้งค่า Rule ไว้แบบ Up to Next Major Version)

## 🏷 Application Information
* **App Version (Marketing)**: `1.0`
* **Build (Project Version)**: `1`
* **Bundle Identifier**: `com.mindcareai.Mindcare.MrWaffle`

---

## 🚀 Version 1.5.0 - API Integration & Real Data (Current)
* **API Integration**: เปลี่ยนจากการใช้ Mock Data มาเป็นการเชื่อมต่อ Mindcare Microservice APIs จริง 
* **Authentication**: อัปเดตกระบวนการเข้าสู่ระบบ (Login) และการสมัครสมาชิกให้รองรับระบบอีเมล
* **UI/UX Polish**: 
  * บังคับใช้แสงสว่าง (Enforce Light Scheme) ในทุกๆ หน้า
  * ปรับแต่งสีของตัวอักษรในส่วนของ Field ให้มองเห็นและใช้งานได้ชัดเจนขึ้น
* *Related Commits:* `339d09b`, `f3e35c7`

## ⌚️ Version 1.4.0 - HealthKit & Watch Support
* **Apple Watch Integration**: รองรับการใช้งานเชื่อมต่อข้อมูลแอปร่วมกับ Apple Watch
* **HealthKit Data**: ดึงค่าอัตราการเต้นของหัวใจ (Heart Rate) พร้อมแสดงผลขึ้นหน้าจอหลัก
* **Home UI Revamp**: ปรับแต่งและทำความสะอาดหน้า Home View ส่วนหัว (Header) โดยจัดการเรื่องของขนาดตัวอักษร การกระจายตัว และลบการแสดงผลต่างๆ ที่ไม่จำเป็นออกเพื่อให้ดูสะอาดตา
* *Related Commit:* `3d71459`

## 🧠 Version 1.3.0 - Psychiatrist Matching Feature
* **Matching Engine**: วางระบบและลอจิกในการจับคู่ระหว่างผู้ใช้งานและจิตแพทย์
* **Chat Fixes**: ปรับปรุงและดีบักระบบห้องแช็ต แก้ไขข้อผิดพลาด (422 Unprocessable Entity) ให้ข้อความที่ส่งผ่าน API คืนค่ากลับมาได้ถูกต้อง
* **Models & Integration**: สร้างส่วนของ Model จัดเก็บข้อมูล และปรับ UI เพื่อให้แสดงผลข้อมูลได้ตรงตามระบบใหม่
* *Related Commit:* `1b1d25c`

## 💬 Version 1.2.0 - Chat Service & UI Refinements
* **Chat API Baseline**: วางโครงสร้างบริการทดสอบห้องแช็ต (`ChatTestService`) รวมถึงตั้งค่า Entitlements 
* **UI/UX Fixes**: ปรับขนาดและแต่งเติมหน้าตาของหน้าหลัก (Home) เพิ่มและจัดตำแหน่งไอคอนแจ้งเตือนตลอดจน Notification Badge
* *Related Commits:* `dcf6ebc`, `0d5b58d`

## 🔐 Version 1.1.0 - Authentication & Refactoring
* **App Navigation**: รีแฟกเตอร์และเขียนระบบการเปลี่ยนหน้าภายในแอปพลิเคชันใหม่
* **Role/Login System**: เพิ่มหน้าแรกสำหรับการล็อกอิน (LoginViewModel) สลับบัญชี และกำหนดหน้า Role Page View
* **Assets**: จัดเก็บและนำเข้าสินทรัพย์รูปภาพ/ไอคอนสำหรับหน้าระบบ Session
* *Related Commits:* `5b9a133`, `1aeced1`

## 🏗 Version 1.0.0 - Project Initialization
* **Project Init**: สร้างโปรเจกต์บน Xcode
* **Configuration**: ตั้งค่า iOS Deployment Target เลือกโครงสร้างการใช้งานของ Scheme
* **Permissions & Entitlement**: จำกัดสิทธิ์ของ Application และตั้งค่าโครงสร้าง Bundle Identifier พื้นฐาน
* *Related Commits:* `e4884ac`, `084f9d1`, `e940bb8`, `90747fb`
