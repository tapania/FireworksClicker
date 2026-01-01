import Combine
import Foundation

class GameManager: ObservableObject {
  @Published var sparks: Double = 0
  @Published var innovationPoints: Double = 0
  @Published var currentLevel: Int = 1

  @Published var buildings: [Building] = []
  @Published var upgrades: [Upgrade] = []

  let levels: [LevelDefinition] = LevelDefinition.allLevels

  private var timer: AnyCancellable?

  init() {
    setupBuildings()
    setupUpgrades()
    startTimer()
  }

  // MARK: - Level Progression Computed Properties

  var currentLevelDefinition: LevelDefinition {
    return levels.first { $0.id == currentLevel } ?? levels[0]
  }

  var nextLevelDefinition: LevelDefinition? {
    return levels.first { $0.id == currentLevel + 1 }
  }

  var canLevelUp: Bool {
    guard let nextLevel = nextLevelDefinition else {
      return false  // Already at max level
    }
    return innovationPoints >= nextLevel.unlockCost
  }

  var availableBuildings: [Building] {
    return buildings.filter { $0.unlockLevel <= currentLevel }
  }

  var availableUpgrades: [Upgrade] {
    return upgrades.filter { $0.unlockLevel <= currentLevel }
  }

  // MARK: - Upgrade Multiplier Computed Properties

  var globalProductionMultiplier: Double {
    return upgrades
      .filter { $0.isPurchased && $0.effectType == .productionMultiplier }
      .reduce(1.0) { $0 * $1.effectValue }
  }

  var clickMultiplier: Double {
    return upgrades
      .filter { $0.isPurchased && $0.effectType == .clickMultiplier }
      .reduce(1.0) { $0 * $1.effectValue }
  }

  func buildingCostMultiplier(for building: Building) -> Double {
    return upgrades
      .filter { upgrade in
        guard upgrade.isPurchased && upgrade.effectType == .costReduction else {
          return false
        }
        // Apply global cost reductions (nil targetBuildingName) or targeted ones
        return upgrade.targetBuildingName == nil || upgrade.targetBuildingName == building.name
      }
      .reduce(1.0) { $0 * $1.effectValue }
  }

  // MARK: - Level Progression Methods

  func levelUp() -> Bool {
    guard let nextLevel = nextLevelDefinition else {
      return false  // Already at max level
    }

    guard innovationPoints >= nextLevel.unlockCost else {
      return false  // Not enough Innovation Points
    }

    innovationPoints -= nextLevel.unlockCost
    currentLevel += 1
    return true
  }

  // MARK: - Upgrade Methods

  func buyUpgrade(upgradeId: UUID) {
    guard let index = upgrades.firstIndex(where: { $0.id == upgradeId }) else { return }

    let upgrade = upgrades[index]

    // Check if already purchased
    guard !upgrade.isPurchased else { return }

    // Check if player has enough Innovation Points
    guard innovationPoints >= upgrade.cost else { return }

    // Deduct cost and mark as purchased
    innovationPoints -= upgrade.cost
    upgrades[index].isPurchased = true
  }

  private func startTimer() {
    timer = Timer.publish(every: 1.0, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        self?.tick()
      }
  }

  func tick() {
    // Calculate production
    let baseSparksGen = buildings.reduce(0) { $0 + $1.totalSparksPerSecond() }
    let baseInnovationGen = buildings.reduce(0) { $0 + $1.totalInnovationPerSecond() }

    // Apply production multipliers
    let multiplier = globalProductionMultiplier
    sparks += baseSparksGen * multiplier
    innovationPoints += baseInnovationGen * multiplier
  }

  func click() {
    // Base click value with multipliers
    let baseClickValue = 1.0
    sparks += baseClickValue * clickMultiplier
  }

  func buyBuilding(buildingId: UUID) {
    guard let index = buildings.firstIndex(where: { $0.id == buildingId }) else { return }
    let building = buildings[index]
    let baseCost = building.currentCost()
    let costMultiplier = buildingCostMultiplier(for: building)
    let finalCost = baseCost * costMultiplier

    if sparks >= finalCost {
      sparks -= finalCost
      buildings[index].count += 1
    }
  }

  func setupBuildings() {
    // Initial setup based on Level 1-10 definitions
    // For brevity, adding the first few levels here to start
    buildings = [
      Building(
        id: UUID(), name: "Backyard Amateur", description: "Just you and a lighter.", baseCost: 10,
        baseSparksProduction: 1, baseInnovationProduction: 0.0, unlockLevel: 1, count: 0),
      Building(
        id: UUID(), name: "Firecracker Bundle", description: "Cheap and loud.", baseCost: 50,
        baseSparksProduction: 2, baseInnovationProduction: 0.1, unlockLevel: 1, count: 0),
      Building(
        id: UUID(), name: "Roman Candle Battery", description: "Permit required.", baseCost: 100,
        baseSparksProduction: 5, baseInnovationProduction: 0.5, unlockLevel: 2, count: 0),
      Building(
        id: UUID(), name: "Mortar Tube", description: "Professional setup.", baseCost: 500,
        baseSparksProduction: 25, baseInnovationProduction: 2.0, unlockLevel: 3, count: 0),
      Building(
        id: UUID(), name: "Aerial Shell Rack", description: "Standard fireworks show.",
        baseCost: 2500, baseSparksProduction: 100, baseInnovationProduction: 5.0, unlockLevel: 4,
        count: 0),
      Building(
        id: UUID(), name: "Computerized Sequencer", description: "Perfect timing.", baseCost: 10000,
        baseSparksProduction: 500, baseInnovationProduction: 15.0, unlockLevel: 5, count: 0),
      Building(
        id: UUID(), name: "Drone Swarm", description: "Sky painters.", baseCost: 50000,
        baseSparksProduction: 2500, baseInnovationProduction: 40.0, unlockLevel: 6, count: 0),
      Building(
        id: UUID(), name: "High-Altitude Balloon", description: "Stratospheric booming.",
        baseCost: 250000, baseSparksProduction: 12000, baseInnovationProduction: 100.0,
        unlockLevel: 7, count: 0),
      Building(
        id: UUID(), name: "Moon Base Launcher", description: "Low gravity, big boom.",
        baseCost: 1_000_000, baseSparksProduction: 60000, baseInnovationProduction: 250.0,
        unlockLevel: 8, count: 0),
      Building(
        id: UUID(), name: "Orbital Cannon", description: "Space lasers... essentially.",
        baseCost: 5_000_000, baseSparksProduction: 300000, baseInnovationProduction: 700.0,
        unlockLevel: 9, count: 0),
      Building(
        id: UUID(), name: "Reality Rift", description: "Breaking physics.", baseCost: 25_000_000,
        baseSparksProduction: 1_000_000, baseInnovationProduction: 2000.0, unlockLevel: 10, count: 0
      ),
    ]
  }

  func setupUpgrades() {
    upgrades = [
      // Level 1 Upgrades
      Upgrade(
        id: UUID(),
        name: "Click Power",
        description: "Doubles the value of each click",
        cost: 10,
        unlockLevel: 1,
        isPurchased: false,
        effectType: .clickMultiplier,
        effectValue: 2.0,
        targetBuildingName: nil
      ),
      Upgrade(
        id: UUID(),
        name: "Efficient Sparks",
        description: "Reduces building costs by 10%",
        cost: 50,
        unlockLevel: 1,
        isPurchased: false,
        effectType: .costReduction,
        effectValue: 0.9,
        targetBuildingName: nil
      ),

      // Level 2 Upgrades
      Upgrade(
        id: UUID(),
        name: "Spark Surge",
        description: "Increases production by 25%",
        cost: 100,
        unlockLevel: 2,
        isPurchased: false,
        effectType: .productionMultiplier,
        effectValue: 1.25,
        targetBuildingName: nil
      ),
      Upgrade(
        id: UUID(),
        name: "Firecracker Efficiency",
        description: "Reduces Firecracker Bundle cost by 10%",
        cost: 75,
        unlockLevel: 2,
        isPurchased: false,
        effectType: .costReduction,
        effectValue: 0.9,
        targetBuildingName: "Firecracker Bundle"
      ),

      // Level 3 Upgrades
      Upgrade(
        id: UUID(),
        name: "Super Click",
        description: "Triples the value of each click",
        cost: 200,
        unlockLevel: 3,
        isPurchased: false,
        effectType: .clickMultiplier,
        effectValue: 3.0,
        targetBuildingName: nil
      ),
      Upgrade(
        id: UUID(),
        name: "Production Boost",
        description: "Increases production by 50%",
        cost: 300,
        unlockLevel: 3,
        isPurchased: false,
        effectType: .productionMultiplier,
        effectValue: 1.5,
        targetBuildingName: nil
      ),

      // Level 4 Upgrades
      Upgrade(
        id: UUID(),
        name: "Advanced Efficiency",
        description: "Reduces all building costs by 15%",
        cost: 500,
        unlockLevel: 4,
        isPurchased: false,
        effectType: .costReduction,
        effectValue: 0.85,
        targetBuildingName: nil
      ),
      Upgrade(
        id: UUID(),
        name: "Mega Production",
        description: "Doubles all production",
        cost: 750,
        unlockLevel: 4,
        isPurchased: false,
        effectType: .productionMultiplier,
        effectValue: 2.0,
        targetBuildingName: nil
      ),

      // Level 5 Upgrades
      Upgrade(
        id: UUID(),
        name: "Ultimate Click",
        description: "Multiplies click value by 5",
        cost: 1000,
        unlockLevel: 5,
        isPurchased: false,
        effectType: .clickMultiplier,
        effectValue: 5.0,
        targetBuildingName: nil
      ),
    ]
  }
}
