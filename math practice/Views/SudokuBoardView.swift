import SwiftUI
import AppKit

struct CurrentAchievementsView: View {
    let achievements: Set<Achievement>
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题部分
            HStack {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("当前成就")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(themeManager.textColor)
            }
            
            if achievements.isEmpty {
                // 空状态
                VStack(spacing: 8) {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue.opacity(0.7), .purple.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Text("继续努力")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                // 成就列表
                VStack(spacing: 10) {
                    ForEach(Array(achievements).sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { achievement in
                        HStack(spacing: 12) {
                            // 成就图标
                            Image(systemName: getAchievementIcon(for: achievement))
                                .font(.system(size: 16))
                                .foregroundStyle(
                                    getAchievementGradient(for: achievement)
                                )
                                .frame(width: 24)
                            
                            // 成就文本
                            Text(achievement.rawValue)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(themeManager.textColor)
                                .lineLimit(1)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(getAchievementBackground(for: achievement))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(getAchievementColor(for: achievement).opacity(0.2), lineWidth: 1)
                        )
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.1),
                    radius: 15,
                    x: 0,
                    y: 5
                )
        )
        .frame(width: 220)
    }
    
    private func getAchievementIcon(for achievement: Achievement) -> String {
        switch achievement {
        case .quickSolver:
            return "bolt.circle.fill"
        case .perfectionist:
            return "star.circle.fill"
        case .persistent:
            return "flag.circle.fill"
        case .needHint:
            return "questionmark.circle.fill"
        case .vegetableDog:
            return "eye.circle.fill"
        case .bigVegetableDog:
            return "eyes.inverse"
        }
    }
    
    private func getAchievementColor(for achievement: Achievement) -> Color {
        switch achievement {
        case .quickSolver:
            return .yellow
        case .perfectionist:
            return .purple
        case .persistent:
            return .green
        case .needHint:
            return .blue
        case .vegetableDog, .bigVegetableDog:
            return .orange
        }
    }
    
    private func getAchievementGradient(for achievement: Achievement) -> LinearGradient {
        let color = getAchievementColor(for: achievement)
        return LinearGradient(
            colors: [color, color.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func getAchievementBackground(for achievement: Achievement) -> Color {
        getAchievementColor(for: achievement).opacity(0.1)
    }
}

struct SudokuBoardView: View {
    @ObservedObject var game: SudokuGame
    @ObservedObject var themeManager: ThemeManager
    @State private var selectedCell: (row: Int, col: Int)?
    @State private var showingGiveUpAlert = false
    @State private var showingSolution = false
    @State private var showingPenaltyAlert = false
    @State private var showingErrorAlert = false
    @State private var showingErrors = false
    @State private var keyboardMonitor: Any?
    @State private var hasShownErrorThisGame = false
    @State private var hasChosenShowErrors = false
    
    var body: some View {
        ZStack {
            // 背景
            themeManager.backgroundColor
                .ignoresSafeArea()
            
            // 主要内容
            HStack(spacing: 60) {
                // 左侧内容
                VStack(spacing: 40) {
                    // 数独棋盘
                    BoardGridView(
                        game: game,
                        selectedCell: $selectedCell,
                        onCellTap: handleCellTap,
                        showingErrors: showingErrors
                    )
                    .focusable()
                    .onAppear {
                        setupKeyboardMonitor()
                    }
                    .onDisappear {
                        if let monitor = keyboardMonitor {
                            NSEvent.removeMonitor(monitor)
                        }
                    }
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 2)
                    
                    // 底部按钮组
                    HStack(spacing: 20) {
                        // 查看答案按钮
                        GameButton(
                            icon: "eye.fill",
                            text: "查看答案",
                            color: .blue,
                            action: { showingPenaltyAlert = true }
                        )
                        
                        // 放弃按钮
                        GameButton(
                            icon: "flag.fill",
                            text: "我不想玩了",
                            color: .red,
                            action: { showingGiveUpAlert = true }
                        )
                        .frame(width: 150)
                    }
                }
                
                // 右侧内容
                VStack(spacing: 30) {
                    // 计时器
                    TimerView(
                        duration: game.duration,
                        solutionViewCount: game.solutionViewCount,
                        themeManager: themeManager
                    )
                    .frame(width: 160)
                    
                    // 替换数字选择器为成就显示
                    CurrentAchievementsView(
                        achievements: game.currentAchievements,
                        themeManager: themeManager
                    )
                    
                    Spacer()
                }
            }
            .padding(40)
        }
        .alert("查看答案惩罚", isPresented: $showingPenaltyAlert) {
            Button("确定", role: .destructive) {
                game.addTimePenalty()
                game.incrementSolutionViewCount()
                if game.solutionViewCount == 1 {
                    game.addAchievement(.vegetableDog)
                } else if game.solutionViewCount > 1 {
                    game.addAchievement(.bigVegetableDog)
                }
                showingSolution = true
            }
            Button("取消", role: .cancel) {}
        } message: {
            Text("查看答案将增加5分钟计时\n确定要继续吗？")
        }
        .alert("确定要放弃吗？", isPresented: $showingGiveUpAlert) {
            Button("确定", role: .destructive) {
                endGame(completed: false)
            }
            Button("继续游戏", role: .cancel) {}
        } message: {
            Text("放弃后将返回主界面")
        }
        .alert("发现错误", isPresented: $showingErrorAlert) {
            Button("显示错误", role: .destructive) {
                showingErrors = true
                hasChosenShowErrors = true
                game.addAchievement(.needHint)
            }
            Button("继续尝试", role: .cancel) {
                hasChosenShowErrors = false
                hasShownErrorThisGame = true
            }
        } message: {
            Text("有些数字填错了，需要我帮你标出来吗？")
        }
        .sheet(isPresented: $showingSolution) {
            SolutionView(
                solution: game.solution,
                themeManager: themeManager
            ) {
                showingSolution = false
            }
            .frame(minWidth: 500, minHeight: 500)
        }
    }
    
    private func handleCellTap(row: Int, col: Int) {
        if game.board[row][col] == nil {
            withAnimation(.spring()) {
                selectedCell = (row, col)
                if showingErrors {
                    showingErrors = false
                }
            }
        }
    }
    
    private func handleNumberSelection(_ number: Int) {
        if let (row, col) = selectedCell {
            withAnimation(.spring()) {
                game.userInput[row][col] = number
                showingErrors = false
                
                if game.isBoardFull() {
                    if game.checkCompletion() {
                        checkCompletion()
                    } else if !hasShownErrorThisGame || (hasShownErrorThisGame && !hasChosenShowErrors) {
                        showingErrorAlert = true
                        hasShownErrorThisGame = true
                    }
                }
            }
        }
    }
    
    private func checkCompletion() {
        if game.checkCompletion() {
            DispatchQueue.main.async {
                let alert = NSAlert()
                alert.messageText = "算你有两把刷子"
                alert.informativeText = "用时: \(formatTime(game.duration))"
                alert.addButton(withTitle: "确定")
                
                if let window = NSApplication.shared.windows.first {
                    let windowFrame = window.frame
                    let alertFrame = alert.window.frame
                    let x = windowFrame.origin.x + (windowFrame.width - alertFrame.width) / 2
                    let y = windowFrame.origin.y + (windowFrame.height - alertFrame.height) / 2
                    
                    alert.window.setFrameOrigin(NSPoint(x: x, y: y))
                    alert.beginSheetModal(for: window) { _ in
                        self.endGame(completed: true)
                    }
                }
            }
        }
    }
    
    private func endGame(completed: Bool) {
        game.isGameActive = false
        let achievements = game.checkAchievements(isCompleted: completed)
        StorageManager.shared.saveRecord(GameRecord(
            duration: game.duration,
            difficulty: game.difficulty,
            isCompleted: completed,
            solutionViewCount: game.solutionViewCount,
            achievements: achievements
        ))
    }
    
    private func setupKeyboardMonitor() {
        keyboardMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if let selectedCell = selectedCell {
                if event.keyCode == 51 {
                    if game.board[selectedCell.row][selectedCell.col] == nil {
                        game.userInput[selectedCell.row][selectedCell.col] = nil
                        showingErrors = false
                    }
                    return nil
                }
                
                if let key = event.characters,
                   let number = Int(key),
                   number >= 1 && number <= 9,
                   game.board[selectedCell.row][selectedCell.col] == nil {
                    handleNumberSelection(number)
                    return nil
                }
                
                var newRow = selectedCell.row
                var newCol = selectedCell.col
                
                switch event.keyCode {
                case 126: // 上
                    newRow = max(0, selectedCell.row - 1)
                case 125: // 下
                    newRow = min(8, selectedCell.row + 1)
                case 123: // 左
                    newCol = max(0, selectedCell.col - 1)
                case 124: // 右
                    newCol = min(8, selectedCell.col + 1)
                default:
                    return event
                }
                
                withAnimation {
                    self.selectedCell = (newRow, newCol)
                    if showingErrors {
                        showingErrors = false
                    }
                }
                return nil
            }
            
            return event
        }
    }
}

// MARK: - 辅助视图
struct GameButton: View {
    let icon: String
    let text: String
    let color: Color
    let action: () -> Void
    @State private var isHovering = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(text)
                    .font(.system(size: 14))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .frame(minWidth: text == "我不想玩了" ? 140 : 120)
            .background(
                color.opacity(isHovering ? 0.9 : 0.8)
            )
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
        .shadow(color: color.opacity(0.3), radius: 5, x: 0, y: 2)
        .scaleEffect(isHovering ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isHovering)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

struct TimerView: View {
    let duration: TimeInterval
    let solutionViewCount: Int
    let themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            // 时间显示
            VStack(spacing: 8) {
                Text("用时")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.blue)
                    Text(formatTime(duration))
                        .font(.system(size: 24, design: .monospaced))
                        .foregroundColor(.blue)
                        .fixedSize()
                }
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
            )
            
            // 查看答案次数
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "eye.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.orange)
                    Text("查看答案：\(solutionViewCount)次")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.1))
                )
                
                if solutionViewCount > 0 {
                    Text(solutionViewCount == 1 ? "菜就多练" : "菜到抠脚，答案还要看这么多遍")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 2)
        )
    }
}

// MARK: - 辅助函数
func formatTime(_ timeInterval: TimeInterval) -> String {
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    return String(format: "%02d:%02d", minutes, seconds)
}

struct CompletionAlertView: View {
    let duration: TimeInterval
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("有两把刷子，但还得练")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("用时: \(formatTime(duration))")
                .font(.headline)
                .foregroundColor(.blue)
            
            Button("确定") {
                onDismiss()
            }
            .keyboardShortcut(.defaultAction)
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.windowBackgroundColor))
                .shadow(radius: 10)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
    }
} 
