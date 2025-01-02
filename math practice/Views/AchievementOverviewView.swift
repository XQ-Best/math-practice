import SwiftUI

struct AchievementOverviewView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var themeManager: ThemeManager
    let records: [GameRecord]
    @State private var selectedAchievement: Achievement?
    @State private var hoveredAchievement: Achievement?
    
    var achievementCounts: [Achievement: Int] {
        var counts: [Achievement: Int] = [:]
        for achievement in Achievement.allCases {
            counts[achievement] = records.filter { record in
                record.achievements.contains { $0.type == achievement }
            }.count
        }
        return counts
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 标题栏
            HStack {
                Text("成就概览")
                    .font(.system(size: 28, weight: .bold))
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
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
            
            // 成就网格
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 240, maximum: 240), spacing: 40)
                    ],
                    spacing: 30
                ) {
                    ForEach(Achievement.allCases) { achievement in
                        AchievementCard(
                            type: achievement,
                            count: achievementCounts[achievement] ?? 0,
                            isHovered: hoveredAchievement == achievement
                        )
                        .onHover { isHovered in
                            withAnimation {
                                hoveredAchievement = isHovered ? achievement : nil
                            }
                        }
                        .onTapGesture {
                            selectedAchievement = achievement
                        }
                    }
                }
                .padding(40)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
        .sheet(item: $selectedAchievement) { achievement in
            AchievementDetailView(
                achievement: achievement,
                records: records,
                onDismiss: { selectedAchievement = nil }
            )
        }
    }
}

#Preview {
    AchievementOverviewView(
        themeManager: ThemeManager(),
        records: [
            GameRecord(
                duration: 300,
                difficulty: .easy,
                isCompleted: true,
                solutionViewCount: 0,
                achievements: [GameAchievement(type: .quickSolver)]
            ),
            GameRecord(
                duration: 600,
                difficulty: .medium,
                isCompleted: true,
                solutionViewCount: 0,
                achievements: [GameAchievement(type: .perfectionist)]
            ),
            GameRecord(
                duration: 1200,
                difficulty: .hard,
                isCompleted: true,
                solutionViewCount: 1,
                achievements: [GameAchievement(type: .persistent)]
            )
        ]
    )
} 