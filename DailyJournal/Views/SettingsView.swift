import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = JournalViewModel()

    @State private var showingExportOptions = false
    @State private var showingShareSheet = false
    @State private var exportURL: URL?
    @AppStorage("requiresAuthentication") private var requiresAuth = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Privacy") {
                    Toggle("Require Face ID / Touch ID", isOn: $requiresAuth)
                        .onChange(of: requiresAuth) { oldValue, newValue in
                            authViewModel.requiresAuthentication = newValue
                            if !newValue {
                                authViewModel.isAuthenticated = true
                            }
                        }
                }

                Section("Export") {
                    Button {
                        showingExportOptions = true
                    } label: {
                        Label("Export Journal", systemImage: "square.and.arrow.up")
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Build")
                        Spacer()
                        Text("1")
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    Link(destination: URL(string: "https://github.com")!) {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                    }

                    Link(destination: URL(string: "https://github.com")!) {
                        Label("Terms of Service", systemImage: "doc.text.fill")
                    }
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog("Export Format", isPresented: $showingExportOptions) {
                Button("Export as PDF") {
                    exportAsPDF()
                }

                Button("Export as Text") {
                    exportAsText()
                }

                Button("Cancel", role: .cancel) {}
            }
            .sheet(isPresented: $showingShareSheet) {
                if let url = exportURL {
                    ShareSheet(items: [url])
                }
            }
            .onAppear {
                viewModel.setModelContext(modelContext)
            }
        }
    }

    private func exportAsPDF() {
        if let url = ExportService.shared.exportAsPDF(entries: viewModel.entries) {
            exportURL = url
            showingShareSheet = true
        }
    }

    private func exportAsText() {
        if let url = ExportService.shared.exportAsText(entries: viewModel.entries) {
            exportURL = url
            showingShareSheet = true
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SettingsView()
        .environmentObject(AuthenticationViewModel())
}
