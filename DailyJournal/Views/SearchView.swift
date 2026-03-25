import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: JournalViewModel
    @State private var selectedEntry: JournalEntry?
    @State private var showingEditor = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.searchEntries()) { entry in
                    Button {
                        selectedEntry = entry
                        showingEditor = true
                    } label: {
                        EntryRow(entry: entry)
                    }
                }
                .onDelete(perform: deleteEntries)
            }
            .searchable(text: $viewModel.searchText, prompt: "Search your journal")
            .navigationTitle("Search")
            .sheet(isPresented: $showingEditor) {
                if let entry = selectedEntry {
                    EntryEditorView(
                        viewModel: viewModel,
                        date: entry.date,
                        entry: entry
                    )
                }
            }
            .overlay {
                if viewModel.entries.isEmpty {
                    ContentUnavailableView(
                        "No Entries Yet",
                        systemImage: "book.closed",
                        description: Text("Start journaling to see your entries here")
                    )
                } else if viewModel.searchEntries().isEmpty {
                    ContentUnavailableView.search
                }
            }
        }
    }

    private func deleteEntries(at offsets: IndexSet) {
        let entriesToDelete = offsets.map { viewModel.searchEntries()[$0] }
        for entry in entriesToDelete {
            viewModel.deleteEntry(entry)
        }
    }
}

struct EntryRow: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.date.shortDateString)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                if let mood = entry.mood {
                    HStack(spacing: 3) {
                        Text(mood.rawValue)
                            .font(.caption)
                        Circle()
                            .fill(mood.color)
                            .frame(width: 8, height: 8)
                    }
                }
            }

            Text(entry.content)
                .font(.body)
                .lineLimit(2)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SearchView(viewModel: JournalViewModel())
}
