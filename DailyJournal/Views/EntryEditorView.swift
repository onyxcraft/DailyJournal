import SwiftUI
import PhotosUI

struct EntryEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JournalViewModel

    let date: Date
    let entry: JournalEntry?

    @State private var content: String
    @State private var selectedMood: Mood?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var showingImagePicker = false
    @State private var showingCamera = false

    init(viewModel: JournalViewModel, date: Date, entry: JournalEntry?) {
        self.viewModel = viewModel
        self.date = date
        self.entry = entry
        _content = State(initialValue: entry?.content ?? "")
        _selectedMood = State(initialValue: entry?.mood)
        _photoData = State(initialValue: entry?.photoData)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(date.fullDateString)
                        .font(.title2)
                        .fontWeight(.semibold)

                    MoodPickerView(selectedMood: $selectedMood)

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Add Photo")
                                .font(.headline)

                            Spacer()

                            Menu {
                                PhotosPicker(
                                    selection: $selectedPhoto,
                                    matching: .images
                                ) {
                                    Label("Choose from Library", systemImage: "photo.on.rectangle")
                                }

                                Button {
                                    showingCamera = true
                                } label: {
                                    Label("Take Photo", systemImage: "camera")
                                }

                                if photoData != nil {
                                    Button(role: .destructive) {
                                        photoData = nil
                                    } label: {
                                        Label("Remove Photo", systemImage: "trash")
                                    }
                                }
                            } label: {
                                Image(systemName: photoData == nil ? "photo.badge.plus" : "photo")
                                    .font(.title3)
                            }
                        }

                        if let data = photoData,
                           let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 250)
                                .cornerRadius(12)
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Entry")
                            .font(.headline)

                        RichTextEditor(text: $content)
                            .frame(minHeight: 300)
                    }
                }
                .padding()
            }
            .navigationTitle("Journal Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onChange(of: selectedPhoto) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }
            .sheet(isPresented: $showingCamera) {
                CameraView(photoData: $photoData)
            }
        }
    }

    private func saveEntry() {
        viewModel.createOrUpdateEntry(
            for: date,
            content: content,
            mood: selectedMood,
            photoData: photoData
        )
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    @Binding var photoData: Data?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                parent.photoData = image.jpegData(compressionQuality: 0.8)
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
