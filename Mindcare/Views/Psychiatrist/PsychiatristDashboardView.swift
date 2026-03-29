import SwiftUI

struct PsychiatristDashboardView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                // MARK: - Header
                HStack(spacing: 15) {
                    Image("Dr") // Using the "Dr" asset found in Session2/Page5_Profile
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .background(Color(red: 0.98, green: 0.92, blue: 0.75))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Good Morning.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("Dr. Aris Thorne, MD")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
                    }
                    
                    Spacer()
                    
                    // Notification Bell
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 45, height: 45)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        
                        Image(systemName: "bell")
                            .font(.system(size: 18))
                            .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
                        
                        Circle()
                            .fill(Color(red: 0.93, green: 0.45, blue: 0.35))
                            .frame(width: 8, height: 8)
                            .offset(x: 8, y: -8)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // MARK: - Stats Cards
                HStack(spacing: 20) {
                    StatCard(
                        title: "ACTIVE PATIENTS",
                        value: "48",
                        trend: "+10",
                        icon: "person.2.fill",
                        trendColor: .green
                    )
                    
                    StatCard(
                        title: "UPCOMING SESSION",
                        value: "10",
                        trend: "+10",
                        icon: "calendar.badge.clock",
                        trendColor: .blue
                    )
                }
                .padding(.horizontal, 20)
                
                // MARK: - Today's Schedule
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Today’s Schedule")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
                        
                        Spacer()
                        
                        Button("View Calendar") {
                            // Action
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) {
                        // Marcus A...
                        ScheduleItem(
                            imageName: "Patient1",
                            name: "Marcus A...",
                            time: "10:00 AM - 11:00 AM",
                            status: "LIVE NOW",
                            hasActionButton: true
                        )
                        
                        // Sonia Gupta
                        ScheduleItem(
                            imageName: "Patient2",
                            name: "Sonia Gupta",
                            time: "01:30 PM - 02:30 PM",
                            status: "In 2h",
                            hasActionButton: false
                        )
                    }
                    .padding(.horizontal, 20)
                }
                
                // MARK: - Patient Updates
                VStack(alignment: .leading, spacing: 15) {
                    Text("Patient Updates")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 0) {
                        UpdateItem(
                            imageName: "Patient3",
                            name: "Leo Thompsona",
                            description: "• New Shared Journal"
                        )
                        
                        Divider().padding(.leading, 80)
                        
                        UpdateItem(
                            imageName: "Patient4",
                            name: "Elena Rodriguez",
                            description: "• New Message (2)",
                            isHighlight: true
                        )
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.02), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                    .frame(height: 100) // Space for TabBar
            }
            .padding(.vertical, 20)
        }
        .background(Color(red: 1.0, green: 0.97, blue: 0.88).ignoresSafeArea())
    }
}

// MARK: - Components

struct StatCard: View {
    let title: String
    let value: String
    let trend: String
    let icon: String
    let trendColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(trend)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(trendColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(trendColor.opacity(0.1))
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(red: 1.0, green: 0.95, blue: 0.88))
                .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
        )
    }
}

struct ScheduleItem: View {
    let imageName: String
    let name: String
    let time: String
    let status: String
    let hasActionButton: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "person.circle.fill") // Use system icon as fallback
                .resizable()
                .frame(width: 55, height: 55)
                .foregroundColor(.gray.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
                    
                    if status == "LIVE NOW" {
                        Text(status)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.orange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                            )
                    }
                }
                
                Text(time)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if hasActionButton {
                Button("Join Call") {
                    // Action
                }
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color(red: 1.0, green: 0.92, blue: 0.88))
                .cornerRadius(18)
            } else {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(status)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(red: 1.0, green: 0.95, blue: 0.88))
        )
    }
}

struct UpdateItem: View {
    let imageName: String
    let name: String
    let description: String
    var isHighlight: Bool = false
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "person.circle.fill") // Use system icon as fallback
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(isHighlight ? .blue : .gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.orange)
        }
        .padding(15)
    }
}

#Preview {
    PsychiatristDashboardView()
        .environmentObject(AuthService.shared)
}
