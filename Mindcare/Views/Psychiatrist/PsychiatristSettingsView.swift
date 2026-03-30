import SwiftUI

struct PsychiatristSettingsView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                // Profile Section
                VStack(spacing: 15) {
                    Image("Dr") // Asset: Session2/Page1_Dashboard/Dr
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .background(Color.mindHexColor("FDF1E5"))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    VStack(spacing: 4) {
                        Text(authService.currentUser?.name ?? "Demo Doctor")
                            .font(.custom("Outfit-Bold", size: 24))
                            .foregroundColor(Color.mindHexColor("4A3422"))
                        Text("Senior Psychiatrist")
                            .font(.custom("Outfit-Medium", size: 16))
                            .foregroundColor(Color.mindHexColor("3498DB"))
                    }
                    
                    Button(action: {}) {
                        Text("Edit Profile")
                            .font(.custom("Outfit-Bold", size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 10)
                            .background(Color.mindHexColor("EB6538"))
                            .cornerRadius(20)
                    }
                }
                .padding(.top, 40)
                
                // Settings Groups
                VStack(spacing: 20) {
                    SettingsSection(title: "Clinical Settings") {
                        SettingsRow(icon: "clock.fill", title: "Working Hours", color: .blue)
                        SettingsRow(icon: "calendar.badge.clock", title: "Appointments Management", color: .orange)
                        SettingsRow(icon: "doc.text.fill", title: "Prescription Templates", color: .green)
                    }
                    
                    SettingsSection(title: "App Settings") {
                        SettingsRow(icon: "bell.fill", title: "Notifications", color: .red)
                        SettingsRow(icon: "lock.fill", title: "Privacy & Security", color: .purple)
                        SettingsRow(icon: "globe", title: "Language", color: .gray)
                    }
                    
                    SettingsSection(title: "Support") {
                        SettingsRow(icon: "questionmark.circle.fill", title: "Help Center", color: .blue)
                        SettingsRow(icon: "info.circle.fill", title: "About Mindcare", color: .gray)
                    }
                    
                    // Logout
                    Button(action: {
                        Task {
                            await authService.logout()
                        }
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Logout")
                                .font(.custom("Outfit-Bold", size: 16))
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(15)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 120)
            }
        }
        .background(Color.mindHexColor("FFF8E7").ignoresSafeArea())
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom("Outfit-Bold", size: 14))
                .foregroundColor(Color.mindHexColor("9A8B7F"))
                .textCase(.uppercase)
                .padding(.leading, 10)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.02), radius: 8, x: 0, y: 4)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.custom("Outfit-Medium", size: 16))
                    .foregroundColor(Color.mindHexColor("4A3422"))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.mindHexColor("D0C0B0"))
            }
            .padding()
        }
    }
}

#Preview {
    PsychiatristSettingsView()
        .environmentObject(AuthService.shared)
}
