import SwiftUI

struct CellView: View {
    let number: Int?
    let isOriginal: Bool
    let isSelected: Bool
    let isError: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
            
            if let number = number {
                Text("\(number)")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(textColor)
            }
        }
        .frame(width: 50, height: 50)
    }
    
    private var backgroundColor: Color {
        if isError {
            return Color.red.opacity(0.1)
        } else if isSelected {
            return Color.blue.opacity(0.1)
        } else {
            return Color.white
        }
    }
    
    private var textColor: Color {
        if isError {
            return .red
        } else if isOriginal {
            return .black
        } else {
            return .blue
        }
    }
} 