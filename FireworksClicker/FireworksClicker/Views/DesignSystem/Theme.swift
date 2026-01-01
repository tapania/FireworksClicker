import SwiftUI

extension Color {
  struct Theme {
    static let background = Color.black
    static let panel = Color(uiColor: .systemGray6).opacity(0.15)
    static let text = Color.white
    static let secondaryText = Color.gray

    static let sparks = Color.yellow
    static let innovation = Color.cyan

    private static let levelColors: [Int: Color] = [
      1: .white,
      2: .red,
      3: .blue,
      4: .green,
      5: .purple,
      6: .orange,
      7: .mint,
      8: .indigo,
      9: .pink,
      10: .teal,
    ]

    static func forLevel(_ level: Int) -> Color {
      levelColors[level] ?? .white
    }
  }
}
