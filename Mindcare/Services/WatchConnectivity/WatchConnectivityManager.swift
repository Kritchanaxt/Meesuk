//
//  WatchConnectivityManager.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation
import WatchConnectivity
import Combine

/// Watch Connectivity Manager - จัดการการสื่อสารระหว่าง iPhone และ Apple Watch
final class WatchConnectivityManager: NSObject, ObservableObject {
    
    // MARK: - Singleton
    static let shared = WatchConnectivityManager()
    
    // MARK: - Properties
    private var session: WCSession?
    
    @Published var isReachable: Bool = false
    @Published var isPaired: Bool = false
    @Published var isWatchAppInstalled: Bool = false
    @Published var lastReceivedMessage: [String: Any]?
    @Published var lastReceivedContext: [String: Any]?
    
    // Callbacks
    var onMessageReceived: (([String: Any]) -> Void)?
    var onContextReceived: (([String: Any]) -> Void)?
    var onUserInfoReceived: (([String: Any]) -> Void)?
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
    }
    
    // MARK: - Session Setup
    
    /// เริ่ม WCSession
    func startSession() {
        guard WCSession.isSupported() else {
            print("❌ WatchConnectivity is not supported on this device")
            return
        }
        
        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }
    
    /// ตรวจสอบสถานะ Session
    var isSessionActive: Bool {
        session?.activationState == .activated
    }
    
    // MARK: - Send Message (Real-time)
    
    /// ส่งข้อความไปยัง Watch/iPhone แบบ Real-time
    /// ใช้เมื่อ Watch และ iPhone เชื่อมต่อกันอยู่
    func sendMessage(_ message: [String: Any],
                     replyHandler: (([String: Any]) -> Void)? = nil,
                     errorHandler: ((Error) -> Void)? = nil) {
        guard let session = session, session.isReachable else {
            errorHandler?(WatchConnectivityError.notReachable)
            return
        }
        
        session.sendMessage(message, replyHandler: replyHandler) { error in
            print("❌ Send message error: \(error)")
            errorHandler?(error)
        }
    }
    
    /// ส่งข้อความพร้อมรอ Response (async)
    func sendMessage(_ message: [String: Any]) async throws -> [String: Any] {
        guard let session = session, session.isReachable else {
            throw WatchConnectivityError.notReachable
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            session.sendMessage(message, replyHandler: { reply in
                continuation.resume(returning: reply)
            }) { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    // MARK: - Update Application Context
    
    /// อัพเดท Application Context
    /// ใช้สำหรับส่งข้อมูลล่าสุดที่ต้องการให้อีกฝั่งเห็น
    /// ข้อมูลจะถูกส่งเมื่อ Connection พร้อม
    func updateApplicationContext(_ context: [String: Any]) throws {
        guard let session = session else {
            throw WatchConnectivityError.sessionNotActivated
        }
        
        try session.updateApplicationContext(context)
    }
    
    // MARK: - Transfer User Info
    
    /// ส่ง User Info ไปยัง Watch/iPhone
    /// ข้อมูลจะถูก Queue และส่งตามลำดับ
    @discardableResult
    func transferUserInfo(_ userInfo: [String: Any]) -> WCSessionUserInfoTransfer? {
        guard let session = session else { return nil }
        return session.transferUserInfo(userInfo)
    }
    
    /// ดูรายการ User Info ที่ยังไม่ได้ส่ง
    var outstandingUserInfoTransfers: [WCSessionUserInfoTransfer] {
        session?.outstandingUserInfoTransfers ?? []
    }
    
    // MARK: - Transfer File
    
    /// ส่งไฟล์ไปยัง Watch/iPhone
    @discardableResult
    func transferFile(_ file: URL, metadata: [String: Any]? = nil) -> WCSessionFileTransfer? {
        guard let session = session else { return nil }
        return session.transferFile(file, metadata: metadata)
    }
    
    /// ดูรายการไฟล์ที่ยังไม่ได้ส่ง
    var outstandingFileTransfers: [WCSessionFileTransfer] {
        session?.outstandingFileTransfers ?? []
    }
    
    // MARK: - Complication User Info (watchOS)
    
    #if os(iOS)
    /// ส่ง Complication User Info ไปยัง Watch (จาก iPhone)
    @discardableResult
    func transferCurrentComplicationUserInfo(_ userInfo: [String: Any]) -> WCSessionUserInfoTransfer? {
        guard let session = session else { return nil }
        return session.transferCurrentComplicationUserInfo(userInfo)
    }
    
    /// จำนวนครั้งที่เหลือสำหรับอัพเดท Complication
    var remainingComplicationUserInfoTransfers: Int {
        session?.remainingComplicationUserInfoTransfers ?? 0
    }
    #endif
    
    // MARK: - Health Data Sync
    
    /// ส่งข้อมูลสุขภาพไปยัง iPhone (จาก Watch)
    func syncHealthData(_ healthData: HealthMetrics) throws {
        let data: [String: Any] = [
            "type": "healthData",
            "timestamp": healthData.timestamp?.timeIntervalSince1970 ?? Date().timeIntervalSince1970,
            "heartRate": healthData.heartRate ?? 0,
            "hrv": healthData.hrv ?? 0,
            "steps": healthData.steps ?? 0,
            "activeEnergy": healthData.activeEnergy ?? 0,
            "oxygenSaturation": healthData.oxygenSaturation ?? 0
        ]
        
        try updateApplicationContext(data)
    }
    
    /// Request ข้อมูลจาก Watch
    func requestHealthDataFromWatch() {
        sendMessage(["type": "requestHealthData"]) { response in
            print("✅ Received health data from watch: \(response)")
        } errorHandler: { error in
            print("❌ Failed to request health data: \(error)")
        }
    }
}

// MARK: - WCSessionDelegate

extension WatchConnectivityManager: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.updateSessionState(session)
        }
        
        if let error = error {
            print("❌ WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("✅ WCSession activated with state: \(activationState.rawValue)")
            print("📱 Paired: \(session.isPaired), Watch App Installed: \(session.isWatchAppInstalled), Reachable: \(session.isReachable)")
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate")
        // Reactivate session for switching watches
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.updateSessionState(session)
        }
    }
    #endif
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("📡 Watch Reachability Changed: \(session.isReachable)")
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
    }
    
    // MARK: - Receive Message
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("📨 Received message from Watch: \(message)")
        DispatchQueue.main.async {
            self.lastReceivedMessage = message
            self.onMessageReceived?(message)
        }
        handleReceivedMessage(message)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            self.lastReceivedMessage = message
            self.onMessageReceived?(message)
        }
        
        // Handle message and reply
        let reply = handleReceivedMessage(message)
        replyHandler(reply)
    }
    
    // MARK: - Receive Application Context
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            self.lastReceivedContext = applicationContext
            self.onContextReceived?(applicationContext)
        }
        handleReceivedContext(applicationContext)
    }
    
    // MARK: - Receive User Info
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            self.onUserInfoReceived?(userInfo)
        }
    }
    
    // MARK: - Receive File
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        // Handle received file
        print("Received file: \(file.fileURL)")
    }
    
    // MARK: - Private Helpers
    
    private func updateSessionState(_ session: WCSession) {
        isReachable = session.isReachable
        
        #if os(iOS)
        isPaired = session.isPaired
        isWatchAppInstalled = session.isWatchAppInstalled
        #endif
    }
    
    @discardableResult
    private func handleReceivedMessage(_ message: [String: Any]) -> [String: Any] {
        guard let type = message["type"] as? String else {
            return ["status": "error", "message": "Unknown message type"]
        }
        
        switch type {
        case "requestHealthData":
            // Return health data
            Task {
                let healthData = await HealthKitManager.shared.fetchAllHealthData()
                return [
                    "status": "success",
                    "heartRate": healthData.heartRate ?? 0,
                    "hrv": healthData.hrv ?? 0,
                    "steps": healthData.steps ?? 0
                ]
            }
            return ["status": "processing"]
            
        case "healthData":
            // Process received health data
            NotificationCenter.default.post(
                name: AppConstants.NotificationNames.healthDataUpdated,
                object: nil,
                userInfo: message
            )
            return ["status": "received"]
            
        default:
            return ["status": "unknown"]
        }
    }
    
    private func handleReceivedContext(_ context: [String: Any]) {
        guard let type = context["type"] as? String else { return }
        
        switch type {
        case "healthData":
            // Sync health data to backend
            Task {
                // await NetworkService.shared.syncHealthData(context)
            }
            
        default:
            break
        }
    }
}

// MARK: - Errors

enum WatchConnectivityError: LocalizedError {
    case notSupported
    case sessionNotActivated
    case notReachable
    case transferFailed
    
    var errorDescription: String? {
        switch self {
        case .notSupported:
            return "WatchConnectivity is not supported on this device"
        case .sessionNotActivated:
            return "WCSession is not activated"
        case .notReachable:
            return "Watch/iPhone is not reachable"
        case .transferFailed:
            return "Transfer failed"
        }
    }
}
