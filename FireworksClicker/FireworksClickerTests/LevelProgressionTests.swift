import XCTest
@testable import FireworksClicker

final class LevelProgressionTests: XCTestCase {

    // MARK: - Initial Level Tests

    func testInitialLevel_isOne() {
        let gameManager = GameManager()
        XCTAssertEqual(gameManager.currentLevel, 1)
    }

    // MARK: - Level Up Tests

    func testLevelUp_withSufficientIP_success() {
        let gameManager = GameManager()
        // Level 2 requires 10 IP
        gameManager.innovationPoints = 10

        let result = gameManager.levelUp()

        XCTAssertTrue(result)
        XCTAssertEqual(gameManager.currentLevel, 2)
        XCTAssertEqual(gameManager.innovationPoints, 0, accuracy: 0.001)
    }

    func testLevelUp_withInsufficientIP_fails() {
        let gameManager = GameManager()
        // Level 2 requires 10 IP, but we only have 5
        gameManager.innovationPoints = 5

        let result = gameManager.levelUp()

        XCTAssertFalse(result)
        XCTAssertEqual(gameManager.currentLevel, 1)
        XCTAssertEqual(gameManager.innovationPoints, 5, accuracy: 0.001)
    }

    func testLevelUp_atMaxLevel_fails() {
        let gameManager = GameManager()
        // Set to max level (10) and give plenty of IP
        gameManager.currentLevel = 10
        gameManager.innovationPoints = 999999999

        let result = gameManager.levelUp()

        XCTAssertFalse(result)
        XCTAssertEqual(gameManager.currentLevel, 10)
        XCTAssertEqual(gameManager.innovationPoints, 999999999, accuracy: 0.001)
    }

    func testLevelUp_multipleTimes() {
        let gameManager = GameManager()
        // Give enough IP to level up from 1 to 3 (requires 10 + 50 = 60)
        gameManager.innovationPoints = 60

        // Level up to 2
        let result1 = gameManager.levelUp()
        XCTAssertTrue(result1)
        XCTAssertEqual(gameManager.currentLevel, 2)
        XCTAssertEqual(gameManager.innovationPoints, 50, accuracy: 0.001)

        // Level up to 3
        let result2 = gameManager.levelUp()
        XCTAssertTrue(result2)
        XCTAssertEqual(gameManager.currentLevel, 3)
        XCTAssertEqual(gameManager.innovationPoints, 0, accuracy: 0.001)
    }

    // MARK: - Available Buildings Tests

    func testAvailableBuildings_filtersbyLevel() {
        let gameManager = GameManager()

        // At level 1, should only see buildings with unlockLevel 1
        let level1Buildings = gameManager.availableBuildings
        XCTAssertTrue(level1Buildings.allSatisfy { $0.unlockLevel == 1 })
        XCTAssertEqual(level1Buildings.count, 2) // Backyard Amateur and Firecracker Bundle

        // Level up to 2
        gameManager.innovationPoints = 10
        _ = gameManager.levelUp()

        // At level 2, should see buildings with unlockLevel 1 and 2
        let level2Buildings = gameManager.availableBuildings
        XCTAssertTrue(level2Buildings.allSatisfy { $0.unlockLevel <= 2 })
        XCTAssertEqual(level2Buildings.count, 3) // Added Roman Candle Battery

        // Level up to 3
        gameManager.innovationPoints = 50
        _ = gameManager.levelUp()

        // At level 3, should see buildings with unlockLevel 1, 2, and 3
        let level3Buildings = gameManager.availableBuildings
        XCTAssertTrue(level3Buildings.allSatisfy { $0.unlockLevel <= 3 })
        XCTAssertEqual(level3Buildings.count, 4) // Added Mortar Tube
    }

    // MARK: - Available Upgrades Tests

    func testAvailableUpgrades_filtersByLevel() {
        let gameManager = GameManager()

        // Create some test upgrades with different unlock levels
        gameManager.upgrades = [
            Upgrade(id: UUID(), name: "Upgrade 1", description: "Level 1 upgrade", cost: 100, unlockLevel: 1, isPurchased: false, effectType: .productionMultiplier, effectValue: 1.5, targetBuildingName: nil),
            Upgrade(id: UUID(), name: "Upgrade 2", description: "Level 2 upgrade", cost: 200, unlockLevel: 2, isPurchased: false, effectType: .productionMultiplier, effectValue: 1.5, targetBuildingName: nil),
            Upgrade(id: UUID(), name: "Upgrade 3", description: "Level 3 upgrade", cost: 300, unlockLevel: 3, isPurchased: false, effectType: .productionMultiplier, effectValue: 1.5, targetBuildingName: nil),
        ]

        // At level 1, should only see upgrades with unlockLevel 1
        let level1Upgrades = gameManager.availableUpgrades
        XCTAssertTrue(level1Upgrades.allSatisfy { $0.unlockLevel == 1 })
        XCTAssertEqual(level1Upgrades.count, 1)

        // Level up to 2
        gameManager.innovationPoints = 10
        _ = gameManager.levelUp()

        // At level 2, should see upgrades with unlockLevel 1 and 2
        let level2Upgrades = gameManager.availableUpgrades
        XCTAssertTrue(level2Upgrades.allSatisfy { $0.unlockLevel <= 2 })
        XCTAssertEqual(level2Upgrades.count, 2)

        // Level up to 3
        gameManager.innovationPoints = 50
        _ = gameManager.levelUp()

        // At level 3, should see upgrades with unlockLevel 1, 2, and 3
        let level3Upgrades = gameManager.availableUpgrades
        XCTAssertTrue(level3Upgrades.allSatisfy { $0.unlockLevel <= 3 })
        XCTAssertEqual(level3Upgrades.count, 3)
    }

    // MARK: - canLevelUp Tests

    func testCanLevelUp_withEnoughIP_returnsTrue() {
        let gameManager = GameManager()
        gameManager.innovationPoints = 10 // Enough for level 2

        XCTAssertTrue(gameManager.canLevelUp)
    }

    func testCanLevelUp_withInsufficientIP_returnsFalse() {
        let gameManager = GameManager()
        gameManager.innovationPoints = 5 // Not enough for level 2

        XCTAssertFalse(gameManager.canLevelUp)
    }

    func testCanLevelUp_atMaxLevel_returnsFalse() {
        let gameManager = GameManager()
        gameManager.currentLevel = 10
        gameManager.innovationPoints = 999999999 // Plenty of IP, but at max level

        XCTAssertFalse(gameManager.canLevelUp)
    }

    func testCanLevelUp_justEnoughIP() {
        let gameManager = GameManager()
        gameManager.innovationPoints = 10.0 // Exactly enough for level 2

        XCTAssertTrue(gameManager.canLevelUp)
    }

    // MARK: - Level Definition Tests

    func testCurrentLevelDefinition() {
        let gameManager = GameManager()

        let level1Def = gameManager.currentLevelDefinition
        XCTAssertEqual(level1Def.id, 1)
        XCTAssertEqual(level1Def.name, "Backyard Beginner")

        // Level up to 2
        gameManager.innovationPoints = 10
        _ = gameManager.levelUp()

        let level2Def = gameManager.currentLevelDefinition
        XCTAssertEqual(level2Def.id, 2)
        XCTAssertEqual(level2Def.name, "Neighborhood Enthusiast")
    }

    func testNextLevelDefinition() {
        let gameManager = GameManager()

        // At level 1, next should be level 2
        let nextLevel = gameManager.nextLevelDefinition
        XCTAssertNotNil(nextLevel)
        XCTAssertEqual(nextLevel?.id, 2)
        XCTAssertEqual(nextLevel?.unlockCost, 10)

        // Level up to max level
        gameManager.currentLevel = 10

        // At max level, next should be nil
        let nextLevelAtMax = gameManager.nextLevelDefinition
        XCTAssertNil(nextLevelAtMax)
    }

    // MARK: - LevelDefinition Data Tests

    func testLevelDefinitions_allLevels() {
        let gameManager = GameManager()

        // Should have 10 levels
        XCTAssertEqual(gameManager.levels.count, 10)

        // Verify level 1
        XCTAssertEqual(gameManager.levels[0].id, 1)
        XCTAssertEqual(gameManager.levels[0].unlockCost, 0)

        // Verify level 10 exists
        XCTAssertEqual(gameManager.levels[9].id, 10)
        XCTAssertEqual(gameManager.levels[9].name, "Universal Legend")
    }

    func testLevelDefinitions_increasingCosts() {
        let gameManager = GameManager()

        // Verify costs are increasing
        for i in 0..<(gameManager.levels.count - 1) {
            XCTAssertLessThan(gameManager.levels[i].unlockCost, gameManager.levels[i + 1].unlockCost)
        }
    }
}
