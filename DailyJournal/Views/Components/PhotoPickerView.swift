import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var selectedPhoto: PhotosPickerItem?
    @Binding var photoData: Data?

    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedPhoto,
                matching: .images
            ) {
                if let data = photoData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(12)
                } else {
                    Label("Add Photo", systemImage: "photo.on.rectangle")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(12)
                }
            }
        }
    }
}

#Preview {
    PhotoPickerView(
        selectedPhoto: .constant(nil),
        photoData: .constant(nil)
    )
    .padding()
}
