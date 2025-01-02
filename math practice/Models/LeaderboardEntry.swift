import Foundation

struct LeaderboardEntry: Codable, Identifiable {
    let id: UUID
    let playerName: String
    let difficulty: Difficulty
    let duration: TimeInterval
    let date: Date
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
} 