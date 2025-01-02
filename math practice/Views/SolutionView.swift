import SwiftUI

struct SolutionView: View {
    let solution: [[Int]]
    let themeManager: ThemeManager
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView()
            SolutionGridView(solution: solution)
            FooterView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
        .onTapGesture {
            withAnimation {
                onDismiss()
            }
        }
    }
}

// MARK: - 子视图
private struct HeaderView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("参考答案")
                .font(.system(size: 28, weight: .medium))
                .padding(.top, 30)
            
            Text("查看答案将增加5分钟计时")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

private struct SolutionGridView: View {
    let solution: [[Int]]
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<9) { row in
                RowView(row: row, solution: solution)
            }
        }
        .padding(4)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(8)
        .shadow(radius: 5)
    }
}

private struct RowView: View {
    let row: Int
    let solution: [[Int]]
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<9) { col in
                CellView(
                    number: solution[row][col],
                    isOriginal: true,
                    isSelected: false,
                    isError: false
                )
            }
        }
    }
}

private struct FooterView: View {
    var body: some View {
        Text("点击任意位置继续")
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.bottom, 30)
    }
}

#Preview {
    SolutionView(
        solution: Array(repeating: Array(repeating: 1, count: 9), count: 9),
        themeManager: ThemeManager(),
        onDismiss: {}
    )
} 