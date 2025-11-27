//
//  KeychainManager.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation
import Security

/// Keychain Manager - จัดการข้อมูลใน Keychain อย่างปลอดภัย
final class KeychainManager {
    
    // MARK: - Singleton
    static let shared = KeychainManager()
    
    private init() {}
    
    // MARK: - Save
    
    /// บันทึกค่าลง Keychain
    @discardableResult
    func save(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return save(key: key, data: data)
    }
    
    /// บันทึก Data ลง Keychain
    @discardableResult
    func save(key: String, data: Data) -> Bool {
        // Delete existing item first
        delete(key: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    // MARK: - Get
    
    /// ดึงค่าจาก Keychain
    func get(key: String) -> String? {
        guard let data = getData(key: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// ดึง Data จาก Keychain
    func getData(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }
    
    // MARK: - Delete
    
    /// ลบค่าออกจาก Keychain
    @discardableResult
    func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    // MARK: - Update
    
    /// อัพเดทค่าใน Keychain
    @discardableResult
    func update(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return update(key: key, data: data)
    }
    
    /// อัพเดท Data ใน Keychain
    @discardableResult
    func update(key: String, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        // If item doesn't exist, save it
        if status == errSecItemNotFound {
            return save(key: key, data: data)
        }
        
        return status == errSecSuccess
    }
    
    // MARK: - Clear All
    
    /// ลบข้อมูลทั้งหมดใน Keychain ของ App
    @discardableResult
    func clearAll() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    // MARK: - Exists
    
    /// ตรวจสอบว่ามี Key อยู่หรือไม่
    func exists(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: false,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
}

// MARK: - Codable Support

extension KeychainManager {
    
    /// บันทึก Codable Object ลง Keychain
    func save<T: Codable>(key: String, object: T) -> Bool {
        do {
            let data = try JSONEncoder().encode(object)
            return save(key: key, data: data)
        } catch {
            print("Failed to encode object for keychain: \(error)")
            return false
        }
    }
    
    /// ดึง Codable Object จาก Keychain
    func get<T: Codable>(key: String, type: T.Type) -> T? {
        guard let data = getData(key: key) else { return nil }
        
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Failed to decode object from keychain: \(error)")
            return nil
        }
    }
}
