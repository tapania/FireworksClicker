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

struct Upgrade: Identifiable, Codable {
  let id: UUID
  let name: String
  let description: String
  let cost: Double
  let unlockLevel: Int
  var isPurchased: Bool
  // In a real implementation, we'd use an enum or closure for effect,
  // but for data structure start we can use flags or effectTypes
}
