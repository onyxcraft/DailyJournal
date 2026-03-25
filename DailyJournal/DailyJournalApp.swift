import SwiftUI
import SwiftData

@main
struct DailyJournalApp: App {
    @StateObject private var authViewModel = AuthenticationViewModel()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            JournalEntry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .modelContainer(sharedModelContainer)
                .preferredColorScheme(nil)
        }
    }
}
