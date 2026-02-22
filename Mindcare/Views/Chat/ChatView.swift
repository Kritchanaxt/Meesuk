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
            id: "1", conversationId: "1", role: .assistant,
            content:
                "Hello!, I'm Meesuk, how are you to day. If there's anything I can help with, just let me know.",
            createdAt: Date(), isRead: true),
        ChatMessage(
            id: "2", conversationId: "1", role: .user, content: "I want to die.", createdAt: Date(),
            isRead: true),
        ChatMessage(
            id: "3", conversationId: "1", role: .assistant,
            content:
                "Please calm down. You can talk to me about anything. Don't think like that.Or, if you're feeling uneasy, you can call 1323.",
            createdAt: Date(), isRead: true),
    ]

    var body: some View {
        ZStack {
            Color.mindHexColor("FFF8E7")  // Warm background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                ChatHeaderView()

                // Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 25) {
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _ in
                        if let lastMessage = messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // Input Area
                ChatInputView(messageText: $messageText, onSend: sendMessage)
            }
        }
    }

    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        // Add user message
        let userMsg = ChatMessage(
            id: UUID().uuidString,
            conversationId: "1",
            role: .user,
            content: messageText,
            createdAt: Date(),
            isRead: true
        )
        messages.append(userMsg)
        messageText = ""

        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let aiMsg = ChatMessage(
                id: UUID().uuidString,
                conversationId: "1",
                role: .assistant,
                content: "I'm here to support you. Tell me more about how you're feeling.",
                createdAt: Date(),
                isRead: true
            )
            messages.append(aiMsg)
        }
    }
}

// MARK: - Subviews

struct ChatHeaderView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        HStack(spacing: 15) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(Color.mindHexColor("4A3422"))
            }

            Spacer()

            Text("Meesuk Chat Bot")
                .font(.custom("Outfit-Bold", size: 20))
                .foregroundColor(Color.mindHexColor("4A3422"))

            Spacer()

            // Placeholder to balance the header
            Color.clear.frame(width: 30, height: 30)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}

struct MessageBubble: View {
    let message: ChatMessage

    var isUser: Bool { message.role == .user }

    var body: some View {
        VStack(alignment: isUser ? .trailing : .leading, spacing: 5) {
            HStack(alignment: .bottom, spacing: 8) {
                if !isUser {
                    Image("Ai_icon")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.bottom, 20)
                } else {
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(message.content)
                        .font(.custom("Outfit-Regular", size: 15))
                        .foregroundColor(Color.mindHexColor("4A3422"))

                    if message.content.contains("1323") {
                        Button(action: {}) {
                            Text("Call")
                                .font(.custom("Outfit-Bold", size: 12))
                                .foregroundColor(Color.mindHexColor("E67E22"))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 6)
                                .background(Color.mindHexColor("FDF1E5"))
                                .cornerRadius(12)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(isUser ? Color.mindHexColor("FFF59D") : Color.white)
                .cornerRadius(20)
                .overlay(
                    BubbleTail(isUser: isUser)
                        .stroke(isUser ? Color.clear : Color.mindHexColor("FF9F9F"), lineWidth: 1)
                        .background(BubbleTail(isUser: isUser).fill(isUser ? Color.mindHexColor("FFF59D") : Color.white))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isUser ? Color.clear : Color.mindHexColor("FF9F9F"), lineWidth: 1)
                )
            }

            Text(message.createdAt.formatted(.dateTime.hour().minute()))
                .font(.custom("Outfit-Regular", size: 12))
                .foregroundColor(Color.mindHexColor("7C6A5B"))
                .padding(isUser ? .trailing : .leading, 40)
        }
    }
}

struct ChatInputView: View {
    @Binding var messageText: String
    var onSend: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 12) {
                Text("EN")
                    .font(.custom("Outfit-Bold", size: 14))
                    .foregroundColor(Color.mindHexColor("E67E22"))
                    .frame(width: 36, height: 36)
                    .background(Color.mindHexColor("FDF1E5"))
                    .clipShape(Circle())

                TextField("Write Here...", text: $messageText)
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.mindHexColor("E6D5C3"), lineWidth: 1)
                    )

                Button(action: {}) {
                    Image("Microphone Icon")  // Asset: Session2/Page2_Chat/Microphone Icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.mindHexColor("FF9F9F"))
                }

                Button(action: onSend) {
                    Image("Send Icon")  // Asset: Session2/Page2_Chat/Send Icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.mindHexColor("FDF1E5").opacity(0.5))
            )
            .padding(.horizontal, 10)
            .padding(.bottom, 100)
        }
    }
}

struct BubbleTail: Shape {
    let isUser: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        if isUser {
            // Right tail
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - 20))
            path.addLine(to: CGPoint(x: rect.maxX + 10, y: rect.maxY - 10))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        } else {
            // Left tail
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - 20))
            path.addLine(to: CGPoint(x: rect.minX - 10, y: rect.maxY - 10))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
        return path
    }
}


#Preview {
    ChatView()
}
