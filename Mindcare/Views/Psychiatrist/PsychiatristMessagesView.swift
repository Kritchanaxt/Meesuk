import SwiftUI

struct PsychiatristMessagesView: View {
    @State private var searchText = ""
    @State private var selectedChat: ChatMock? = nil
    
    // Mock Conversations
    let conversations = [
        ChatMock(name: "John Doe", lastMessage: "Thank you for the session, doctor.", time: "10:30 AM", unread: 2),
        ChatMock(name: "Jane Smith", lastMessage: "I'm feeling much better today.", time: "Yesterday", unread: 0),
        ChatMock(name: "Alice Cooper", lastMessage: "Can we reschedule our meeting?", time: "Monday", unread: 1),
        ChatMock(name: "Robert Brown", lastMessage: "The exercises are helping me a lot.", time: "25 Mar", unread: 0),
        ChatMock(name: "Emily Davis", lastMessage: "I have a question about the medication.", time: "22 Mar", unread: 0)
    ]
    
    var filteredConversations: [ChatMock] {
        if searchText.isEmpty {
            return conversations
        } else {
            return conversations.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 15) {
                Text("Messages")
                    .font(.custom("Outfit-Bold", size: 28))
                    .foregroundColor(Color.mindHexColor("4A3422"))
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.mindHexColor("9A8B7F"))
                    TextField("Search conversations...", text: $searchText)
                        .font(.custom("Outfit-Regular", size: 16))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal, 25)
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(filteredConversations) { chat in
                        ChatMessageCell(chat: chat) {
                            selectedChat = chat
                        }
                        
                        if chat.id != filteredConversations.last?.id {
                            Divider()
                                .padding(.leading, 85)
                                .padding(.trailing, 25)
                                .opacity(0.5)
                        }
                    }
                }
                .padding(.bottom, 120)
            }
        }
        .background(Color.mindHexColor("FFF8E7").ignoresSafeArea())
        .fullScreenCover(item: $selectedChat) { chat in
            PsychiatristPatientChatView(patientName: chat.name)
        }
    }
}

struct ChatMessageCell: View {
    let chat: ChatMock
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color.mindHexColor("FDF1E5"))
                        .frame(width: 60, height: 60)
                    
                    Text(chat.name.prefix(1))
                        .font(.custom("Outfit-Bold", size: 24))
                        .foregroundColor(Color.mindHexColor("EB6538"))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(chat.name)
                            .font(.custom("Outfit-Bold", size: 17))
                            .foregroundColor(Color.mindHexColor("4A3422"))
                        
                        Spacer()
                        
                        Text(chat.time)
                            .font(.custom("Outfit-Medium", size: 12))
                            .foregroundColor(Color.mindHexColor("9A8B7F"))
                    }
                    
                    HStack {
                        Text(chat.lastMessage)
                            .font(.custom("Outfit-Regular", size: 14))
                            .foregroundColor(Color.mindHexColor("7C6A5B"))
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if chat.unread > 0 {
                            Text("\(chat.unread)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.mindHexColor("EB6538"))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 15)
            .background(Color.clear)
        }
    }
}

struct ChatMock: Identifiable {
    let id = UUID()
    let name: String
    let lastMessage: String
    let time: String
    let unread: Int
}

#Preview {
    PsychiatristMessagesView()
}
