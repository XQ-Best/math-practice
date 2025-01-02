import Foundation

struct AchievementRecord: Codable, Identifiable {
    let id: UUID
    let date: Date
    let gameDetails: String
    let difficulty: String
    let timeSpent: TimeInterval
    
    init(date: Date = Date(),
         gameDetails: String,
         difficulty: String,
         timeSpent: TimeInterval) {
        self.id = UUID()
        self.date = date
        self.gameDetails = gameDetails
        self.difficulty = difficulty
        self.timeSpent = timeSpent
    }
} 