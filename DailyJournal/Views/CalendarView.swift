import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: JournalViewModel
    @State private var selectedMonth = Date()
    @State private var selectedDate: Date?
    @State private var showingEditor = false

    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                monthNavigator

                dayOfWeekHeader

                calendarGrid

                if let date = selectedDate {
                    entryPreview(for: date)
                }

                Spacer()
            }
            .navigationTitle("Calendar")
            .sheet(isPresented: $showingEditor) {
                if let date = selectedDate {
                    EntryEditorView(
                        viewModel: viewModel,
                        date: date,
                        entry: viewModel.getEntry(for: date)
                    )
                }
            }
        }
    }

    private var monthNavigator: some View {
        HStack {
            Button {
                selectedMonth = calendar.date(byAdding: .month, value: -1, to: selectedMonth)!
            } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text(selectedMonth.monthYearString)
                .font(.headline)

            Spacer()

            Button {
                selectedMonth = calendar.date(byAdding: .month, value: 1, to: selectedMonth)!
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
    }

    private var dayOfWeekHeader: some View {
        HStack(spacing: 0) {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
    }

    private var calendarGrid: some View {
        let days = getDaysInMonth()
        let columns = Array(repeating: GridItem(.flexible()), count: 7)

        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(days, id: \.self) { date in
                if let date = date {
                    dayCell(for: date)
                } else {
                    Color.clear
                        .frame(height: 50)
                }
            }
        }
        .padding()
    }

    private func dayCell(for date: Date) -> some View {
        let entry = viewModel.getEntry(for: date)
        let isToday = calendar.isDateInToday(date)
        let isSelected = selectedDate?.isSameDay(as: date) == true

        return Button {
            selectedDate = date
        } label: {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.system(size: 16))
                    .foregroundColor(isToday ? .white : .primary)

                if entry != nil {
                    Circle()
                        .fill(entry?.mood?.color ?? .accentColor)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isToday ? Color.accentColor : (isSelected ? Color.secondary.opacity(0.2) : Color.clear))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
    }

    private func entryPreview(for date: Date) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(date.shortDateString)
                    .font(.headline)

                Spacer()

                if let entry = viewModel.getEntry(for: date) {
                    if let mood = entry.mood {
                        HStack(spacing: 5) {
                            Text(mood.rawValue)
                            Text(mood.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            if let entry = viewModel.getEntry(for: date) {
                Text(entry.content)
                    .font(.body)
                    .lineLimit(3)

                Button {
                    showingEditor = true
                } label: {
                    Label("Edit Entry", systemImage: "pencil")
                }
                .buttonStyle(.bordered)
            } else {
                Text("No entry for this day")
                    .font(.body)
                    .foregroundColor(.secondary)

                Button {
                    showingEditor = true
                } label: {
                    Label("Create Entry", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
        .padding()
    }

    private func getDaysInMonth() -> [Date?] {
        let firstDayOfMonth = selectedMonth.startOfMonth
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let daysInMonth = selectedMonth.daysInMonth()

        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)

        for day in 0..<daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day, to: firstDayOfMonth) {
                days.append(date)
            }
        }

        return days
    }
}
