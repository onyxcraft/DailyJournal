import Foundation
import SwiftData
import SwiftUI

@MainActor
class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var selectedDate: Date = Date()
    @Published var searchText: String = ""
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0

    private var modelContext: ModelContext?

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        fetchEntries()
        calculateStreaks()
    }

    func fetchEntries() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<JournalEntry>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )

        do {
            entries = try context.fetch(descriptor)
            calculateStreaks()
        } catch {
            print("Failed to fetch entries: \(error)")
        }
    }

    func getEntry(for date: Date) -> JournalEntry? {
        let calendar = Calendar.current
        return entries.first { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
    }

    func createOrUpdateEntry(
        for date: Date,
        content: String,
        mood: Mood?,
        photoData: Data?
    ) {
        guard let context = modelContext else { return }

        if let existingEntry = getEntry(for: date) {
            existingEntry.content = content
            existingEntry.mood = mood
            if let photoData = photoData {
                existingEntry.photoData = photoData
            }
        } else {
            let newEntry = JournalEntry(
                date: date,
                content: content,
                mood: mood,
                photoData: photoData
            )
            context.insert(newEntry)
        }

        do {
            try context.save()
            fetchEntries()
        } catch {
            print("Failed to save entry: \(error)")
        }
    }

    func deleteEntry(_ entry: JournalEntry) {
        guard let context = modelContext else { return }
        context.delete(entry)

        do {
            try context.save()
            fetchEntries()
        } catch {
            print("Failed to delete entry: \(error)")
        }
    }

    func searchEntries() -> [JournalEntry] {
        if searchText.isEmpty {
            return entries
        }
        return entries.filter { entry in
            entry.content.localizedCaseInsensitiveContains(searchText)
        }
    }

    func getEntriesForMonth(date: Date) -> [JournalEntry] {
        let calendar = Calendar.current
        return entries.filter { entry in
            calendar.isDate(entry.date, equalTo: date, toGranularity: .month)
        }
    }

    func getEntriesForWeek(date: Date) -> [JournalEntry] {
        let calendar = Calendar.current
        return entries.filter { entry in
            calendar.isDate(entry.date, equalTo: date, toGranularity: .weekOfYear)
        }
    }

    func calculateStreaks() {
        let calculator = StreakCalculator()
        let streaks = calculator.calculateStreaks(from: entries)
        currentStreak = streaks.current
        longestStreak = streaks.longest
    }

    func getMoodDistribution(for period: StatisticsPeriod) -> [Mood: Int] {
        let relevantEntries: [JournalEntry]

        switch period {
        case .week:
            relevantEntries = getEntriesForWeek(date: Date())
        case .month:
            relevantEntries = getEntriesForMonth(date: Date())
        }

        var distribution: [Mood: Int] = [:]
        for entry in relevantEntries {
            if let mood = entry.mood {
                distribution[mood, default: 0] += 1
            }
        }

        return distribution
    }
}

enum StatisticsPeriod {
    case week
    case month
}
