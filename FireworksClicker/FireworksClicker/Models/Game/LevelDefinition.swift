import Foundation

struct LevelDefinition: Identifiable, Codable {
    let id: Int  // Level number (1-10)
    let name: String
    let unlockCost: Double  // Innovation Points required
    let description: String

    static let allLevels: [Self] = [
        Self(
            id: 1,
            name: "Backyard Beginner",
            unlockCost: 0,
            description: "Starting out with simple backyard fireworks"
        ),
        Self(
            id: 2,
            name: "Neighborhood Enthusiast",
            unlockCost: 10,
            description: "Your shows are the talk of the block"
        ),
        Self(
            id: 3,
            name: "Local Expert",
            unlockCost: 50,
            description: "The whole town knows your name"
        ),
        Self(
            id: 4,
            name: "City Pyrotechnician",
            unlockCost: 200,
            description: "Lighting up the city skyline"
        ),
        Self(
            id: 5,
            name: "Regional Champion",
            unlockCost: 1000,
            description: "Famous across multiple states"
        ),
        Self(
            id: 6,
            name: "National Star",
            unlockCost: 5000,
            description: "Your shows attract audiences from across the nation"
        ),
        Self(
            id: 7,
            name: "Continental Master",
            unlockCost: 25000,
            description: "Continental tours and international acclaim"
        ),
        Self(
            id: 8,
            name: "World Renowned",
            unlockCost: 100000,
            description: "The world's premier pyrotechnics expert"
        ),
        Self(
            id: 9,
            name: "Cosmic Pioneer",
            unlockCost: 500000,
            description: "Taking fireworks beyond Earth's atmosphere"
        ),
        Self(
            id: 10,
            name: "Universal Legend",
            unlockCost: 2000000,
            description: "Bending reality itself with your displays"
        ),
    ]
}
