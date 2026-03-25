import Foundation

class PromptService {
    static let shared = PromptService()

    private let prompts = [
        "What made you smile today?",
        "What are you grateful for right now?",
        "Describe a challenge you faced today and how you handled it.",
        "What's something new you learned today?",
        "Write about a person who made your day better.",
        "What are you looking forward to tomorrow?",
        "Reflect on a moment when you felt proud of yourself.",
        "What would you like to improve about yourself?",
        "Describe your perfect day from start to finish.",
        "What's a goal you're working towards?",
        "Write about a favorite memory from this week.",
        "What's something that's been on your mind lately?",
        "How did you take care of yourself today?",
        "What's a small win you had today?",
        "Describe how you're feeling in this moment.",
        "What advice would you give your younger self?",
        "Write about something that inspired you recently.",
        "What are three things that brought you joy this week?",
        "How have you grown in the past month?",
        "What's a habit you'd like to develop?",
        "Describe a conversation that meant something to you.",
        "What's something you're proud of accomplishing?",
        "Write about a place that makes you feel peaceful.",
        "What's been the highlight of your week?",
        "How did you overcome a difficulty recently?",
        "What's something you're curious about?",
        "Describe a moment when you felt truly content.",
        "What's a lesson you learned from a mistake?",
        "Write about someone you appreciate and why.",
        "What are you most passionate about right now?",
    ]

    private init() {}

    func getRandomPrompt() -> String {
        prompts.randomElement() ?? "How are you feeling today?"
    }

    func getDailyPrompt() -> String {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let index = dayOfYear % prompts.count
        return prompts[index]
    }
}
