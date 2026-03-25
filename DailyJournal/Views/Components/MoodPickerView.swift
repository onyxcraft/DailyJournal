import SwiftUI

struct MoodPickerView: View {
    @Binding var selectedMood: Mood?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("How are you feeling?")
                .font(.headline)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 15) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    Button {
                        if selectedMood == mood {
                            selectedMood = nil
                        } else {
                            selectedMood = mood
                        }
                    } label: {
                        VStack(spacing: 5) {
                            Text(mood.rawValue)
                                .font(.system(size: 32))

                            Text(mood.name)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedMood == mood ? mood.color.opacity(0.3) : Color.secondary.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedMood == mood ? mood.color : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    MoodPickerView(selectedMood: .constant(.happy))
}
