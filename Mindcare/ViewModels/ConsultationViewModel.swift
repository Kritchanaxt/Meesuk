import Foundation
import SwiftUI
import Combine

class ConsultationViewModel: ObservableObject {
    @Published var messages: [ConsultationMessage] = []
    @Published var isTyping: Bool = false
    @Published var messageText: String = ""
    
    private var responseIndex = 0
    private let doctorResponses = [
        "I understand. That's a common time for reflection to turn into worry. Let's talk about what triggers those feelings.",
        "It's good that you're noticing these patterns. Identifying the 'when' is the first step toward managing the 'how'.",
        "Have you tried any of the breathing exercises we discussed in our last session when you feel this way?",
        "I'm here to support you. We can work through this together. Is there anything specific that happened today that might have contributed to this?",
    ]
    
    init() {
        // Initial mock message
        messages = [
            ConsultationMessage(
                id: "1",
                senderId: "doc-julian",
                senderName: "Dr. Julian Vance",
                senderAvatar: "Dr_img",
                content: "Hello! I'm here to listen. How have you been feeling since our last session?",
                createdAt: Date().addingTimeInterval(-3600),
                isFromUser: false,
                isRead: true,
                messageType: .text
            )
        ]
    }
    
    @MainActor
    func sendMessage() {
        let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        // 1. Add User Message
        let userMsg = ConsultationMessage(
            id: UUID().uuidString,
            senderId: "user-123",
            senderName: "Demo User",
            senderAvatar: nil,
            content: trimmedText,
            createdAt: Date(),
            isFromUser: true,
            isRead: true,
            messageType: .text
        )
        
        messages.append(userMsg)
        messageText = ""
        
        // 2. Simulate Doctor Response
        simulateDoctorResponse()
    }
    
    @MainActor
    private func simulateDoctorResponse() {
        isTyping = true
        
        // Simulate thinking time
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            
            let responseContent = self.doctorResponses[self.responseIndex % self.doctorResponses.count]
            self.responseIndex += 1
            
            let doctorMsg = ConsultationMessage(
                id: UUID().uuidString,
                senderId: "doc-julian",
                senderName: "Dr. Julian Vance",
                senderAvatar: "Dr_img",
                content: responseContent,
                createdAt: Date(),
                isFromUser: false,
                isRead: true,
                messageType: .text
            )
            
            withAnimation {
                self.messages.append(doctorMsg)
                self.isTyping = false
            }
        }
    }
    
    func sendVoiceMock() {
        let voiceMsg = ConsultationMessage(
            id: UUID().uuidString,
            senderId: "user-123",
            senderName: "Demo User",
            senderAvatar: nil,
            content: "Voice Message (0:14)",
            createdAt: Date(),
            isFromUser: true,
            isRead: true,
            messageType: .voice
        )
        messages.append(voiceMsg)
    }
}
