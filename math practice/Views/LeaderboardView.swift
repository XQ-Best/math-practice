import SwiftUI

struct LeaderboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var leaderboardManager: LeaderboardManager
    @ObservedObject var themeManager: ThemeManager
    @State private var selectedDifficulty: Difficulty = .easy
    
    var filteredEntries: [LeaderboardEntry] {
        leaderboardManager.entries
            .filter { $0.difficulty == selectedDifficulty }
            .prefix(10)
            .sorted { $0.duration < $1.duration }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("难度", selection: $selectedDifficulty) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.rawValue).tag(difficulty)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    ForEach(Array(filteredEntries.enumerated()), id: \.element.id) { index, entry in
                        HStack {
                            Text("\(index + 1)")
                                .font(.headline)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading) {
                                Text(entry.playerName)
                                    .font(.headline)
                                Text(entry.formattedDuration)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("排行榜")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("关闭") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
} 