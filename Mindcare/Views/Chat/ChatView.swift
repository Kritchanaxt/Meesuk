//
//  ChatView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI

struct ChatView: View {
    @State private var messageText = ""
    @State private var keyboardHeight: CGFloat = 0
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
                        .padding(.bottom, 10)  // Space for last message
                    }
                    .onChange(of: messages.count) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: keyboardHeight) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                }

                // Input Area
                ChatInputView(messageText: $messageText, onSend: sendMessage)
                    .padding(.bottom, keyboardHeight > 0 ? keyboardHeight : 90)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            self.setupKeyboardObservers()
        }
        .onDisappear {
            self.removeKeyboardObservers()
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = messages.last {
            withAnimation {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main
        ) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? CGRect
            {
                withAnimation(.easeOut(duration: 0.25)) {
                    self.keyboardHeight = keyboardFrame.height
                }
            }
        }

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main
        ) { _ in
            withAnimation(.easeIn(duration: 0.25)) {
                self.keyboardHeight = 0
            }
        }
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillHideNotification, object: nil)
    };

    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        // Add user message
        let userContent = messageText
        let userMsg = ChatMessage(
            id: UUID().uuidString,
            conversationId: "1",
            role: .user,
            content: userContent,
            createdAt: Date(),
            isRead: true
        )
        messages.append(userMsg)
        messageText = ""

        // 100% Mock Response Logic - Bypassing unreliable API
        let mockResponses = [
            "I'm here for you. It sounds like you're going through a lot right now.",
            "Thank you for sharing that with me. How can I best support you today?",
            "Remember that you're not alone. I'm always here to listen whenever you need to talk.",
            "That's a very brave thing to share. Setting small, achievable goals might help you feel more in control.",
            "I'm listening. Please continue if you'd like to share more about how you're feeling."
        ]
        
        // Simulate thinking time
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let randomResponse = mockResponses.randomElement() ?? "I understand. Tell me more."
            let aiMsg = ChatMessage(
                id: UUID().uuidString,
                conversationId: "1",
                role: .assistant,
                content: randomResponse,
                createdAt: Date(),
                isRead: true
            )
            withAnimation {
                messages.append(aiMsg)
            }
        }
    }
}

// MARK: - Subviews

struct ChatHeaderView: View {
    var body: some View {
        HStack(spacing: 15) {
            Color.clear.frame(width: 30, height: 30)

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
            HStack(alignment: .bottom, spacing: 12) {
                if !isUser {
                    Image("Mee_Good")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(message.content)
                        .font(.custom("Outfit-Regular", size: 15))
                        .foregroundColor(Color.mindHexColor("4A3422"))

                    if message.content.contains("1323") {
                        if let url = URL(string: "tel://1323") {
                            Link(destination: url) {
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
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    BubbleShape(isUser: isUser)
                        .fill(isUser ? Color.mindHexColor("FFF59D") : Color.white)
                )
                .overlay(
                    BubbleShape(isUser: isUser)
                        .stroke(isUser ? Color.clear : Color.mindHexColor("FF9F9F"), lineWidth: 1)
                )
                .padding(isUser ? .trailing : .leading, 10)  // Reserve space for the tail
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

                TextField("Write Here...", text: $messageText, axis: .vertical)
                    .lineLimit(1...5)
                    .foregroundColor(Color.mindHexColor("4A3422"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.mindHexColor("E6D5C3"), lineWidth: 1)
                    )

                Button(action: {}) {
                    Image(systemName: "microphone")
                        .foregroundColor(Color.mindHexColor("EB6538"))
                        .font(.title3)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }

                Button(action: onSend) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color.mindHexColor("EB6538"))
                        .font(.title3)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.mindHexColor("FDF1E5").opacity(0.5))
            )
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .background(Color.mindHexColor("FFF8E7"))
        // .offset(y: -100) // Removed manual offset
    }
}


#Preview {
    ChatView()
}
