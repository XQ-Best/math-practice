//
//  ContentView.swift
//  math practice
//
//  Created by 徐铨 on 2024/12/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var game = SudokuGame()
    @StateObject private var themeManager = ThemeManager()
    @State private var showingDifficultyPicker = false
    @State private var showingHistory = false
    @State private var showingContactAuthor = false
    @State private var showingAchievements = false
    
    var body: some View {
        ZStack {
            Color(NSColor.windowBackgroundColor)
                .ignoresSafeArea()
            
            if !game.isGameActive {
                VStack {
                    Spacer()
                    
                    // 标题
                    VStack(spacing: 15) {
                        Text("玩转数独")
                            .font(.system(size: 46, weight: .bold))
                        
                        Text("行不行啊牢弟")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 80)
                    
                    // 按钮组
                    VStack(spacing: 20) {
                        MainButton(
                            title: "开始数独",
                            icon: "play.fill",
                            color: .blue,
                            width: 300
                        ) {
                            showingDifficultyPicker = true
                        }
                        
                        MainButton(
                            title: "成就概览",
                            icon: "trophy.fill",
                            color: .yellow,
                            width: 300
                        ) {
                            showingAchievements = true
                        }
                        
                        MainButton(
                            title: "游戏记录",
                            icon: "clock.fill",
                            color: .green,
                            width: 300
                        ) {
                            showingHistory = true
                        }
                        
                        MainButton(
                            title: "寻找作者",
                            icon: "person.fill",
                            color: .orange,
                            width: 300
                        ) {
                            showingContactAuthor = true
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: 600)
                .padding()
            } else {
                SudokuBoardView(game: game, themeManager: themeManager)
                    .frame(maxWidth: 600)
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .sheet(isPresented: $showingDifficultyPicker) {
            ZStack {
                Color.black.opacity(0.001) // 几乎透明的背景
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showingDifficultyPicker = false
                    }
                
                DifficultyPickerView(game: game, themeManager: themeManager)
                    .frame(minWidth: 400, minHeight: 300)
            }
        }
        .sheet(isPresented: $showingHistory) {
            ZStack {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showingHistory = false
                    }
                
                HistoryView(themeManager: themeManager)
                    .frame(minWidth: 500, minHeight: 400)
            }
        }
        .sheet(isPresented: $showingContactAuthor) {
            ZStack {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showingContactAuthor = false
                    }
                
                ContactAuthorView()
                    .frame(minWidth: 400, minHeight: 300)
            }
        }
        .sheet(isPresented: $showingAchievements) {
            ZStack {
                Color(NSColor.windowBackgroundColor)
                    .ignoresSafeArea()
                
                AchievementOverviewView(
                    themeManager: themeManager,
                    records: StorageManager.shared.records
                )
            }
            .frame(minWidth: 800, minHeight: 600)
        }
    }
}

struct MainButton: View {
    let title: String
    let icon: String
    let color: Color
    let width: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.title2)
            }
            .frame(width: width)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(color)
                    .shadow(radius: 5)
            )
            .foregroundColor(.white)
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(Rectangle())
    }
}

#Preview {
    ContentView()
}
