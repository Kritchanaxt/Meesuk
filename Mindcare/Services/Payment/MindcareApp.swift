import SwiftUI

@main
struct MindcareApp: App {
    @StateObject private var session = AppSession()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .preferredColorScheme(.light)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var session: AppSession

    var body: some View {
        Group {
            if session.isAuthenticated {
                switch session.role {
                case .patient:
                    PatientTabView()
                case .psychiatrist:
                    PsychiatristTabView()
                case .admin:
                    AdminManagementView()
                }
            } else {
                WelcomeView()
            }
        }
        .onAppear {
            session.bootstrap()
        }
    }
}
