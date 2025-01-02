import SwiftUI

struct NumberPickerOverlay: View {
    let onNumberSelected: (Int) -> Void
    @Binding var showingNumberPicker: Bool
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        showingNumberPicker = false
                    }
                }
            
            NumberPickerView(
                onNumberSelected: onNumberSelected,
                onDismiss: {
                    withAnimation {
                        showingNumberPicker = false
                    }
                }
            )
            .frame(maxWidth: 280)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)
        }
    }
}

#Preview {
    NumberPickerOverlay(
        onNumberSelected: { number in
            print("Selected number: \(number)")
        },
        showingNumberPicker: .constant(true)
    )
} 