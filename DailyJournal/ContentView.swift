import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        Group {
            if authViewModel.requiresAuthentication && !authViewModel.isAuthenticated {
                AuthenticationView()
            } else {
                HomeView()
            }
        }
        .task {
            if authViewModel.requiresAuthentication && !authViewModel.isAuthenticated {
                await authViewModel.authenticate()
            }
        }
    }
}

struct AuthenticationView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 80))
                .foregroundColor(.accentColor)

            Text("DailyJournal")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Your private journal")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let error = authViewModel.authenticationError {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            Button {
                Task {
                    await authViewModel.authenticate()
                }
            } label: {
                Label("Unlock", systemImage: "faceid")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationViewModel())
}
