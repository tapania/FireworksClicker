import Combine
import Foundation

class GameManager: ObservableObject {
  @Published var sparks: Double = 0
  @Published var innovationPoints: Double = 0
  @Published var currentLevel: Int = 1

  @Published var buildings: [Building] = []
  @Published var upgrades: [Upgrade] = []

  private var timer: AnyCancellable?

  init() {
    setupBuildings()
    startTimer()
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
    let sparksGen = buildings.reduce(0) { $0 + $1.totalSparksPerSecond() }
    let innovationGen = buildings.reduce(0) { $0 + $1.totalInnovationPerSecond() }

    sparks += sparksGen
    innovationPoints += innovationGen
  }

  func click() {
    // Base click value
    sparks += 1
  }

  func buyBuilding(buildingId: UUID) {
    guard let index = buildings.firstIndex(where: { $0.id == buildingId }) else { return }
    let cost = buildings[index].currentCost()

    if sparks >= cost {
      sparks -= cost
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
}
