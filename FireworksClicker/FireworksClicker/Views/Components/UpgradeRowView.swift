import SwiftUI

struct UpgradeRowView: View {
  let upgrade: Upgrade
  @EnvironmentObject var gameManager: GameManager

  private var canAfford: Bool {
    gameManager.innovationPoints >= upgrade.cost
  }

  private var effectDescription: String {
    switch upgrade.effectType {
    case .clickMultiplier:
      return "Click power x\(formatMultiplier(upgrade.effectValue))"
    case .productionMultiplier:
      return "Production x\(formatMultiplier(upgrade.effectValue))"
    case .costReduction:
      let reductionPercent = (1.0 - upgrade.effectValue) * 100
      if let targetBuilding = upgrade.targetBuildingName {
        return "\(targetBuilding) -\(Int(reductionPercent))% cost"
      } else {
        return "All buildings -\(Int(reductionPercent))% cost"
      }
    }
  }

  var body: some View {
    HStack(spacing: 12) {
      // Upgrade Icon/Status Indicator
      ZStack {
        Circle()
          .fill(
            upgrade.isPurchased
              ? Color.green.opacity(0.3)
              : Color.Theme.innovation.opacity(0.3)
          )
          .frame(width: 50, height: 50)

        if upgrade.isPurchased {
          Image(systemName: "checkmark.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .foregroundColor(.green)
        } else {
          Image(systemName: upgradeIcon(for: upgrade.effectType))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .foregroundColor(Color.Theme.innovation)
        }
      }

      // Upgrade Info
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text(upgrade.name)
            .font(.headline)
            .foregroundColor(Color.Theme.text)

          if upgrade.isPurchased {
            Text("OWNED")
              .font(.caption2)
              .bold()
              .foregroundColor(.green)
              .padding(.horizontal, 6)
              .padding(.vertical, 2)
              .background(Color.green.opacity(0.2))
              .cornerRadius(4)
          }
        }

        Text(upgrade.description)
          .font(.caption)
          .foregroundColor(Color.Theme.secondaryText)
          .lineLimit(2)

        Text(effectDescription)
          .font(.caption2)
          .foregroundColor(Color.Theme.innovation)
          .bold()
      }

      Spacer()

      // Buy Button or Status
      if upgrade.isPurchased {
        VStack(spacing: 2) {
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
            .font(.title2)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
      } else {
        Button(
          action: {
            gameManager.buyUpgrade(upgradeId: upgrade.id)
          },
          label: {
            VStack(spacing: 2) {
              Text("BUY")
                .font(.caption)
                .bold()
              HStack(spacing: 4) {
                Text(formatNumber(upgrade.cost))
                  .font(.caption2)
                Image(AssetProvider.icon(for: .innovationPoints))
                  .resizable()
                  .frame(width: 10, height: 10)
              }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
              canAfford
                ? Color.Theme.innovation.opacity(0.2)
                : Color.gray.opacity(0.1)
            )
            .foregroundColor(
              canAfford ? Color.Theme.innovation : Color.gray
            )
            .cornerRadius(8)
          }
        )
        .disabled(!canAfford)
      }
    }
    .padding(12)
    .background(Color.Theme.panel)
    .cornerRadius(12)
    .opacity(upgrade.isPurchased ? 0.7 : 1.0)
  }

  private func upgradeIcon(for effectType: UpgradeEffectType) -> String {
    switch effectType {
    case .clickMultiplier:
      return "hand.tap.fill"
    case .productionMultiplier:
      return "chart.line.uptrend.xyaxis"
    case .costReduction:
      return "arrow.down.circle.fill"
    }
  }

  private func formatMultiplier(_ value: Double) -> String {
    if value >= 1.0 {
      return String(format: "%.1f", value)
    } else {
      return String(format: "%.2f", value)
    }
  }

  private func formatNumber(_ number: Double) -> String {
    if number >= 1_000_000 {
      return String(format: "%.2fM", number / 1_000_000)
    } else if number >= 1_000 {
      return String(format: "%.1fK", number / 1_000)
    } else {
      return String(format: "%.0f", number)
    }
  }
}

struct UpgradeRowView_Previews: PreviewProvider {
  static var previews: some View {
    let gameManager = GameManager()
    VStack(spacing: 12) {
      UpgradeRowView(upgrade: gameManager.upgrades[0])
        .environmentObject(gameManager)
      UpgradeRowView(upgrade: gameManager.upgrades[1])
        .environmentObject(gameManager)
    }
    .padding()
    .background(Color.Theme.background)
  }
}
