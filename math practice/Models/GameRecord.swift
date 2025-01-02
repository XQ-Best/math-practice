import Foundation

struct GameRecord: Codable, Identifiable {
    let id: UUID
    let date: Date
    let duration: TimeInterval
    let difficulty: Difficulty
    let isCompleted: Bool
    let solutionViewCount: Int
    let achievements: [GameAchievement]
    
    init(id: UUID = UUID(), 
         date: Date = Date(), 
         duration: TimeInterval, 
         difficulty: Difficulty, 
         isCompleted: Bool, 
         solutionViewCount: Int,
         achievements: [GameAchievement] = []) {
        self.id = id
        self.date = date
        self.duration = duration
        self.difficulty = difficulty
        self.isCompleted = isCompleted
        self.solutionViewCount = solutionViewCount
        self.achievements = achievements
    }
    
    var formattedTime: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
} 