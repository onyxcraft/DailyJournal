import Foundation

struct StreakCalculator {
    func calculateStreaks(from entries: [JournalEntry]) -> (current: Int, longest: Int) {
        guard !entries.isEmpty else { return (0, 0) }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let sortedDates = entries
            .map { calendar.startOfDay(for: $0.date) }
            .sorted(by: >)
            .removingDuplicates()

        var currentStreak = 0
        var longestStreak = 0
        var tempStreak = 0
        var expectedDate = today

        for date in sortedDates {
            if calendar.isDate(date, inSameDayAs: expectedDate) {
                tempStreak += 1
                if date == today || calendar.isDate(date, inSameDayAs: today.addingTimeInterval(-86400)) {
                    currentStreak = tempStreak
                }
                expectedDate = calendar.date(byAdding: .day, value: -1, to: expectedDate)!
            } else {
                longestStreak = max(longestStreak, tempStreak)
                tempStreak = 1
                expectedDate = calendar.date(byAdding: .day, value: -1, to: date)!
            }
        }

        longestStreak = max(longestStreak, tempStreak)

        if !calendar.isDate(sortedDates.first!, inSameDayAs: today) &&
           !calendar.isDate(sortedDates.first!, inSameDayAs: today.addingTimeInterval(-86400)) {
            currentStreak = 0
        }

        return (currentStreak, longestStreak)
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
