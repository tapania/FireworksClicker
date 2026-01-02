import SwiftUI

struct LevelUpView: View {
  let level: LevelDefinition
  let buildings: [Building]
  let upgrades: [Upgrade]
  @Binding var isPresented: Bool

  var body: some View {
    ZStack {
      // Semi-transparent background
      Color.black.opacity(0.6)
        .ignoresSafeArea()

      VStack(spacing: 20) {
        // Celebration Header
        VStack(spacing: 10) {
          Text("Level \(level.id) Unlocked!")
            .font(.system(size: 36, weight: .bold))
            .foregroundColor(Color.Theme.forLevel(level.id))

          Text(level.name)
            .font(.title2)
            .foregroundColor(Color.Theme.text)

          Text(level.description)
            .font(.body)
            .foregroundColor(Color.Theme.secondaryText)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
        .padding(.top, 30)

        Divider()
          .background(Color.Theme.secondaryText)
          .padding(.horizontal)

        // New Content Section
        VStack(alignment: .leading, spacing: 15) {
          Text("New Unlocks")
            .font(.headline)
            .foregroundColor(Color.Theme.text)

          // Show newly unlocked buildings
          let newBuildings = buildings.filter { $0.unlockLevel == level.id }
          if !newBuildings.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
              Text("Buildings:")
                .font(.subheadline)
                .foregroundColor(Color.Theme.secondaryText)

              ForEach(newBuildings) { building in
                HStack {
                  Image(AssetProvider.icon(forBuilding: building.name))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)

                  VStack(alignment: .leading, spacing: 2) {
                    Text(building.name)
                      .font(.subheadline)
                      .foregroundColor(Color.Theme.text)
                    Text(building.description)
                      .font(.caption)
                      .foregroundColor(Color.Theme.secondaryText)
                  }
                }
              }
            }
          }

          // Show newly unlocked upgrades
          let newUpgrades = upgrades.filter { $0.unlockLevel == level.id }
          if !newUpgrades.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
              Text("Upgrades:")
                .font(.subheadline)
                .foregroundColor(Color.Theme.secondaryText)

              ForEach(newUpgrades) { upgrade in
                HStack {
                  Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .frame(width: 30, height: 30)

                  VStack(alignment: .leading, spacing: 2) {
                    Text(upgrade.name)
                      .font(.subheadline)
                      .foregroundColor(Color.Theme.text)
                    Text(upgrade.description)
                      .font(.caption)
                      .foregroundColor(Color.Theme.secondaryText)
                  }
                }
              }
            }
          }

          if newBuildings.isEmpty && newUpgrades.isEmpty {
            Text("Continue your journey!")
              .font(.subheadline)
              .foregroundColor(Color.Theme.secondaryText)
          }
        }
        .padding()
        .background(Color.Theme.panel)
        .cornerRadius(12)
        .padding(.horizontal)

        Spacer()

        // Dismiss Button
        Button(
          action: {
            isPresented = false
          },
          label: {
            Text("Continue")
              .font(.headline)
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding()
              .background(
                LinearGradient(
                  colors: [Color.Theme.forLevel(level.id), Color.Theme.forLevel(level.id).opacity(0.7)],
                  startPoint: .leading,
                  endPoint: .trailing
                )
              )
              .cornerRadius(12)
          }
        )
        .padding(.horizontal)
        .padding(.bottom, 30)
      }
      .frame(maxWidth: 400)
      .background(Color.Theme.background)
      .cornerRadius(20)
      .shadow(color: Color.Theme.forLevel(level.id).opacity(0.5), radius: 20, x: 0, y: 10)
      .padding(40)
    }
  }
}

struct LevelUpView_Previews: PreviewProvider {
  static var previews: some View {
    LevelUpView(
      level: LevelDefinition.allLevels[1],
      buildings: [],
      upgrades: [],
      isPresented: .constant(true)
    )
  }
}
