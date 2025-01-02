import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let recordsKey = "gameRecords"
    private let achievementsKey = "sudoku_achievements"
    private let leaderboardKey = "sudoku_leaderboard"
    private(set) var records: [GameRecord] = []
    
    private init() {
        _ = loadRecords()
    }
    
    // 游戏记录相关方法
    func loadRecords() -> [GameRecord] {
        if let data = UserDefaults.standard.data(forKey: recordsKey),
           let records = try? JSONDecoder().decode([GameRecord].self, from: data) {
            self.records = records
            return records
        }
        return []
    }
    
    func saveRecord(_ record: GameRecord) {
        records.append(record)
        saveRecords()
    }
    
    func clearRecords() {
        records.removeAll()
        saveRecords()
    }
    
    private func saveRecords() {
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: recordsKey)
        }
    }
    
    // 成就相关方法
    func saveAchievements(_ achievements: [Achievement]) {
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: achievementsKey)
        }
    }
    
    func loadAchievements() -> [Achievement] {
        if let data = UserDefaults.standard.data(forKey: achievementsKey),
           let achievements = try? JSONDecoder().decode([Achievement].self, from: data) {
            return achievements
        }
        return Achievement.allCases.map { $0 }
    }
    
    // 排行榜相关方法
    func saveLeaderboard(_ entries: [LeaderboardEntry]) {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: leaderboardKey)
        }
    }
    
    func loadLeaderboard() -> [LeaderboardEntry] {
        if let data = UserDefaults.standard.data(forKey: leaderboardKey),
           let entries = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
            return entries
        }
        return []
    }
    
    func getAchievementCounts() -> [Achievement: Int] {
        var counts: [Achievement: Int] = [:]
        
        for record in records {
            for achievement in record.achievements {
                counts[achievement.type, default: 0] += 1
            }
        }
        
        return counts
    }
    
    func getAchievementRecords(for type: Achievement) -> [GameAchievement] {
        let key = "achievement_records_\(type.rawValue)"
        if let data = UserDefaults.standard.data(forKey: key),
           let records = try? JSONDecoder().decode([GameAchievement].self, from: data) {
            return records
        }
        return []
    }
    
    func saveAchievementRecord(_ record: GameAchievement, for type: Achievement) {
        var records = getAchievementRecords(for: type)
        records.append(record)
        
        let key = "achievement_records_\(type.rawValue)"
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
} 