import SwiftUI

struct BoardGridView: View {
    let game: SudokuGame
    @Binding var selectedCell: (row: Int, col: Int)?
    let onCellTap: (Int, Int) -> Void
    let showingErrors: Bool
    
    private var errorCells: Set<String> {
        if showingErrors {
            return Set(game.getErrorCells().map { "\($0.row),\($0.col)" })
        }
        return []
    }
    
    init(game: SudokuGame, selectedCell: Binding<(row: Int, col: Int)?>, onCellTap: @escaping (Int, Int) -> Void, showingErrors: Bool = false) {
        self.game = game
        self._selectedCell = selectedCell
        self.onCellTap = onCellTap
        self.showingErrors = showingErrors
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<9) { row in
                HStack(spacing: 0) {
                    ForEach(0..<9) { col in
                        CellView(
                            number: game.board[row][col] ?? game.userInput[row][col],
                            isOriginal: game.board[row][col] != nil,
                            isSelected: selectedCell?.row == row && selectedCell?.col == col,
                            isError: errorCells.contains("\(row),\(col)")
                        )
                        .onTapGesture {
                            onCellTap(row, col)
                        }
                        .border(Color.black.opacity(0.2), width: 0.5)
                    }
                }
            }
        }
        .background(
            GeometryReader { geometry in
                Path { path in
                    // 垂直粗线
                    for i in 1...2 {
                        let x = geometry.size.width / 3 * CGFloat(i)
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                    }
                    
                    // 水平粗线
                    for i in 1...2 {
                        let y = geometry.size.height / 3 * CGFloat(i)
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                }
                .stroke(Color.black, lineWidth: 2)
            }
        )
        .border(Color.black, width: 2)
        .background(Color.white)
        .frame(width: 450, height: 450)
    }
} 