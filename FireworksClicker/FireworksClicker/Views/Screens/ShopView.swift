import SwiftUI

enum ShopTab: String, CaseIterable {
  case buildings = "Buildings"
  case research = "Research"
}

struct ShopView: View {
  @EnvironmentObject var gameManager: GameManager
  @State private var selectedTab: ShopTab = .buildings

  var body: some View {
    VStack(spacing: 0) {
      // Segmented Control Header
      Picker("Shop Tab", selection: $selectedTab) {
        ForEach(ShopTab.allCases, id: \.self) { tab in
          Text(tab.rawValue).tag(tab)
        }
      }
      .pickerStyle(.segmented)
      .padding()
      .background(Color.Theme.panel.opacity(0.5))

      // Tab Content
      ScrollView {
        VStack(spacing: 12) {
          switch selectedTab {
          case .buildings:
            buildingsTab
          case .research:
            researchTab
          }
        }
        .padding()
      }
    }
    .background(Color.Theme.background.opacity(0.95))
  }

  // MARK: - Buildings Tab

  private var buildingsTab: some View {
    VStack(spacing: 12) {
      if gameManager.availableBuildings.isEmpty {
        emptyStateView(
          icon: "building.2.fill",
          message: "No buildings available yet.\nLevel up to unlock more!"
        )
      } else {
        ForEach(gameManager.availableBuildings) { building in
          BuildingRowView(building: building)
            .environmentObject(gameManager)
        }
      }
    }
  }

  // MARK: - Research Tab

  private var researchTab: some View {
    VStack(spacing: 12) {
      if gameManager.availableUpgrades.isEmpty {
        emptyStateView(
          icon: "lightbulb.fill",
          message: "No upgrades available yet.\nLevel up to unlock research!"
        )
      } else {
        // Show purchased upgrades at the bottom
        let unpurchased = gameManager.availableUpgrades.filter { !$0.isPurchased }
        let purchased = gameManager.availableUpgrades.filter { $0.isPurchased }

        ForEach(unpurchased) { upgrade in
          UpgradeRowView(upgrade: upgrade)
            .environmentObject(gameManager)
        }

        if !purchased.isEmpty {
          Divider()
            .background(Color.Theme.secondaryText)
            .padding(.vertical, 8)

          Text("Owned Upgrades")
            .font(.caption)
            .foregroundColor(Color.Theme.secondaryText)
            .frame(maxWidth: .infinity, alignment: .leading)

          ForEach(purchased) { upgrade in
            UpgradeRowView(upgrade: upgrade)
              .environmentObject(gameManager)
          }
        }
      }
    }
  }

  // MARK: - Empty State

  private func emptyStateView(icon: String, message: String) -> some View {
    VStack(spacing: 16) {
      Image(systemName: icon)
        .font(.system(size: 60))
        .foregroundColor(Color.Theme.secondaryText.opacity(0.5))

      Text(message)
        .font(.body)
        .foregroundColor(Color.Theme.secondaryText)
        .multilineTextAlignment(.center)
    }
    .padding(40)
    .frame(maxWidth: .infinity)
  }
}

struct ShopView_Previews: PreviewProvider {
  static var previews: some View {
    ShopView()
      .environmentObject(GameManager())
  }
}
