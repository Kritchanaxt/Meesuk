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
                        .padding(.bottom, 10) // Space for last message
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
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation(.easeOut(duration: 0.25)) {
                    self.keyboardHeight = keyboardFrame.height
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            withAnimation(.easeIn(duration: 0.25)) {
                self.keyboardHeight = 0
            }
        }
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }



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

        // Call API
        Task {
            do {
                // Call the test service
                let responseText = try await ChatTestService.shared.sendMessage(userContent)
                
                await MainActor.run {
                    let aiMsg = ChatMessage(
                        id: UUID().uuidString,
                        conversationId: "1",
                        role: .assistant,
                        content: responseText,
                        createdAt: Date(),
                        isRead: true
                    )
                    messages.append(aiMsg)
                }
            } catch {
                print("Error sending message: \(error)")
                await MainActor.run {
                     let errorMsg = ChatMessage(
                        id: UUID().uuidString,
                        conversationId: "1",
                        role: .assistant,
                        content: "Sorry, something went wrong. Please try again later. (Error: \(error.localizedDescription))",
                        createdAt: Date(),
                        isRead: true
                    )
                    messages.append(errorMsg)
                }
            }
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
                .background(
                    BubbleShape(isUser: isUser)
                        .fill(isUser ? Color.mindHexColor("FFF59D") : Color.white)
                )
                .overlay(
                    BubbleShape(isUser: isUser)
                        .stroke(isUser ? Color.clear : Color.mindHexColor("FF9F9F"), lineWidth: 1)
                )
                .padding(isUser ? .trailing : .leading, 10) // Reserve space for the tail
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

struct BubbleShape: Shape {
    let isUser: Bool
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        let r: CGFloat = 20
        
        if isUser {
            // User: Tail on right
            // Start top-left
            p.move(to: CGPoint(x: r, y: 0))
            
            // Top edge
            p.addLine(to: CGPoint(x: w - r, y: 0))
            
            // Top-right corner
            p.addArc(center: CGPoint(x: w - r, y: r), radius: r, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
            
            // Right edge to tail start
            p.addLine(to: CGPoint(x: w, y: h - 20))
            
            // Tail
            p.addLine(to: CGPoint(x: w + 10, y: h - 10))
            p.addLine(to: CGPoint(x: w, y: h))
            
            // Bottom edge
            p.addLine(to: CGPoint(x: r, y: h))
            
            // Bottom-left corner
            p.addArc(center: CGPoint(x: r, y: h - r), radius: r, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
            
            // Left edge
            p.addLine(to: CGPoint(x: 0, y: r))
            
            // Top-left corner
            p.addArc(center: CGPoint(x: r, y: r), radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
            
        } else {
            // Assistant: Tail on left
            let r: CGFloat = 20
            
            // Start top-left
            p.move(to: CGPoint(x: r, y: 0))
            
            // Top edge
            p.addLine(to: CGPoint(x: w - r, y: 0))
            
            // Top-right corner
            p.addArc(center: CGPoint(x: w - r, y: r), radius: r, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
            
            // Right edge
            p.addLine(to: CGPoint(x: w, y: h - r))

            // Bottom-right corner
            p.addArc(center: CGPoint(x: w - r, y: h - r), radius: r, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
            
            // Bottom edge
            p.addLine(to: CGPoint(x: r, y: h))
            
            // Bottom-left corner (with tail)
            p.addLine(to: CGPoint(x: 0, y: h))         // To corner
            p.addLine(to: CGPoint(x: -10, y: h - 10))  // Tail tip
            p.addLine(to: CGPoint(x: 0, y: h - 20))    // Back to side
            
            // Left edge
            p.addLine(to: CGPoint(x: 0, y: r))
            
            // Top-left corner
            p.addArc(center: CGPoint(x: r, y: r), radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        }
        
        return p
    }
}


#Preview {
    ChatView()
}
