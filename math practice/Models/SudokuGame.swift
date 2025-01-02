import Foundation
import SwiftUI

class SudokuGame: ObservableObject {
    @Published var board: [[Int?]]
    @Published var solution: [[Int]]
    @Published var userInput: [[Int?]]
    @Published var isGameActive = false
    @Published var startTime: Date?
    @Published var duration: TimeInterval = 0
    @Published var difficulty: Difficulty = .easy
    @Published var solutionViewCount: Int = 0
    @Published var currentAchievements: Set<Achievement> = []
    private var timer: Timer?
    
    init() {
        self.board = Array(repeating: Array(repeating: nil, count: 9), count: 9)
        self.solution = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        self.userInput = Array(repeating: Array(repeating: nil, count: 9), count: 9)
        self.currentAchievements = []
    }
    
    func addAchievement(_ achievement: Achievement) {
        objectWillChange.send()
        currentAchievements.insert(achievement)
    }
    
    func checkAchievements(isCompleted: Bool) -> [GameAchievement] {
        if isCompleted {
            if duration <= 300 { // 5分钟内完成
                currentAchievements.insert(.quickSolver)
            }
            if solutionViewCount == 0 {
                currentAchievements.insert(.perfectionist)
            }
            if duration > 900 { // 15分钟以上
                currentAchievements.insert(.persistent)
            }
        }
        
        return currentAchievements.map { achievement in
            GameAchievement(type: achievement)
        }
    }
    
    func getErrorCells() -> [(row: Int, col: Int)] {
        var errorCells: [(row: Int, col: Int)] = []
        for row in 0..<9 {
            for col in 0..<9 {
                if let userNumber = userInput[row][col] {
                    if userNumber != solution[row][col] {
                        errorCells.append((row, col))
                    }
                }
            }
        }
        return errorCells
    }
    
    func addTimePenalty() {
        duration += 300 // 增加5分钟
        // 更新开始时间，以保持计时器的连续性
        if let start = startTime {
            startTime = start.addingTimeInterval(-300)
        }
    }
    
    func incrementSolutionViewCount() {
        solutionViewCount += 1
    }
    
    func isBoardFull() -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] == nil && userInput[row][col] == nil {
                    return false
                }
            }
        }
        return true
    }
    
    func startNewGame(difficulty: Difficulty) {
        self.difficulty = difficulty
        generateNewPuzzle()
        isGameActive = true
        startTime = Date()
        duration = 0
        solutionViewCount = 0
        currentAchievements.removeAll()
        // 清空用户输入
        userInput = Array(repeating: Array(repeating: nil, count: 9), count: 9)
        
        // 停止旧计时器
        timer?.invalidate()
        
        // 启动新计时器
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.duration = Date().timeIntervalSince(startTime)
        }
    }
    
    private func generateNewPuzzle() {
        // 生成完整的数独解决方案
        generateSolution()
        
        // 根据难度移除适当数量的数字
        let cellsToRemove = difficulty.emptySquares
        board = solution.map { $0.map { $0 } }
        
        var removedCount = 0
        while removedCount < cellsToRemove {
            let row = Int.random(in: 0..<9)
            let col = Int.random(in: 0..<9)
            
            if board[row][col] != nil {
                board[row][col] = nil
                removedCount += 1
            }
        }
    }
    
    private func generateSolution() {
        // 清空解决方案
        solution = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        
        // 填充对角线上的3个3x3方块
        for i in stride(from: 0, to: 9, by: 3) {
            fillBox(row: i, col: i)
        }
        
        // 填充剩余单元
        _ = solveSudoku()
    }
    
    private func fillBox(row: Int, col: Int) {
        var numbers = Array(1...9)
        numbers.shuffle()
        
        for i in 0..<3 {
            for j in 0..<3 {
                solution[row + i][col + j] = numbers.removeLast()
            }
        }
    }
    
    private func solveSudoku() -> Bool {
        let empty = findEmptyCell()
        if empty == nil {
            return true
        }
        
        let (row, col) = empty!
        
        for num in 1...9 {
            if isValid(num: num, row: row, col: col) {
                solution[row][col] = num
                
                if solveSudoku() {
                    return true
                }
                
                solution[row][col] = 0
            }
        }
        
        return false
    }
    
    private func findEmptyCell() -> (Int, Int)? {
        for i in 0..<9 {
            for j in 0..<9 {
                if solution[i][j] == 0 {
                    return (i, j)
                }
            }
        }
        return nil
    }
    
    private func isValid(num: Int, row: Int, col: Int) -> Bool {
        // 检查行
        for j in 0..<9 {
            if solution[row][j] == num {
                return false
            }
        }
        
        // 检查���
        for i in 0..<9 {
            if solution[i][col] == num {
                return false
            }
        }
        
        // 检查3x3方块
        let boxRow = row - row % 3
        let boxCol = col - col % 3
        
        for i in 0..<3 {
            for j in 0..<3 {
                if solution[boxRow + i][boxCol + j] == num {
                    return false
                }
            }
        }
        
        return true
    }
    
    func checkCompletion() -> Bool {
        for i in 0..<9 {
            for j in 0..<9 {
                if let original = board[i][j] {
                    if original != solution[i][j] {
                        return false
                    }
                } else if let userValue = userInput[i][j] {
                    if userValue != solution[i][j] {
                        return false
                    }
                } else {
                    return false
                }
            }
        }
        return true
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
} 