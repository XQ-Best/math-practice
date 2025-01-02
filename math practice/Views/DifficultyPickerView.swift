import SwiftUI

struct DifficultyPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var game: SudokuGame
    @ObservedObject var themeManager: ThemeManager
    @State private var selectedDifficulty: Difficulty?
    @State private var isHovering: Difficulty?
    
    var body: some View {
        VStack(spacing: 25) {
            // 顶部标题栏
            HStack {
                Text("选择难度")
                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // 难度选择卡片
            VStack(spacing: 20) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    DifficultyCard(
                        difficulty: difficulty,
                        isSelected: selectedDifficulty == difficulty,
                        isHovered: isHovering == difficulty
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3)) {
                            selectedDifficulty = difficulty
                        }
                        
                        // 添加一点延迟以显示选中效果
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            game.startNewGame(difficulty: difficulty)
                            dismiss()
                        }
                    }
                    .onHover { hovering in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isHovering = hovering ? difficulty : nil
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct DifficultyCard: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let isHovered: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            // 图标
            ZStack {
                Circle()
                    .fill(difficultyColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: difficultyIcon)
                    .font(.system(size: 24))
                    .foregroundColor(difficultyColor)
            }
            
            // 文字内容
            VStack(alignment: .leading, spacing: 6) {
                Text(difficulty.rawValue)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(difficultyDescription)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // 右箭头
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
                .opacity(isHovered ? 1 : 0.5)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? difficultyColor.opacity(0.1) : Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isHovered ? difficultyColor.opacity(0.5) : Color.clear, lineWidth: 1)
                )
        )
        .shadow(
            color: isHovered ? difficultyColor.opacity(0.2) : Color.black.opacity(0.1),
            radius: isHovered ? 10 : 5,
            y: isHovered ? 4 : 2
        )
    }
    
    private var difficultyIcon: String {
        switch difficulty {
        case .easy: return "star.fill"
        case .medium: return "star.leadinghalf.filled"
        case .hard: return "star.circle.fill"
        }
    }
    
    private var difficultyColor: Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
    
    private var difficultyDescription: String {
        switch difficulty {
        case .easy: return "适合初学者，提供较多提示"
        case .medium: return "需要一定解题技巧"
        case .hard: return "富有挑战性，考验解题能力"
        }
    }
}

#Preview {
    DifficultyPickerView(
        game: SudokuGame(),
        themeManager: ThemeManager()
    )
} 