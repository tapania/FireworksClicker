import SwiftUI

struct BuildingRowView: View {
  let building: Building
  @EnvironmentObject var gameManager: GameManager

  private var baseCost: Double {
    building.currentCost()
  }

  private var finalCost: Double {
    let costMultiplier = gameManager.buildingCostMultiplier(for: building)
    return baseCost * costMultiplier
  }

  private var canAfford: Bool {
    gameManager.sparks >= finalCost
  }

  var body: some View {
    HStack(spacing: 12) {
      // Building Icon
      Image(AssetProvider.icon(forBuilding: building.name))
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 50, height: 50)
        .foregroundColor(AssetProvider.color(forBuilding: building.name))

      // Building Info
      VStack(alignment: .leading, spacing: 4) {
        Text(building.name)
          .font(.headline)
          .foregroundColor(Color.Theme.text)

        Text(building.description)
          .font(.caption)
          .foregroundColor(Color.Theme.secondaryText)
          .lineLimit(2)

        HStack(spacing: 8) {
          // Count owned
          Text("Owned: \(building.count)")
            .font(.caption2)
            .foregroundColor(Color.Theme.secondaryText)

          if building.count > 0 {  // swiftlint:disable:this empty_count
            // Production rates
            HStack(spacing: 4) {
              Text("\(formatProduction(building.totalSparksPerSecond()))")
                .font(.caption2)
                .foregroundColor(Color.Theme.sparks)
              Image(AssetProvider.icon(for: .sparks))
                .resizable()
                .frame(width: 10, height: 10)
              Text("/s")
                .font(.caption2)
                .foregroundColor(Color.Theme.secondaryText)
            }

            if building.totalInnovationPerSecond() > 0 {
              HStack(spacing: 4) {
                Text("\(formatProduction(building.totalInnovationPerSecond()))")
                  .font(.caption2)
                  .foregroundColor(Color.Theme.innovation)
                Image(AssetProvider.icon(for: .innovationPoints))
                  .resizable()
                  .frame(width: 10, height: 10)
                Text("/s")
                  .font(.caption2)
                  .foregroundColor(Color.Theme.secondaryText)
              }
            }
          }
        }
      }

      Spacer()

      // Buy Button
      Button(
        action: {
          gameManager.buyBuilding(buildingId: building.id)
        },
        label: {
          VStack(spacing: 2) {
            Text("BUY")
              .font(.caption)
              .bold()
            HStack(spacing: 4) {
              Text(formatNumber(finalCost))
                .font(.caption2)
              Image(AssetProvider.icon(for: .sparks))
                .resizable()
                .frame(width: 10, height: 10)
            }
          }
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .background(
            canAfford
              ? Color.Theme.sparks.opacity(0.2)
              : Color.gray.opacity(0.1)
          )
          .foregroundColor(
            canAfford ? Color.Theme.sparks : Color.gray
          )
          .cornerRadius(8)
        }
      )
      .disabled(!canAfford)
    }
    .padding(12)
    .background(Color.Theme.panel)
    .cornerRadius(12)
  }

  private func formatNumber(_ number: Double) -> String {
    if number >= 1_000_000_000 {
      return String(format: "%.2fB", number / 1_000_000_000)
    } else if number >= 1_000_000 {
      return String(format: "%.2fM", number / 1_000_000)
    } else if number >= 1_000 {
      return String(format: "%.1fK", number / 1_000)
    } else {
      return String(format: "%.0f", number)
    }
  }

  private func formatProduction(_ number: Double) -> String {
    if number >= 1_000_000 {
      return String(format: "%.1fM", number / 1_000_000)
    } else if number >= 1_000 {
      return String(format: "%.1fK", number / 1_000)
    } else if number >= 1 {
      return String(format: "%.1f", number)
    } else {
      return String(format: "%.2f", number)
    }
  }
}

struct BuildingRowView_Previews: PreviewProvider {
  static var previews: some View {
    let gameManager = GameManager()
    BuildingRowView(building: gameManager.buildings[0])
      .environmentObject(gameManager)
      .padding()
      .background(Color.Theme.background)
  }
}
