import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var themeManager: ThemeManager
    @State private var records: [GameRecord] = []
    @State private var selectedFilter: RecordFilter = .all
    @State private var showingDeleteConfirmation = false
    @State private var username = ""
    @State private var password = ""
    @State private var showingError = false
    
    enum RecordFilter {
        case all, completed, incomplete
    }
    
    var filteredRecords: [GameRecord] {
        switch selectedFilter {
        case .all: return records
        case .completed: return records.filter { $0.isCompleted }
        case .incomplete: return records.filter { !$0.isCompleted }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部标题栏
            HStack {
                Text("历史记录")
                    .font(.system(size: 24, weight: .bold))
                
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
            .padding(.horizontal)
            .padding(.top, 20)
            
            // 筛选器和删除按钮
            HStack {
                Picker("筛选", selection: $selectedFilter) {
                    Text("全部").tag(RecordFilter.all)
                    Text("已完成").tag(RecordFilter.completed)
                    Text("未完成").tag(RecordFilter.incomplete)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Spacer()
                
                Button(action: {
                    showingDeleteConfirmation = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(filteredRecords) { record in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: record.isCompleted ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(record.isCompleted ? .green : .red)
                                Text(record.difficulty.rawValue)
                                    .font(.headline)
                                Spacer()
                                Text(formatTime(record.duration))
                                    .font(.system(.headline, design: .monospaced))
                            }
                            
                            HStack {
                                Text(formatDate(record.date))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("查看答案：\(record.solutionViewCount)次")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                            
                            Text(formatFullDate(record.date))
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            if !record.achievements.isEmpty {
                                HStack {
                                    Text("获得成就：")
                                        .font(.caption)
                                    ForEach(record.achievements) { achievement in
                                        Text(achievement.type.rawValue)
                                            .font(.caption)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.yellow.opacity(0.2))
                                            .cornerRadius(4)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
        .sheet(isPresented: $showingDeleteConfirmation) {
            DeleteConfirmationView(
                username: $username,
                password: $password,
                showingError: $showingError,
                onConfirm: {
                    if username == "Ashuan" && password == "xuquan" {
                        StorageManager.shared.clearRecords()
                        loadRecords()
                        showingDeleteConfirmation = false
                        username = ""
                        password = ""
                    } else {
                        showingError = true
                    }
                },
                onCancel: {
                    showingDeleteConfirmation = false
                    username = ""
                    password = ""
                }
            )
            .frame(width: 300, height: 250)
        }
        .onAppear {
            loadRecords()
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter.string(from: date)
    }
    
    private func loadRecords() {
        records = StorageManager.shared.loadRecords()
    }
}

// 删除确认视图
struct DeleteConfirmationView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var showingError: Bool
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("验证身份")
                .font(.title2)
                .padding(.top)
            
            VStack(spacing: 15) {
                // 固定显示账号，禁用输入
                HStack {
                    Text("账号：")
                        .foregroundColor(.gray)
                    Text("Ashuan")
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.1))
                )
                .padding(.horizontal)
                
                // 密码输入框
                SecureField("密码", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            
            if showingError {
                Text("密码错误")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            HStack(spacing: 20) {
                Button("取消") {
                    onCancel()
                }
                
                Button("确认删除") {
                    // 直接使用固定的用户名进行验证
                    username = "Ashuan"
                    onConfirm()
                }
                .foregroundColor(.red)
            }
            .padding(.top)
            
            Spacer()
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
    }
} 