import SwiftUI

struct RichTextEditor: View {
    @Binding var text: String
    @State private var isBold = false
    @State private var isItalic = false
    @State private var isList = false

    var body: some View {
        VStack(spacing: 0) {
            toolbar

            TextEditor(text: $text)
                .font(textFont)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
        }
    }

    private var toolbar: some View {
        HStack(spacing: 15) {
            Button {
                isBold.toggle()
            } label: {
                Image(systemName: "bold")
                    .foregroundColor(isBold ? .accentColor : .secondary)
            }

            Button {
                isItalic.toggle()
            } label: {
                Image(systemName: "italic")
                    .foregroundColor(isItalic ? .accentColor : .secondary)
            }

            Button {
                isList.toggle()
            } label: {
                Image(systemName: "list.bullet")
                    .foregroundColor(isList ? .accentColor : .secondary)
            }

            Spacer()

            Text("\(text.count) characters")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.1))
    }

    private var textFont: Font {
        var font: Font = .body

        if isBold && isItalic {
            return .body.bold().italic()
        } else if isBold {
            return .body.bold()
        } else if isItalic {
            return .body.italic()
        }

        return font
    }
}

#Preview {
    RichTextEditor(text: .constant("Sample text"))
        .padding()
}
