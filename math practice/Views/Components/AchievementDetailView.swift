import SwiftUI

struct AchievementDetailView: View {
    let achievement: Achievement
    let records: [GameRecord]
    let onDismiss: () -> Void
    
    var achievementRecords: [GameRecord] {
        records.filter { record in
            record.achievements.contains { $0.type == achievement }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题栏
            HStack {
                Text("\(achievement.rawValue) 详情")
                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // 成就描述
            Text(achievement.description)
                .font(.system(size: 16))
                .foregroundColor(.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            
            // 获得记录列表
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(achievementRecords.indices, id: \.self) { index in
                        let record = achievementRecords[index]
                        RecordRow(record: record, index: index + 1)
                    }
                }
                .padding(.vertical, 6)
            }
            .frame(maxHeight: 300)
        }
        .padding(20)
        .frame(width: 600)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct RecordRow: View {
    let record: GameRecord
    let index: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // 序号
            Text("#\(index)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .frame(width: 30, alignment: .center)
            
            // 完成情况
            HStack(spacing: 4) {
                Image(systemName: record.isCompleted ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(record.isCompleted ? .green : .red)
                Text(record.isCompleted ? "完成" : "未完成")
                    .font(.system(size: 14))
                    .foregroundColor(record.isCompleted ? .green : .red)
            }
            .frame(width: 70)
            
            // 用时
            Label(
                formatTime(record.duration),
                systemImage: "clock.fill"
            )
            .font(.system(size: 14))
            .foregroundColor(.gray)
            .frame(width: 90)
            
            // 难度
            Label(
                record.difficulty.rawValue,
                systemImage: "speedometer"
            )
            .font(.system(size: 14))
            .foregroundColor(.gray)
            .frame(width: 70)
            
            // 查看答案次数
            if record.solutionViewCount > 0 {
                Label(
                    "\(record.solutionViewCount)次",
                    systemImage: "eye.fill"
                )
                .font(.system(size: 14))
                .foregroundColor(.orange)
                .frame(width: 70)
            } else {
                Color.clear.frame(width: 70)
            }
            
            Spacer()
            
            // 获得时间
            Text(formatDate(record.date))
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .frame(width: 120, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter.string(from: date)
} 