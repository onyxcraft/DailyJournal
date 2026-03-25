import Foundation
import UIKit
import PDFKit

class ExportService {
    static let shared = ExportService()

    private init() {}

    func exportAsPDF(entries: [JournalEntry]) -> URL? {
        let pdfMetaData = [
            kCGPDFContextCreator: "DailyJournal",
            kCGPDFContextAuthor: "User",
            kCGPDFContextTitle: "Journal Entries"
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let margin: CGFloat = 72.0

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { context in
            for entry in entries.sorted(by: { $0.date > $1.date }) {
                context.beginPage()

                var currentY: CGFloat = margin

                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 18)
                ]
                let dateTitle = entry.date.fullDateString
                let titleSize = dateTitle.size(withAttributes: titleAttributes)
                dateTitle.draw(
                    at: CGPoint(x: margin, y: currentY),
                    withAttributes: titleAttributes
                )
                currentY += titleSize.height + 10

                if let mood = entry.mood {
                    let moodAttributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 14)
                    ]
                    let moodText = "Mood: \(mood.rawValue) \(mood.name)"
                    let moodSize = moodText.size(withAttributes: moodAttributes)
                    moodText.draw(
                        at: CGPoint(x: margin, y: currentY),
                        withAttributes: moodAttributes
                    )
                    currentY += moodSize.height + 20
                }

                let bodyAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 12)
                ]

                let textRect = CGRect(
                    x: margin,
                    y: currentY,
                    width: pageWidth - 2 * margin,
                    height: pageHeight - currentY - margin
                )

                entry.content.draw(in: textRect, withAttributes: bodyAttributes)
            }
        }

        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("journal_export_\(Date().timeIntervalSince1970).pdf")

        do {
            try data.write(to: tempURL)
            return tempURL
        } catch {
            print("Failed to save PDF: \(error)")
            return nil
        }
    }

    func exportAsText(entries: [JournalEntry]) -> URL? {
        var text = "DailyJournal Export\n"
        text += "Generated: \(Date().fullDateString)\n"
        text += String(repeating: "=", count: 50) + "\n\n"

        for entry in entries.sorted(by: { $0.date > $1.date }) {
            text += "\(entry.date.fullDateString)\n"

            if let mood = entry.mood {
                text += "Mood: \(mood.rawValue) \(mood.name)\n"
            }

            text += "\n\(entry.content)\n\n"
            text += String(repeating: "-", count: 50) + "\n\n"
        }

        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("journal_export_\(Date().timeIntervalSince1970).txt")

        do {
            try text.write(to: tempURL, atomically: true, encoding: .utf8)
            return tempURL
        } catch {
            print("Failed to save text file: \(error)")
            return nil
        }
    }
}
