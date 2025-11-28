//
//  ChatView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI

struct ChatView: View {
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(
            id: UUID().uuidString,
            conversationId: "local",
            role: .assistant,
            content: "Hello! How are you feeling today?",
            createdAt: Date(),
            isRead: true
        ),
        ChatMessage(
            id: UUID().uuidString,
            conversationId: "local",
            role: .user,
            content: "Hi, I'm feeling a bit anxious.",
            createdAt: Date().addingTimeInterval(60),
            isRead: true
        ),
        ChatMessage(
            id: UUID().uuidString,
            conversationId: "local",
            role: .assistant,
            content: "I'm sorry to hear that. Would you like to try a breathing exercise?",
            createdAt: Date().addingTimeInterval(120),
            isRead: true
        )
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding()
                }
                .background(Color(UIColor.systemGroupedBackground))
                
                // Input Area
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .foregroundColor(.secondary)
                    }
                    
                    TextField("Type a message...", text: $messageText)
                        .padding(10)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(20)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: -2)
            }
            .navigationTitle("AI Assistant")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        // Create user message
        let newMessage = ChatMessage(
            id: UUID().uuidString,
            conversationId: "local",
            role: .user,
            content: messageText,
            createdAt: Date(),
            isRead: true
        )
        
        messages.append(newMessage)
        messageText = ""
        
        // Simulate response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = ChatMessage(
                id: UUID().uuidString,
                conversationId: "local",
                role: .assistant,
                content: "I understand. Tell me more about what's making you anxious.",
                createdAt: Date(),
                isRead: true
            )
            messages.append(response)
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var isUser: Bool {
        return message.role == .user
    }
    
    var body: some View {
        HStack {
            if isUser { Spacer() }
            
            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(isUser ? Color.blue : Color.white)
                    .foregroundColor(isUser ? .white : .black)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                Text(message.createdAt.formatted(.dateTime.hour().minute()))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            
            if !isUser { Spacer() }
        }
    }
}

#Preview {
    ChatView()
}
