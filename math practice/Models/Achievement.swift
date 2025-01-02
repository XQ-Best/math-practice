import Foundation

enum Achievement: String, Codable, CaseIterable, Identifiable {
    case quickSolver = "神速破解 🚀"
    case perfectionist = "完美主义者📀"
    case persistent = "永不言弃 💪"
    case needHint = "指点迷津 🚔"
    case vegetableDog = "小🥬🐶"
    case bigVegetableDog = "大🥬🐶"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .quickSolver:
            return "在5分钟内成功解开数独"
        case .perfectionist:
            return "完美通关，未查看答案"
        case .persistent:
            return "玩了15分钟，终于完成"
        case .needHint:
            return "玩游戏被提示了"
        case .vegetableDog:
            return "查看答案1次"
        case .bigVegetableDog:
            return "查看答案2次及以上"
        }
    }
} 
