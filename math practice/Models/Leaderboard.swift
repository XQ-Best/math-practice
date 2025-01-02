import Foundation

class LeaderboardManager: ObservableObject {
    @Published var entries: [LeaderboardEntry] = []
    private let storageManager: StorageManager
    
    init(storageManager: StorageManager = .shared) {
        self.storageManager = storageManager
        loadEntries()
    }
    
    func addEntry(playerName: String, difficulty: Difficulty, duration: TimeInterval) {
        let entry = LeaderboardEntry(
            id: UUID(),
            playerName: playerName,
            difficulty: difficulty,
            duration: duration,
            date: Date()
        )
        entries.append(entry)
        entries.sort { $0.duration < $1.duration }
        saveEntries()
    }
    
    private func loadEntries() {
        entries = storageManager.loadLeaderboard()
    }
    
    private func saveEntries() {
        storageManager.saveLeaderboard(entries)
    }
} 