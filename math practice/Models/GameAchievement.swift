import Foundation

struct GameAchievement: Codable, Identifiable {
    let id: UUID
    let type: Achievement
    let date: Date
    
    init(id: UUID = UUID(), type: Achievement, date: Date = Date()) {
        self.id = id
        self.type = type
        self.date = date
    }
} 