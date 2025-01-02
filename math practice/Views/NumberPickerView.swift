import SwiftUI

struct NumberPickerView: View {
    let onNumberSelected: (Int) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text("选择数字")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(1...9, id: \.self) { number in
                    Button(action: {
                        onNumberSelected(number)
                    }) {
                        Text("\(number)")
                            .font(.system(size: 20, weight: .medium))
                            .frame(width: 40, height: 40)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 8)
            
            Button(action: onDismiss) {
                Text("取消")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .frame(width: 160)
    }
}

#Preview {
    NumberPickerView(
        onNumberSelected: { number in
            print("Selected number: \(number)")
        },
        onDismiss: {
            print("Dismissed")
        }
    )
} 
