import Combine
import Foundation

class UserViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var location: String = "Chonburi, Thailand"
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let authService = AuthService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        if let current = authService.currentUser {
            self.userProfile = current
            self.name = current.name
            self.email = current.email
        }
    }
    
    @MainActor
    func fetchProfile() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let profile = try await APIService.shared.getProfile()
            self.userProfile = profile
            self.name = profile.name
            self.email = profile.email
            self.authService.currentUser = profile
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error fetching profile: \(error)")
        }
    }

    @MainActor
    func updateProfile(newName: String, newEmail: String, newLocation: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            var request = UpdateProfileRequest()
            request.name = newName
            
            let updatedProfile = try await APIService.shared.updateProfile(request)
            
            self.userProfile = updatedProfile
            self.name = updatedProfile.name
            self.email = updatedProfile.email
            self.location = newLocation // if location gets added to API later
            self.authService.currentUser = updatedProfile
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error updating profile: \(error)")
        }
    }

    func signOut() {
        authService.isAuthenticated = false
        authService.currentUser = nil
    }
}
