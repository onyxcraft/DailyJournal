import Foundation
import SwiftUI

enum Mood: String, Codable, CaseIterable {
    case amazing = "😄"
    case happy = "😊"
    case good = "🙂"
    case neutral = "😐"
    case sad = "😔"
    case stressed = "😰"
    case angry = "😠"
    case anxious = "😟"
    case calm = "😌"
    case excited = "🤩"

    var name: String {
        switch self {
        case .amazing: return "Amazing"
        case .happy: return "Happy"
        case .good: return "Good"
        case .neutral: return "Neutral"
        case .sad: return "Sad"
        case .stressed: return "Stressed"
        case .angry: return "Angry"
        case .anxious: return "Anxious"
        case .calm: return "Calm"
        case .excited: return "Excited"
        }
    }

    var color: Color {
        switch self {
        case .amazing: return .green
        case .happy: return .mint
        case .good: return .blue
        case .neutral: return .gray
        case .sad: return .indigo
        case .stressed: return .orange
        case .angry: return .red
        case .anxious: return .purple
        case .calm: return .teal
        case .excited: return .yellow
        }
    }
}
