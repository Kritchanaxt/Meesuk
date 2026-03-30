import SwiftUI

struct PsychiatristPatientChatView: View {
    @Environment(\.dismiss) var dismiss
    let patientName: String
    
    @State private var messageText = ""
    @State private var messages: [ChatMessageMock] = [
        ChatMessageMock(text: "Hello doctor, I've been feeling better since our last session.", isFromUser: false),
        ChatMessageMock(text: "That's great to hear! How are the exercises going?", isFromUser: true),
        ChatMessageMock(text: "They are helpful, but I still struggle with sleep sometimes.", isFromUser: false),
        ChatMessageMock(text: "I understand. Let's discuss some sleep hygiene techniques today.", isFromUser: true)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 15) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(Color.mindHexColor("4A3422"))
                }
                
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color.mindHexColor("FDF1E5"))
                        .frame(width: 40, height: 40)
                    Text(patientName.prefix(1))
                        .font(.custom("Outfit-Bold", size: 16))
                        .foregroundColor(Color.mindHexColor("EB6538"))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(patientName)
                        .font(.custom("Outfit-Bold", size: 16))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                    HStack(spacing: 4) {
                        Circle().fill(Color.green).frame(width: 6, height: 6)
                        Text("Online")
                            .font(.custom("Outfit-Regular", size: 12))
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "video.fill")
                        .foregroundColor(Color.mindHexColor("EB6538"))
                }
                .padding(.trailing, 5)
                
                Button(action: {}) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(Color.mindHexColor("EB6538"))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            // Chat Area
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(messages) { msg in
                            ChatBubble(message: msg)
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 20)
                }
                .background(Color.mindHexColor("FFF8E7"))
            }
            
            // Input Area
            HStack(spacing: 12) {
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color.mindHexColor("9A8B7F"))
                }
                
                TextField("Type a message...", text: $messageText)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color.mindHexColor("FDF6EC"))
                    .cornerRadius(25)
                
                Button(action: {
                    if !messageText.isEmpty {
                        messages.append(ChatMessageMock(text: messageText, isFromUser: true))
                        messageText = ""
                        
                        // Fake reply after 1 sec
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            messages.append(ChatMessageMock(text: "Thank you, doctor. I'll try that.", isFromUser: false))
                        }
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(Color.mindHexColor("EB6538"))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.white)
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessageMock
    
    var body: some View {
        HStack {
            if message.isFromUser { Spacer() }
            
            Text(message.text)
                .font(.custom("Outfit-Regular", size: 15))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(message.isFromUser ? Color.mindHexColor("EB6538") : Color.white)
                .foregroundColor(message.isFromUser ? .white : Color.mindHexColor("4A3422"))
                .cornerRadius(20, corners: message.isFromUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
            
            if !message.isFromUser { Spacer() }
        }
    }
}

struct ChatMessageMock: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
}

#Preview {
    PsychiatristPatientChatView(patientName: "John Doe")
}
