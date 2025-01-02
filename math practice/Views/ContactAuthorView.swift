import SwiftUI
import AppKit

struct ContactAuthorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingMailError = false
    @State private var showingAboutGame = false
    private let authorEmail = "xuquan8852@hotmail.com"
    
    var body: some View {
        VStack(spacing: 30) {
            // 顶部标题栏
            HStack {
                Text("寻找作者")
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
            
            VStack(spacing: 25) {
                // 头像
                Image("AuthorAvatar")
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140, height: 170)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.blue.opacity(0.6), lineWidth: 3)
                    )
                    .shadow(color: .gray.opacity(0.3), radius: 8)
                    .padding(.top, 10)
                
                Text("Ashuan")
                    .font(.system(size: 24, weight: .medium))
            }
            
            // 邮件按钮
            Button(action: {
                sendEmail()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "envelope.fill")
                    Text(authorEmail)
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(Color.blue)
                )
                .shadow(color: .gray.opacity(0.3), radius: 4, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 1)
            
            // 关于游戏按钮
            Button(action: {
                showingAboutGame = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "info.circle.fill")
                    Text("作者想说")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(Color.green)
                )
                .shadow(color: .gray.opacity(0.3), radius: 4, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            
            Text("点击邮箱地址即可发送邮件")
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
        .sheet(isPresented: $showingAboutGame) {
            AboutGameView()
                .frame(width: 400, height: 300)
        }
        .alert(isPresented: $showingMailError) {
            Alert(
                title: Text("无法发送邮件"),
                message: Text("请确保已设置邮件账户"),
                dismissButton: .default(Text("确定"))
            )
        }
    }
    
    private func sendEmail() {
        if let url = URL(string: "mailto:\(authorEmail)") {
            NSWorkspace.shared.open(url)
        } else {
            showingMailError = true
        }
    }
}

// 新增关于游戏视图
struct AboutGameView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // 顶部标题栏
            HStack {
                Text("作者想说")
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
            
            VStack(alignment: .leading, spacing: 20) {
                Text("本游戏制作的原由是想给自己的小弟PP上一点数学强度，促进数学成绩增长。")
                    .lineSpacing(5)
                
                Text("本游戏制作全代码均由Cursor撰写和Xcode测试，主要是想告诉使用者，代码时代已经过去，未来是创意至上！")
                    .lineSpacing(5)
                Text("特别鸣谢Louis Coco参与该软件开发的beta1和beta2版本测试")
                    .lineSpacing(5)
                Text("此版本为beta4版本")
                    .lineSpacing(5)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

#Preview {
    ContactAuthorView()
} 
