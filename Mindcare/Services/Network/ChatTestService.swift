//
//  ChatTestService.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation

class ChatTestService {
    static let shared = ChatTestService()
    
    private let url = URL(string: "http://[REDACTED_IP]:9999/chat")!
    
    func sendMessage(_ message: String) async throws -> String {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["message": message]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let response = json["response"] as? String {
            return response
        }
        
        throw URLError(.badServerResponse)
    }
}
