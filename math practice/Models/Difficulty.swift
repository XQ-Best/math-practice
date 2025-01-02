import Foundation

enum Difficulty: String, CaseIterable, Codable {
    case easy = "简单"
    case medium = "普通" 
    case hard = "困难"
    
    var emptySquares: Int {
        switch self {
        case .easy: return 30
        case .medium: return 45
        case .hard: return 60
        }
    }
    
    var displayName: String {
        rawValue
    }
} 