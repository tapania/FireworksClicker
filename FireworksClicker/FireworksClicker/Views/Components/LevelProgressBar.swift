import SwiftUI

struct LevelProgressBar: View {
  @ObservedObject var gameManager: GameManager

  var body: some View {
    VStack(spacing: 12) {
      // Level Header
      HStack {
        Text("Level \(gameManager.currentLevel)")
          .font(.headline)
          .foregroundColor(Color.Theme.forLevel(gameManager.currentLevel))

        Spacer()

        if let nextLevel = gameManager.nextLevelDefinition {
          Text(nextLevel.name)
            .font(.caption)
            .foregroundColor(Color.Theme.secondaryText)
        } else {
          Text("MAX LEVEL")
            .font(.caption)
            .foregroundColor(Color.Theme.forLevel(gameManager.currentLevel))
        }
      }

      // Progress Bar
      if let nextLevel = gameManager.nextLevelDefinition {
        VStack(spacing: 8) {
          GeometryReader { geometry in
            ZStack(alignment: .leading) {
              // Background
              RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 20)

              // Progress
              RoundedRectangle(cornerRadius: 8)
                .fill(
                  LinearGradient(
                    colors: [
                      Color.Theme.innovation,
                      Color.Theme.innovation.opacity(0.7),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                  )
                )
                .frame(
                  width: min(
                    geometry.size.width * CGFloat(gameManager.innovationPoints / nextLevel.unlockCost),
                    geometry.size.width
                  ),
                  height: 20
                )
            }
          }
          .frame(height: 20)

          // Progress Text
          HStack {
            HStack(spacing: 4) {
              Text("\(formatNumber(gameManager.innovationPoints))")
                .font(.caption)
                .foregroundColor(Color.Theme.text)
              Text("/")
                .font(.caption)
                .foregroundColor(Color.Theme.secondaryText)
              Text("\(formatNumber(nextLevel.unlockCost))")
                .font(.caption)
                .foregroundColor(Color.Theme.secondaryText)
              Image(AssetProvider.icon(for: .innovationPoints))
                .resizable()
                .frame(width: 12, height: 12)
            }

            Spacer()

            // Level Up Button
            if gameManager.canLevelUp {
              Button(
                action: {
                  _ = gameManager.levelUp()
                },
                label: {
                  HStack(spacing: 4) {
                    Image(systemName: "arrow.up.circle.fill")
                    Text("Level Up")
                  }
                  .font(.caption)
                  .foregroundColor(.white)
                  .padding(.horizontal, 12)
                  .padding(.vertical, 6)
                  .background(
                    LinearGradient(
                      colors: [.green, .green.opacity(0.8)],
                      startPoint: .leading,
                      endPoint: .trailing
                    )
                  )
                  .cornerRadius(8)
                }
              )
            } else {
              Text("\(formatNumber(nextLevel.unlockCost - gameManager.innovationPoints)) needed")
                .font(.caption)
                .foregroundColor(Color.Theme.secondaryText)
            }
          }
        }
      } else {
        // Max Level Reached
        HStack {
          Spacer()
          Text("You've reached the maximum level!")
            .font(.caption)
            .foregroundColor(Color.Theme.forLevel(gameManager.currentLevel))
          Spacer()
        }
      }
    }
    .padding()
    .background(Color.Theme.panel)
    .cornerRadius(12)
  }

  func formatNumber(_ number: Double) -> String {
    if number >= 1_000_000 {
      return String(format: "%.2fM", number / 1_000_000)
    } else if number >= 1_000 {
      return String(format: "%.1fK", number / 1_000)
    } else {
      return String(format: "%.0f", number)
    }
  }
}

struct LevelProgressBar_Previews: PreviewProvider {
  static var previews: some View {
    LevelProgressBar(gameManager: GameManager())
      .padding()
      .background(Color.Theme.background)
  }
}
