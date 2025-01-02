import SwiftUI

class ThemeManager: ObservableObject {
    var backgroundColor: Color {
        Color(NSColor.windowBackgroundColor)
    }
    
    var textColor: Color {
        .black
    }
    
    var accentColor: Color {
        .blue
    }
    
    var secondaryBackgroundColor: Color {
        .white
    }
} 