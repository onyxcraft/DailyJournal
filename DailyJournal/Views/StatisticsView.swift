import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var viewModel: JournalViewModel
    @State private var selectedPeriod: StatisticsPeriod = .month

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    StreakView(
                        currentStreak: viewModel.currentStreak,
                        longestStreak: viewModel.longestStreak
                    )

                    summaryCards

                    moodDistributionSection

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Statistics")
        }
    }

    private var summaryCards: some View {
        HStack(spacing: 15) {
            StatCard(
                title: "Total Entries",
                value: "\(viewModel.entries.count)",
                icon: "book.fill",
                color: .blue
            )

            StatCard(
                title: "This Month",
                value: "\(viewModel.getEntriesForMonth(date: Date()).count)",
                icon: "calendar",
                color: .green
            )
        }
    }

    private var moodDistributionSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Mood Distribution")
                    .font(.headline)

                Spacer()

                Picker("Period", selection: $selectedPeriod) {
                    Text("Week").tag(StatisticsPeriod.week)
                    Text("Month").tag(StatisticsPeriod.month)
                }
                .pickerStyle(.segmented)
                .frame(width: 150)
            }

            let distribution = viewModel.getMoodDistribution(for: selectedPeriod)

            if distribution.isEmpty {
                Text("No mood data for this period")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                Chart {
                    ForEach(Array(distribution.keys.sorted(by: { $0.name < $1.name })), id: \.self) { mood in
                        BarMark(
                            x: .value("Count", distribution[mood] ?? 0),
                            y: .value("Mood", mood.name)
                        )
                        .foregroundStyle(mood.color.gradient)
                        .annotation(position: .trailing) {
                            Text("\(distribution[mood] ?? 0)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(height: 300)
                .chartXAxis {
                    AxisMarks(position: .bottom)
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    StatisticsView(viewModel: JournalViewModel())
}
