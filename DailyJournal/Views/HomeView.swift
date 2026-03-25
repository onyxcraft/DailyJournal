import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = JournalViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView(viewModel: viewModel)
                .tabItem {
                    Label("Today", systemImage: "square.and.pencil")
                }
                .tag(0)

            CalendarView(viewModel: viewModel)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(1)

            SearchView(viewModel: viewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(2)

            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(3)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(4)
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
        }
    }
}

struct TodayView: View {
    @ObservedObject var viewModel: JournalViewModel
    @State private var showingEditor = false
    let promptService = PromptService.shared

    var todayEntry: JournalEntry? {
        viewModel.getEntry(for: Date())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    StreakView(
                        currentStreak: viewModel.currentStreak,
                        longestStreak: viewModel.longestStreak
                    )
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Today's Prompt")
                            .font(.headline)
                            .padding(.horizontal)

                        Text(promptService.getDailyPrompt())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }

                    if let entry = todayEntry {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Today's Entry")
                                    .font(.headline)

                                Spacer()

                                if let mood = entry.mood {
                                    HStack(spacing: 5) {
                                        Text(mood.rawValue)
                                            .font(.title2)
                                        Text(mood.name)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }

                            if let photoData = entry.photoData,
                               let uiImage = UIImage(data: photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 200)
                                    .cornerRadius(12)
                            }

                            Text(entry.content)
                                .font(.body)

                            Button {
                                showingEditor = true
                            } label: {
                                Label("Edit Entry", systemImage: "pencil")
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    } else {
                        Button {
                            showingEditor = true
                        } label: {
                            Label("Write Today's Entry", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationTitle("DailyJournal")
            .sheet(isPresented: $showingEditor) {
                EntryEditorView(
                    viewModel: viewModel,
                    date: Date(),
                    entry: todayEntry
                )
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
