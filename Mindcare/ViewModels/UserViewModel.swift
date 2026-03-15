import Combine
import Foundation

class UserViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var location: String = "Chonburi, Thailand"

    private let authService = AuthService.shared
    private var cancellables = Set<Set<AnyCancellable>>()

    init() {
        // Initialize with default or current user from AuthService
        if let current = authService.currentUser {
            self.userProfile = current
            self.name = current.name
            self.email = current.email
        } else {
            // Mock initial data if no user is logged in (for demo)
            let mockUser = UserProfile(
                id: "user-123",
                email: "elena@example.com",
                name: "Elena Rodriguez",
                avatar: "Profile",
                role: .patient,
                createdAt: Date()
            )
            self.userProfile = mockUser
            self.name = mockUser.name
            self.email = mockUser.email
        }
    }

    func updateProfile(newName: String, newEmail: String, newLocation: String) {
        // Mock update logic
        self.name = newName
        self.email = newEmail
        self.location = newLocation

        if var current = userProfile {
            current.name = newName
            current.email = newEmail
            // We could also update location if UserProfile had that field,
            // but for now we keep it in the VM for the UI demo.
            self.userProfile = current

            // Sync back to AuthService if needed
            authService.currentUser = current
        }
    }

    func signOut() {
        authService.isAuthenticated = false
        authService.currentUser = nil
    }
}
