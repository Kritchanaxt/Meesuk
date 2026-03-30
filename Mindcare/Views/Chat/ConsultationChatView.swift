import SwiftUI
import Combine

struct ConsultationChatView: View {
    @StateObject private var viewModel = ConsultationViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ConsultationHeaderView(name: "Dr. Julian Vance", status: "Active now", avatar: "Dr_img") {
                dismiss()
            }
            
            // Chat Messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        Text("TODAY")
                            .font(.custom("Outfit-Bold", size: 12))
                            .foregroundColor(Color.gray.opacity(0.6))
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(
                                Capsule()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: 80, height: 24)
                            )
                        
                        ForEach(viewModel.messages) { message in
                            ConsultationMessageRow(message: message)
                                .id(message.id)
                        }
                        
                        if viewModel.isTyping {
                            TypingIndicatorRow()
                                .padding(.leading, 20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                    }
                }
            }
            .background(Color.white)
            
            // Input Area
            ConsultationInputArea(
                messageText: $viewModel.messageText,
                onSend: { viewModel.sendMessage() },
                onVoice: { viewModel.sendVoiceMock() }
            )
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - Header
struct ConsultationHeaderView: View {
    let name: String
    let status: String
    let avatar: String
    var onBack: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.mindHexColor("4A3422"))
                    .font(.title2)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.custom("Outfit-Bold", size: 18))
                    .foregroundColor(Color.mindHexColor("4A3422"))
                
                HStack(spacing: 5) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text(status)
                        .font(.custom("Outfit-Regular", size: 13))
                        .foregroundColor(Color.gray)
                }
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: {}) {
                    Image(systemName: "video.fill")
                        .foregroundColor(Color.mindHexColor("3498DB"))
                        .padding(10)
                        .background(Color.mindHexColor("F0F7FF"))
                        .clipShape(Circle())
                }
                
                Button(action: {}) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(Color.mindHexColor("3498DB"))
                        .padding(10)
                        .background(Color.mindHexColor("F0F7FF"))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Message Row
struct ConsultationMessageRow: View {
    let message: ConsultationMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if !message.isFromUser {
                Image(message.senderAvatar ?? "Dr_img")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    .padding(.bottom, 20)
            } else {
                Spacer()
            }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 5) {
                if !message.isFromUser {
                    Text(message.senderName)
                        .font(.custom("Outfit-Medium", size: 12))
                        .foregroundColor(Color.gray)
                        .padding(.leading, 5)
                }
                
                if message.messageType == .voice {
                    VoiceMessageBubble(isUser: message.isFromUser)
                } else {
                    Text(message.content)
                        .font(.custom("Outfit-Regular", size: 15))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            BubbleShape(isUser: message.isFromUser)
                                .fill(message.isFromUser ? Color.mindHexColor("3498DB") : Color.mindHexColor("F2F4F7"))
                        )
                        .foregroundColor(message.isFromUser ? .white : Color.mindHexColor("4A3422"))
                }
                
                HStack(spacing: 4) {
                    Text(message.createdAt.formatted(.dateTime.hour().minute()))
                    if message.isFromUser {
                        Text("•")
                        Text("Read")
                    }
                }
                .font(.custom("Outfit-Regular", size: 10))
                .foregroundColor(Color.gray.opacity(0.7))
                .padding(.horizontal, 5)
            }
            
            if !message.isFromUser {
                Spacer()
            }
        }
    }
}

// MARK: - Voice Message Bubble
struct VoiceMessageBubble: View {
    let isUser: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "play.fill")
                .foregroundColor(isUser ? .white : Color.mindHexColor("3498DB"))
            
            // Simulated waveform
            HStack(spacing: 2) {
                ForEach(0..<15) { _ in
                    Capsule()
                        .fill(isUser ? .white : Color.mindHexColor("3498DB"))
                        .frame(width: 2, height: CGFloat.random(in: 4...16))
                }
            }
            
            Text("0:14")
                .font(.custom("Outfit-Bold", size: 12))
                .foregroundColor(isUser ? .white : Color.mindHexColor("3498DB"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            BubbleShape(isUser: isUser)
                .fill(isUser ? Color.mindHexColor("3498DB") : Color.mindHexColor("F2F4F7"))
        )
    }
}

// MARK: - Typing Indicator
struct TypingIndicatorRow: View {
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image("Dr_img")
                .resizable()
                .frame(width: 28, height: 28)
                .clipShape(Circle())
            
            HStack(spacing: 4) {
                Text("Typing...")
                    .font(.custom("Outfit-Italic", size: 14))
                    .foregroundColor(Color.gray)
                
                DotAnimation()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.mindHexColor("F2F4F7"))
            .cornerRadius(15)
        }
    }
}

struct DotAnimation: View {
    @State private var dotCount = 0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(String(repeating: ".", count: dotCount))
            .onReceive(timer) { _ in
                dotCount = (dotCount + 1) % 4
            }
    }
}

// MARK: - Input Area
struct ConsultationInputArea: View {
    @Binding var messageText: String
    var onSend: () -> Void
    var onVoice: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundColor(Color.gray)
                        .padding(8)
                        .background(Color.mindHexColor("F2F4F7"))
                        .clipShape(Circle())
                }
                
                TextField("Share how you're feeling...", text: $messageText)
                    .font(.custom("Outfit-Regular", size: 15))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color.mindHexColor("F2F4F7"))
                    .cornerRadius(20)
                
                Button(action: onVoice) {
                    Image(systemName: "mic.fill")
                        .foregroundColor(Color.gray)
                        .font(.title3)
                }
                
                Button(action: onSend) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                        .padding(10)
                        .background(Color.mindHexColor("3498DB"))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.white)
        }
    }
}

#Preview {
    ConsultationChatView()
}
