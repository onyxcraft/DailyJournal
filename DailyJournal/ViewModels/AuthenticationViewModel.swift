import Foundation
import LocalAuthentication
import SwiftUI

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var authenticationError: String?
    @AppStorage("requiresAuthentication") var requiresAuthentication = true

    func authenticate() async {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            authenticationError = error?.localizedDescription ?? "Biometric authentication not available"
            isAuthenticated = true
            return
        }

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Unlock your journal"
            )

            if success {
                isAuthenticated = true
            }
        } catch {
            authenticationError = error.localizedDescription
            isAuthenticated = false
        }
    }

    func resetAuthentication() {
        isAuthenticated = false
    }
}
