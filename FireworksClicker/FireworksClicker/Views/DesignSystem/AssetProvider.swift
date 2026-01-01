import SwiftUI

struct AssetProvider {
  // MARK: - Currency Icons
  static func icon(for currency: ResourceType) -> String {
    switch currency {
    case .sparks: return "sparks"
    case .innovationPoints: return "innovation"
    }
  }

  static func color(for currency: ResourceType) -> Color {
    switch currency {
    case .sparks: return .yellow
    case .innovationPoints: return .cyan
    }
  }

  // MARK: - Building Icons
  private static let buildingIcons: [String: String] = [
    "Backyard Amateur": "building_backyard_amateur",
    "Firecracker Bundle": "building_firecracker_bundle",
    "Roman Candle Battery": "building_roman_candle",
    "Mortar Tube": "building_mortar_tube",
    "Aerial Shell Rack": "building_aerial_shell",
    "Computerized Sequencer": "building_sequencer",
    "Drone Swarm": "building_drone_swarm",
    "High-Altitude Balloon": "building_balloon",
    "Moon Base Launcher": "building_moon_base",
    "Orbital Cannon": "building_orbital_cannon",
    "Reality Rift": "building_reality_rift",
  ]

  static func icon(forBuilding name: String) -> String {
    buildingIcons[name] ?? "questionmark.square.dashed"
  }

  // MARK: - Building Colors (Theme)
  private static let buildingColors: [String: Color] = [
    "Backyard Amateur": .gray,
    "Firecracker Bundle": .red,
    "Roman Candle Battery": .orange,
    "Mortar Tube": .yellow,
    "Aerial Shell Rack": .green,
    "Computerized Sequencer": .blue,
    "Drone Swarm": .purple,
    "High-Altitude Balloon": .mint,
    "Moon Base Launcher": .indigo,
    "Orbital Cannon": .pink,
    "Reality Rift": .white,  // multi-color in logic?
  ]

  static func color(forBuilding name: String) -> Color {
    buildingColors[name] ?? .secondary
  }
}
