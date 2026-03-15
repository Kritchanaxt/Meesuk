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
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Add Authorization Token if available safely (check for existence of these classes)
        // Note: APIService uses NetworkManager which handles this.
        // We'll mimic it here but keep it simple.

        // Simplified body to match basic requirement
        let body: [String: Any] = ["message": message]
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        request.httpBody = bodyData

        print("🌐 Sending Chat Request to \(url)")
        if let bodyString = String(data: bodyData, encoding: .utf8) {
            print("📦 Request Body: \(bodyString)")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("🌐 API Response Code: \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200 {
                let errorBody = String(data: data, encoding: .utf8) ?? "Unable to decode error body"
                print("❌ API Error Body: \(errorBody)")
            }
        }

        // The backend likely returns a ChatResponse object (see ChatModels.swift)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Note: You might need to add a date strategy if the backend returns dates

        if let chatResponse = try? decoder.decode(ChatResponse.self, from: data) {
            return chatResponse.message.content
        }

        // Fallback to legacy parsing if it's a simple JSON
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let responseText = json["response"] as? String
        {
            return responseText
        }

        throw URLError(.badServerResponse)
    }
}
