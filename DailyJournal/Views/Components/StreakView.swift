import SwiftUI

struct StreakView: View {
    let currentStreak: Int
    let longestStreak: Int

    var body: some View {
        HStack(spacing: 20) {
            StreakCard(
                title: "Current Streak",
                value: currentStreak,
                icon: "flame.fill",
                color: .orange
            )

            StreakCard(
                title: "Longest Streak",
                value: longestStreak,
                icon: "star.fill",
                color: .yellow
            )
        }
    }
}

struct StreakCard: View {
    let title: String
    let value: Int
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text("\(value)")
                    .font(.title)
                    .fontWeight(.bold)
            }

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
    StreakView(currentStreak: 7, longestStreak: 15)
        .padding()
}
