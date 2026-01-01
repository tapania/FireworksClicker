import Foundation

/// Represents the complete saveable state of the game
struct GameState: Codable {
  let sparks: Double
  let innovationPoints: Double
  let currentLevel: Int
  let buildings: [BuildingState]
  let upgrades: [Upgrade]
  let lastSaved: Date

  /// Simplified building state for persistence
  /// Only stores the ID and count, allowing building definitions to change
  struct BuildingState: Codable {
    let id: UUID
    let count: Int
  }

  init(
    sparks: Double,
    innovationPoints: Double,
    currentLevel: Int,
    buildings: [BuildingState],
    upgrades: [Upgrade],
    lastSaved: Date = Date()
  ) {
    self.sparks = sparks
    self.innovationPoints = innovationPoints
    self.currentLevel = currentLevel
    self.buildings = buildings
    self.upgrades = upgrades
    self.lastSaved = lastSaved
  }

  /// Create GameState from GameManager's current state
  static func from(
    sparks: Double,
    innovationPoints: Double,
    currentLevel: Int,
    buildings: [Building],
    upgrades: [Upgrade]
  ) -> Self {
    let buildingStates = buildings.map { BuildingState(id: $0.id, count: $0.count) }
    return Self(
      sparks: sparks,
      innovationPoints: innovationPoints,
      currentLevel: currentLevel,
      buildings: buildingStates,
      upgrades: upgrades
    )
  }
}
