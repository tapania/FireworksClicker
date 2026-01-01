import Foundation

enum ResourceType: String, CaseIterable, Codable {
  case sparks
  case innovationPoints
}

struct Resource: Codable {
  let type: ResourceType
  var amount: Double
}

struct Building: Identifiable, Codable {
  let id: UUID
  let name: String
  let description: String
  let baseCost: Double
  let baseSparksProduction: Double
  let baseInnovationProduction: Double
  let unlockLevel: Int
  var count: Int

  // Cost formula: Base * (1.15 ^ Count)
  func currentCost() -> Double {
    return baseCost * pow(1.15, Double(count))
  }

  // Total production
  func totalSparksPerSecond() -> Double {
    return baseSparksProduction * Double(count)
  }

  func totalInnovationPerSecond() -> Double {
    return baseInnovationProduction * Double(count)
  }
}

enum UpgradeEffectType: String, Codable {
  case costReduction        // Reduces building costs
  case productionMultiplier // Increases production
  case clickMultiplier      // Increases click value
}

struct Upgrade: Identifiable, Codable {
  let id: UUID
  let name: String
  let description: String
  let cost: Double  // Cost in Innovation Points
  let unlockLevel: Int
  var isPurchased: Bool
  let effectType: UpgradeEffectType
  let effectValue: Double  // e.g., 0.9 for 10% cost reduction, 1.5 for 50% production boost
  let targetBuildingName: String?  // nil = global, otherwise targets specific building
}
