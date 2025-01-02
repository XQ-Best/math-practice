import SwiftUI

struct AchievementsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var themeManager: ThemeManager
    @State private var selectedAchievement: Achievement?
    @State private var hoveredAchievement: Achievement?
    let records: [GameRecord]
    
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
        NavigationView {
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 220, maximum: 220), spacing: 20)
                    ],
                    spacing: 20
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
                .padding(20)
            }
            .navigationTitle("成就")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
        }
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
    AchievementsView(
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