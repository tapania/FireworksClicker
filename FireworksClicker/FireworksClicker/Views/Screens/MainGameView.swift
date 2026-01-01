import SwiftUI

struct MainGameView: View {
  @StateObject private var gameManager = GameManager()
  @StateObject private var particleSystem = ParticleSystem()

  var body: some View {
    ZStack {
      // Background Layer (Optional dark theme)
      Color.Theme.background
        .ignoresSafeArea()

      // Visual Effects Layer
      FireworksEffectView(system: particleSystem)
        .zIndex(1)

      // UI Layer
      VStack(spacing: 20) {
        Text("Fireworks Clicker")
          .font(.largeTitle)
          .bold()
          .foregroundColor(Color.Theme.text)

        HStack {
          ResourceView(
            type: .sparks,
            amount: gameManager.sparks,
            icon: AssetProvider.icon(for: .sparks),
            color: AssetProvider.color(for: .sparks)
          )

          Spacer()

          ResourceView(
            type: .innovationPoints,
            amount: gameManager.innovationPoints,
            icon: AssetProvider.icon(for: .innovationPoints),
            color: AssetProvider.color(for: .innovationPoints)
          )
        }
        .padding()
        .background(Color.Theme.panel)
        .cornerRadius(12)
        .padding(.horizontal)

        // Big Click Button
        GeometryReader { geo in
          VStack {
            Spacer()
            HStack {
              Spacer()
              Button(
                action: {
                  gameManager.click()
                  // Trigger visual effect
                  let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                  particleSystem.explode(at: center, color: Color.Theme.sparks)
                },
                label: {
                  Circle()
                    .fill(
                      LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                      )
                    )
                    .frame(width: 150, height: 150)
                    .overlay(
                      VStack {
                        Image("icon_rocket")
                          .resizable()
                          .aspectRatio(contentMode: .fit)
                          .frame(width: 60, height: 60)
                        Text("LAUNCH")
                          .font(.headline)
                          .foregroundColor(.white)
                          .bold()
                      }
                    )
                    .shadow(color: .orange.opacity(0.5), radius: 10, x: 0, y: 5)
                }
              )
              Spacer()
            }
            Spacer()
          }
        }
        .frame(height: 200)

        // Buildings List
        List {
          Section(header: Text("Buildings").foregroundColor(Color.Theme.secondaryText)) {
            ForEach(gameManager.buildings) { building in
              BuildingRow(building: building, gameManager: gameManager)
            }
          }
        }
        .listStyle(.plain)
        .background(Color.clear)
      }
      .zIndex(2)
    }
  }
}

// Helper Views
struct ResourceView: View {
  let type: ResourceType
  let amount: Double
  let icon: String
  let color: Color

  var body: some View {
    VStack {
      HStack {
        Image(icon)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 20, height: 20)
          // Tint might not work on colored assets, but okay for white icons
          .foregroundColor(color)
        Text(type == .sparks ? "Sparks" : "Innovation")
          .font(.caption)
          .foregroundColor(Color.Theme.secondaryText)
      }
      Text(formatNumber(amount))
        .font(.title2)
        .bold()
        .foregroundColor(Color.Theme.text)
    }
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

struct BuildingRow: View {
  let building: Building
  @ObservedObject var gameManager: GameManager

  var body: some View {
    HStack {
      Image(AssetProvider.icon(forBuilding: building.name))
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 40, height: 40)

      VStack(alignment: .leading) {
        Text(building.name)
          .font(.headline)
          .foregroundColor(Color.Theme.text)
        Text("Owned: \(building.count)")
          .font(.caption)
          .foregroundColor(Color.Theme.secondaryText)
      }

      Spacer()

      Button(
        action: {
          gameManager.buyBuilding(buildingId: building.id)
        },
        label: {
          HStack(spacing: 4) {
            Text("\(Int(building.currentCost()))")
            Image(AssetProvider.icon(for: .sparks))
              .resizable()
              .frame(width: 12, height: 12)
          }
          .font(.caption)
          .padding(8)
          .background(
            gameManager.sparks >= building.currentCost()
              ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1)
          )
          .foregroundColor(
            gameManager.sparks >= building.currentCost() ? .blue : .gray
          )
          .cornerRadius(6)
        }
      )
      .disabled(gameManager.sparks < building.currentCost())
    }
    .listRowBackground(Color.Theme.panel)
  }
}

struct MainGameView_Previews: PreviewProvider {
  static var previews: some View {
    MainGameView()
  }
}
