import SwiftUI

struct AchievementCard: View {
    let type: Achievement
    let count: Int
    let isHovered: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // 成就图标和标题
            VStack(spacing: 10) {
                Text(type.rawValue)
                    .font(.system(size: 30))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.white)
                
                Text("获得次数：\(count)")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // 悬停时显示获取条件
            if isHovered {
                Text(type.description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.15))
                    )
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .frame(width: 240)
        .frame(height: isHovered ? 160 : 130)
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.8)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(
            color: Color.black.opacity(isHovered ? 0.3 : 0.2),
            radius: isHovered ? 15 : 10,
            x: 0,
            y: isHovered ? 6 : 4
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
    }
} 