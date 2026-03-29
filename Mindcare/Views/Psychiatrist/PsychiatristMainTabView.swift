import SwiftUI

struct PsychiatristMainTabView: View {
    @State private var selectedTab: Int = 0
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                PsychiatristDashboardView()
                    .tag(0)
                
                Text("Patients View Placeholder")
                    .tag(1)
                
                Text("Messages View Placeholder")
                    .tag(2)
                
                Text("Settings View Placeholder")
                    .tag(3)
            }
            
            // Custom Tab Bar
            HStack {
                TabItem(icon: "house.fill", label: "Dash Bord", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                
                Spacer()
                
                TabItem(icon: "person.2.fill", label: "Patients", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                
                Spacer()
                
                TabItem(icon: "bubble.left.and.bubble.right.fill", label: "Messages", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
                
                Spacer()
                
                TabItem(icon: "gearshape.fill", label: "Settings", isSelected: selectedTab == 3) {
                    selectedTab = 3
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 35)
                    .fill(Color(red: 1.0, green: 0.95, blue: 0.85))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct TabItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? Color(red: 0.93, green: 0.45, blue: 0.35) : .gray.opacity(0.6))
                
                Text(label)
                    .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? Color(red: 0.93, green: 0.45, blue: 0.35) : .gray.opacity(0.6))
            }
        }
    }
}

#Preview {
    PsychiatristMainTabView()
        .environmentObject(AuthService.shared)
}
