import Foundation
import SwiftData

@Model
final class JournalEntry {
    var id: UUID
    var date: Date
    var content: String
    var mood: Mood?
    @Attribute(.externalStorage) var photoData: Data?
    var isBold: Bool
    var isItalic: Bool
    var isList: Bool

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        content: String = "",
        mood: Mood? = nil,
        photoData: Data? = nil,
        isBold: Bool = false,
        isItalic: Bool = false,
        isList: Bool = false
    ) {
        self.id = id
        self.date = date
        self.content = content
        self.mood = mood
        self.photoData = photoData
        self.isBold = isBold
        self.isItalic = isItalic
        self.isList = isList
    }

    var dateWithoutTime: Date {
        Calendar.current.startOfDay(for: date)
    }
}
