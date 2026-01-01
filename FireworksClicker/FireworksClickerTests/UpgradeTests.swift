import XCTest
@testable import FireworksClicker

final class UpgradeTests: XCTestCase {

    var gameManager: GameManager!

    override func setUp() {
        super.setUp()
        gameManager = GameManager()
    }

    override func tearDown() {
        gameManager = nil
        super.tearDown()
    }

    // MARK: - UpgradeEffectType Tests

    func testUpgradeEffectTypeEncodingDecoding() throws {
        let types: [UpgradeEffectType] = [.costReduction, .productionMultiplier, .clickMultiplier]

        for effectType in types {
            let encoder = JSONEncoder()
            let data = try encoder.encode(effectType)

            let decoder = JSONDecoder()
            let decodedType = try decoder.decode(UpgradeEffectType.self, from: data)

            XCTAssertEqual(decodedType, effectType)
        }
    }

    // MARK: - Enhanced Upgrade Struct Tests

    func testUpgradeWithEffectTypeCreation() {
        let upgradeId = UUID()
        let upgrade = Upgrade(
            id: upgradeId,
            name: "Click Power",
            description: "Doubles click value",
            cost: 100,
            unlockLevel: 1,
            isPurchased: false,
            effectType: .clickMultiplier,
            effectValue: 2.0,
            targetBuildingName: nil
        )

        XCTAssertEqual(upgrade.id, upgradeId)
        XCTAssertEqual(upgrade.name, "Click Power")
        XCTAssertEqual(upgrade.cost, 100, accuracy: 0.001)
        XCTAssertEqual(upgrade.effectType, .clickMultiplier)
        XCTAssertEqual(upgrade.effectValue, 2.0, accuracy: 0.001)
        XCTAssertNil(upgrade.targetBuildingName)
        XCTAssertFalse(upgrade.isPurchased)
    }

    func testUpgradeWithTargetBuilding() {
        let upgrade = Upgrade(
            id: UUID(),
            name: "Firecracker Efficiency",
            description: "Reduces Firecracker Bundle cost by 10%",
            cost: 50,
            unlockLevel: 2,
            isPurchased: false,
            effectType: .costReduction,
            effectValue: 0.9,
            targetBuildingName: "Firecracker Bundle"
        )

        XCTAssertEqual(upgrade.effectType, .costReduction)
        XCTAssertEqual(upgrade.effectValue, 0.9, accuracy: 0.001)
        XCTAssertEqual(upgrade.targetBuildingName, "Firecracker Bundle")
    }

    func testUpgradeEncodingDecodingWithNewFields() throws {
        let originalUpgrade = Upgrade(
            id: UUID(),
            name: "Production Boost",
            description: "Increases production by 25%",
            cost: 200,
            unlockLevel: 3,
            isPurchased: true,
            effectType: .productionMultiplier,
            effectValue: 1.25,
            targetBuildingName: nil
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(originalUpgrade)

        let decoder = JSONDecoder()
        let decodedUpgrade = try decoder.decode(Upgrade.self, from: data)

        XCTAssertEqual(decodedUpgrade.id, originalUpgrade.id)
        XCTAssertEqual(decodedUpgrade.name, originalUpgrade.name)
        XCTAssertEqual(decodedUpgrade.effectType, originalUpgrade.effectType)
        XCTAssertEqual(decodedUpgrade.effectValue, originalUpgrade.effectValue, accuracy: 0.001)
        XCTAssertEqual(decodedUpgrade.targetBuildingName, originalUpgrade.targetBuildingName)
        XCTAssertEqual(decodedUpgrade.isPurchased, originalUpgrade.isPurchased)
    }

    // MARK: - buyUpgrade Tests

    func testBuyUpgrade_withSufficientIP_success() {
        // Setup: Give player enough Innovation Points
        gameManager.innovationPoints = 100

        // Create an upgrade that costs 50 IP
        let upgradeId = UUID()
        let upgrade = Upgrade(
            id: upgradeId,
            name: "Test Upgrade",
            description: "Test",
            cost: 50,
            unlockLevel: 1,
            isPurchased: false,
            effectType: .clickMultiplier,
            effectValue: 2.0,
            targetBuildingName: nil
        )
        gameManager.upgrades = [upgrade]

        // Act
        gameManager.buyUpgrade(upgradeId: upgradeId)

        // Assert
        XCTAssertEqual(gameManager.innovationPoints, 50, accuracy: 0.001, "Should deduct 50 IP")
        XCTAssertTrue(gameManager.upgrades[0].isPurchased, "Upgrade should be marked as purchased")
    }

    func testBuyUpgrade_withInsufficientIP_noChange() {
        // Setup: Give player insufficient Innovation Points
        gameManager.innovationPoints = 30

        let upgradeId = UUID()
        let upgrade = Upgrade(
            id: upgradeId,
            name: "Expensive Upgrade",
            description: "Test",
            cost: 50,
            unlockLevel: 1,
            isPurchased: false,
            effectType: .clickMultiplier,
            effectValue: 2.0,
            targetBuildingName: nil
        )
        gameManager.upgrades = [upgrade]

        // Act
        gameManager.buyUpgrade(upgradeId: upgradeId)

        // Assert
        XCTAssertEqual(gameManager.innovationPoints, 30, accuracy: 0.001, "IP should not change")
        XCTAssertFalse(gameManager.upgrades[0].isPurchased, "Upgrade should not be purchased")
    }

    func testBuyUpgrade_alreadyPurchased_noChange() {
        // Setup: Upgrade already purchased
        gameManager.innovationPoints = 100

        let upgradeId = UUID()
        let upgrade = Upgrade(
            id: upgradeId,
            name: "Already Bought",
            description: "Test",
            cost: 50,
            unlockLevel: 1,
            isPurchased: true,
            effectType: .clickMultiplier,
            effectValue: 2.0,
            targetBuildingName: nil
        )
        gameManager.upgrades = [upgrade]

        // Act
        gameManager.buyUpgrade(upgradeId: upgradeId)

        // Assert
        XCTAssertEqual(gameManager.innovationPoints, 100, accuracy: 0.001, "IP should not be deducted again")
        XCTAssertTrue(gameManager.upgrades[0].isPurchased, "Should still be purchased")
    }

    // MARK: - Production Multiplier Tests

    func testProductionMultiplier_withNoUpgrades_returnsOne() {
        gameManager.upgrades = []

        let multiplier = gameManager.globalProductionMultiplier

        XCTAssertEqual(multiplier, 1.0, accuracy: 0.001, "No upgrades should give 1.0x multiplier")
    }

    func testProductionMultiplier_withUpgrade_appliesCorrectly() {
        // Purchase a production multiplier upgrade
        let upgrade = Upgrade(
            id: UUID(),
            name: "Production Boost",
            description: "25% production increase",
            cost: 50,
            unlockLevel: 1,
            isPurchased: true,
            effectType: .productionMultiplier,
            effectValue: 1.25,
            targetBuildingName: nil
        )
        gameManager.upgrades = [upgrade]

        let multiplier = gameManager.globalProductionMultiplier

        XCTAssertEqual(multiplier, 1.25, accuracy: 0.001, "Should have 1.25x multiplier")
    }

    func testProductionMultiplier_withMultipleUpgrades_multipliesTogether() {
        let upgrade1 = Upgrade(
            id: UUID(),
            name: "Boost 1",
            description: "25% increase",
            cost: 50,
            unlockLevel: 1,
            isPurchased: true,
            effectType: .productionMultiplier,
            effectValue: 1.25,
            targetBuildingName: nil
        )

        let upgrade2 = Upgrade(
            id: UUID(),
            name: "Boost 2",
            description: "50% increase",
            cost: 100,
            unlockLevel: 2,
            isPurchased: true,
            effectType: .productionMultiplier,
            effectValue: 1.5,
            targetBuildingName: nil
        )

        gameManager.upgrades = [upgrade1, upgrade2]

        let multiplier = gameManager.globalProductionMultiplier
        let expected = 1.25 * 1.5

        XCTAssertEqual(multiplier, expected, accuracy: 0.001, "Should multiply upgrades together")
    }

    func testProductionMultiplier_onlyCountsPurchasedUpgrades() {
        let purchasedUpgrade = Upgrade(
            id: UUID(),
            name: "Purchased",
            description: "Bought",
            cost: 50,
            unlockLevel: 1,
            isPurchased: true,
            effectType: .productionMultiplier,
            effectValue: 1.5,
            targetBuildingName: nil
        )

        let unpurchasedUpgrade = Upgrade(
            id: UUID(),
            name: "Not Bought",
            description: "Not bought yet",
            cost: 100,
            unlockLevel: 2,
            isPurchased: false,
            effectType: .productionMultiplier,
            effectValue: 2.0,
            targetBuildingName: nil
        )

        gameManager.upgrades = [purchasedUpgrade, unpurchasedUpgrade]

        let multiplier = gameManager.globalProductionMultiplier

        XCTAssertEqual(multiplier, 1.5, accuracy: 0.001, "Should only count purchased upgrade")
    }

    // MARK: - Cost Multiplier Tests

    func testCostMultiplier_withCostReductionUpgrade_reducesCost() {
        // 10% cost reduction (effectValue = 0.9)
        let upgrade = Upgrade(
            id: UUID(),
            name: "Efficient Sparks",
            description: "10% cost reduction",
            cost: 50,
            unlockLevel: 1,
            isPurchased: true,
            effectType: .costReduction,
            effectValue: 0.9,
            targetBuildingName: nil
        )
        gameManager.upgrades = [upgrade]

        let building = Building(
            id: UUID(),
            name: "Test Building",
            description: "Test",
            baseCost: 100,
            baseSparksProduction: 1,
            baseInnovationProduction: 0.1,
            unlockLevel: 1,
            count: 0
        )

        let multiplier = gameManager.buildingCostMultiplier(for: building)

        XCTAssertEqual(multiplier, 0.9, accuracy: 0.001, "Should have 0.9x cost multiplier")
    }

    func testCostMultiplier_withNoUpgrades_returnsOne() {
        gameManager.upgrades = []

        let building = Building(
            id: UUID(),
            name: "Test Building",
            description: "Test",
            baseCost: 100,
            baseSparksProduction: 1,
            baseInnovationProduction: 0.1,
            unlockLevel: 1,
            count: 0
        )

        let multiplier = gameManager.buildingCostMultiplier(for: building)

        XCTAssertEqual(multiplier, 1.0, accuracy: 0.001, "Should have 1.0x multiplier")
    }

    func testCostMultiplier_withTargetedUpgrade_appliesOnlyToTarget() {
        let targetedUpgrade = Upgrade(
            id: UUID(),
            name: "Firecracker Efficiency",
            description: "10% cost reduction for Firecracker Bundle",
            cost: 50,
            unlockLevel: 1,
            isPurchased: true,
            effectType: .costReduction,
            effectValue: 0.9,
            targetBuildingName: "Firecracker Bundle"
        )
        gameManager.upgrades = [targetedUpgrade]

        let targetBuilding = Building(
            id: UUID(),
            name: "Firecracker Bundle",
            description: "Cheap and loud",
            baseCost: 50,
            baseSparksProduction: 2,
            baseInnovationProduction: 0.1,
            unlockLevel: 1,
            count: 0
        )

        let otherBuilding = Building(
            id: UUID(),
            name: "Other Building",
            description: "Different",
            baseCost: 100,
            baseSparksProduction: 5,
            baseInnovationProduction: 0.5,
            unlockLevel: 1,
            count: 0
        )

        let targetMultiplier = gameManager.buildingCostMultiplier(for: targetBuilding)
        let otherMultiplier = gameManager.buildingCostMultiplier(for: otherBuilding)

        XCTAssertEqual(targetMultiplier, 0.9, accuracy: 0.001, "Target building should have reduced cost")
        XCTAssertEqual(otherMultiplier, 1.0, accuracy: 0.001, "Other building should have normal cost")
    }

    func testCostMultiplier_withMultipleReductions_multipliesTogether() {
        let globalReduction = Upgrade(
            id: UUID(),
            name: "Global Efficiency",
            description: "10% cost reduction",
            cost: 50,
            unlockLevel: 1,
            isPurchased: true,
            effectType: .costReduction,
            effectValue: 0.9,
            targetBuildingName: nil
        )

        let targetedReduction = Upgrade(
            id: UUID(),
            name: "Specific Efficiency",
            description: "Additional 10% cost reduction for Test Building",
            cost: 100,
            unlockLevel: 2,
            isPurchased: true,
            effectType: .costReduction,
            effectValue: 0.9,
            targetBuildingName: "Test Building"
        )

        gameManager.upgrades = [globalReduction, targetedReduction]

        let building = Building(
            id: UUID(),
            name: "Test Building",
            description: "Test",
            baseCost: 100,
            baseSparksProduction: 1,
            baseInnovationProduction: 0.1,
            unlockLevel: 1,
            count: 0
        )

        let multiplier = gameManager.buildingCostMultiplier(for: building)
        let expected = 0.9 * 0.9

        XCTAssertEqual(multiplier, expected, accuracy: 0.001, "Should multiply both reductions")
    }

    // MARK: - Click Multiplier Tests

    func testClickMultiplier_withNoUpgrades_returnsOne() {
        gameManager.upgrades = []

        let multiplier = gameManager.clickMultiplier

        XCTAssertEqual(multiplier, 1.0, accuracy: 0.001, "Should have 1.0x click multiplier")
    }

    func testClickMultiplier_withClickUpgrade_increasesClickValue() {
        let upgrade = Upgrade(
            id: UUID(),
            name: "Click Power",
            description: "Doubles click value",
            cost: 50,
            unlockLevel: 1,
            isPurchased: true,
            effectType: .clickMultiplier,
            effectValue: 2.0,
            targetBuildingName: nil
        )
        gameManager.upgrades = [upgrade]

        let multiplier = gameManager.clickMultiplier

        XCTAssertEqual(multiplier, 2.0, accuracy: 0.001, "Should have 2.0x click multiplier")
    }

    func testClickMultiplier_withMultipleUpgrades_multipliesTogether() {
        let upgrade1 = Upgrade(
            id: UUID(),
            name: "Click Power 1",
            description: "Doubles clicks",
            cost: 50,
            unlockLevel: 1,
            isPurchased: true,
            effectType: .clickMultiplier,
            effectValue: 2.0,
            targetBuildingName: nil
        )

        let upgrade2 = Upgrade(
            id: UUID(),
            name: "Click Power 2",
            description: "Triples clicks",
            cost: 100,
            unlockLevel: 2,
            isPurchased: true,
            effectType: .clickMultiplier,
            effectValue: 3.0,
            targetBuildingName: nil
        )

        gameManager.upgrades = [upgrade1, upgrade2]

        let multiplier = gameManager.clickMultiplier
        let expected = 2.0 * 3.0

        XCTAssertEqual(multiplier, expected, accuracy: 0.001, "Should multiply click upgrades together")
    }

    // MARK: - Integration Tests

    func testClick_withMultiplier_appliesCorrectly() {
        gameManager.sparks = 0

        let upgrade = Upgrade(
            id: UUID(),
            name: "Click Power",
            description: "Doubles clicks",
            cost: 50,
            unlockLevel: 1,
            isPurchased: true,
            effectType: .clickMultiplier,
            effectValue: 2.0,
            targetBuildingName: nil
        )
        gameManager.upgrades = [upgrade]

        gameManager.click()

        XCTAssertEqual(gameManager.sparks, 2.0, accuracy: 0.001, "Click should give 2 sparks with 2x multiplier")
    }

    func testTick_withProductionMultiplier_appliesCorrectly() {
        gameManager.sparks = 0
        gameManager.innovationPoints = 0

        // Add a building that produces 5 sparks/sec and 0.5 IP/sec
        var building = Building(
            id: UUID(),
            name: "Test Building",
            description: "Test",
            baseCost: 100,
            baseSparksProduction: 5,
            baseInnovationProduction: 0.5,
            unlockLevel: 1,
            count: 1
        )
        gameManager.buildings = [building]

        // Add a 1.5x production multiplier
        let upgrade = Upgrade(
            id: UUID(),
            name: "Production Boost",
            description: "50% production increase",
            cost: 50,
            unlockLevel: 1,
            isPurchased: true,
            effectType: .productionMultiplier,
            effectValue: 1.5,
            targetBuildingName: nil
        )
        gameManager.upgrades = [upgrade]

        gameManager.tick()

        XCTAssertEqual(gameManager.sparks, 7.5, accuracy: 0.001, "Should produce 5 * 1.5 = 7.5 sparks")
        XCTAssertEqual(gameManager.innovationPoints, 0.75, accuracy: 0.001, "Should produce 0.5 * 1.5 = 0.75 IP")
    }

    func testBuyBuilding_withCostReduction_appliesCorrectly() {
        gameManager.sparks = 100

        // Add a building with base cost 100
        let buildingId = UUID()
        let building = Building(
            id: buildingId,
            name: "Test Building",
            description: "Test",
            baseCost: 100,
            baseSparksProduction: 5,
            baseInnovationProduction: 0.5,
            unlockLevel: 1,
            count: 0
        )
        gameManager.buildings = [building]

        // Add 10% cost reduction (0.9x multiplier)
        let upgrade = Upgrade(
            id: UUID(),
            name: "Cost Reduction",
            description: "10% cheaper buildings",
            cost: 50,
            unlockLevel: 1,
            isPurchased: true,
            effectType: .costReduction,
            effectValue: 0.9,
            targetBuildingName: nil
        )
        gameManager.upgrades = [upgrade]

        gameManager.buyBuilding(buildingId: buildingId)

        // Cost should be 100 * 0.9 = 90
        XCTAssertEqual(gameManager.sparks, 10, accuracy: 0.001, "Should spend 90 sparks (100 - 90 = 10 remaining)")
        XCTAssertEqual(gameManager.buildings[0].count, 1, "Should have purchased 1 building")
    }
}
