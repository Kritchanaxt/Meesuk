import Foundation
import Combine

final class AppSession: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var role: UserRole = .patient
    @Published var currentUser: UserProfile?

    private var cancellables = Set<AnyCancellable>()

    func bootstrap() {
        // Mirror AuthService state
        AuthService.shared.$isAuthenticated
            .receive(on: RunLoop.main)
            .assign(to: &$isAuthenticated)

        AuthService.shared.$userRole
            .receive(on: RunLoop.main)
            .assign(to: &$role)

        AuthService.shared.$currentUser
            .receive(on: RunLoop.main)
            .assign(to: &$currentUser)
    }

    func logout() {
        Task { await AuthService.shared.logout() }
    }
}
