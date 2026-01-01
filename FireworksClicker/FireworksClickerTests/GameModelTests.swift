import XCTest
@testable import FireworksClicker

final class GameModelTests: XCTestCase {

    // MARK: - Building.currentCost() Tests

    func testBuildingCurrentCostWithZeroCount() {
        // Building with baseCost 100, count 0 should cost 100 * 1.15^0 = 100
        let building = Building(
            id: UUID(),
            name: "Test Building",
            description: "A test building",
            baseCost: 100,
            baseSparksProduction: 1,
            baseInnovationProduction: 0.1,
            unlockLevel: 1,
            count: 0
        )
        XCTAssertEqual(building.currentCost(), 100, accuracy: 0.001)
    }

    func testBuildingCurrentCostWithCountOne() {
        // Building with baseCost 100, count 1 should cost 100 * 1.15^1 = 115
        let building = Building(
            id: UUID(),
            name: "Test Building",
            description: "A test building",
            baseCost: 100,
            baseSparksProduction: 1,
            baseInnovationProduction: 0.1,
            unlockLevel: 1,
            count: 1
        )
        XCTAssertEqual(building.currentCost(), 115, accuracy: 0.001)
    }

    func testBuildingCurrentCostWithCountFive() {
        // Building with baseCost 100, count 5 should cost 100 * 1.15^5 = 201.1357...
        let building = Building(
            id: UUID(),
            name: "Test Building",
            description: "A test building",
            baseCost: 100,
            baseSparksProduction: 1,
            baseInnovationProduction: 0.1,
            unlockLevel: 1,
            count: 5
        )
        let expectedCost = 100 * pow(1.15, 5)
        XCTAssertEqual(building.currentCost(), expectedCost, accuracy: 0.001)
    }

    func testBuildingCurrentCostWithCountTen() {
        // Building with baseCost 100, count 10 should cost 100 * 1.15^10 = 404.5558...
        let building = Building(
            id: UUID(),
            name: "Test Building",
            description: "A test building",
            baseCost: 100,
            baseSparksProduction: 1,
            baseInnovationProduction: 0.1,
            unlockLevel: 1,
            count: 10
        )
        let expectedCost = 100 * pow(1.15, 10)
        XCTAssertEqual(building.currentCost(), expectedCost, accuracy: 0.001)
    }

    // MARK: - Building.totalSparksPerSecond() Tests

    func testBuildingTotalSparksPerSecondWithZeroCount() {
        let building = Building(
            id: UUID(),
            name: "Test Building",
            description: "A test building",
            baseCost: 100,
            baseSparksProduction: 5,
            baseInnovationProduction: 0.1,
            unlockLevel: 1,
            count: 0
        )
        XCTAssertEqual(building.totalSparksPerSecond(), 0, accuracy: 0.001)
    }

    func testBuildingTotalSparksPerSecondWithCountOne() {
        let building = Building(
            id: UUID(),
            name: "Test Building",
            description: "A test building",
            baseCost: 100,
            baseSparksProduction: 5,
            baseInnovationProduction: 0.1,
            unlockLevel: 1,
            count: 1
        )
        XCTAssertEqual(building.totalSparksPerSecond(), 5, accuracy: 0.001)
    }

    func testBuildingTotalSparksPerSecondWithCountFive() {
        let building = Building(
            id: UUID(),
            name: "Test Building",
            description: "A test building",
            baseCost: 100,
            baseSparksProduction: 5,
            baseInnovationProduction: 0.1,
            unlockLevel: 1,
            count: 5
        )
        XCTAssertEqual(building.totalSparksPerSecond(), 25, accuracy: 0.001)
    }

    // MARK: - Building.totalInnovationPerSecond() Tests

    func testBuildingTotalInnovationPerSecondWithZeroCount() {
        let building = Building(
            id: UUID(),
            name: "Test Building",
            description: "A test building",
            baseCost: 100,
            baseSparksProduction: 1,
            baseInnovationProduction: 0.5,
            unlockLevel: 1,
            count: 0
        )
        XCTAssertEqual(building.totalInnovationPerSecond(), 0, accuracy: 0.001)
    }

    func testBuildingTotalInnovationPerSecondWithCountOne() {
        let building = Building(
            id: UUID(),
            name: "Test Building",
            description: "A test building",
            baseCost: 100,
            baseSparksProduction: 1,
            baseInnovationProduction: 0.5,
            unlockLevel: 1,
            count: 1
        )
        XCTAssertEqual(building.totalInnovationPerSecond(), 0.5, accuracy: 0.001)
    }

    func testBuildingTotalInnovationPerSecondWithCountFive() {
        let building = Building(
            id: UUID(),
            name: "Test Building",
            description: "A test building",
            baseCost: 100,
            baseSparksProduction: 1,
            baseInnovationProduction: 0.5,
            unlockLevel: 1,
            count: 5
        )
        XCTAssertEqual(building.totalInnovationPerSecond(), 2.5, accuracy: 0.001)
    }

    // MARK: - Resource Tests

    func testResourceCreation() {
        let sparksResource = Resource(type: .sparks, amount: 100.5)
        XCTAssertEqual(sparksResource.type, .sparks)
        XCTAssertEqual(sparksResource.amount, 100.5, accuracy: 0.001)

        let innovationResource = Resource(type: .innovationPoints, amount: 50.25)
        XCTAssertEqual(innovationResource.type, .innovationPoints)
        XCTAssertEqual(innovationResource.amount, 50.25, accuracy: 0.001)
    }

    func testResourceEncodingDecoding() throws {
        let originalResource = Resource(type: .sparks, amount: 250.75)

        let encoder = JSONEncoder()
        let data = try encoder.encode(originalResource)

        let decoder = JSONDecoder()
        let decodedResource = try decoder.decode(Resource.self, from: data)

        XCTAssertEqual(decodedResource.type, originalResource.type)
        XCTAssertEqual(decodedResource.amount, originalResource.amount, accuracy: 0.001)
    }

    func testResourceTypeEncodingDecoding() throws {
        for resourceType in ResourceType.allCases {
            let encoder = JSONEncoder()
            let data = try encoder.encode(resourceType)

            let decoder = JSONDecoder()
            let decodedType = try decoder.decode(ResourceType.self, from: data)

            XCTAssertEqual(decodedType, resourceType)
        }
    }

    // MARK: - Upgrade Tests

    func testUpgradeCreation() {
        let upgradeId = UUID()
        let upgrade = Upgrade(
            id: upgradeId,
            name: "Double Click Power",
            description: "Doubles the sparks per click",
            cost: 500,
            unlockLevel: 2,
            isPurchased: false
        )

        XCTAssertEqual(upgrade.id, upgradeId)
        XCTAssertEqual(upgrade.name, "Double Click Power")
        XCTAssertEqual(upgrade.description, "Doubles the sparks per click")
        XCTAssertEqual(upgrade.cost, 500, accuracy: 0.001)
        XCTAssertEqual(upgrade.unlockLevel, 2)
        XCTAssertFalse(upgrade.isPurchased)
    }

    func testUpgradePurchasedState() {
        var upgrade = Upgrade(
            id: UUID(),
            name: "Test Upgrade",
            description: "Test description",
            cost: 100,
            unlockLevel: 1,
            isPurchased: false
        )

        XCTAssertFalse(upgrade.isPurchased)

        upgrade.isPurchased = true
        XCTAssertTrue(upgrade.isPurchased)
    }

    func testUpgradeEncodingDecoding() throws {
        let originalUpgrade = Upgrade(
            id: UUID(),
            name: "Speed Boost",
            description: "Increases production speed",
            cost: 1000,
            unlockLevel: 3,
            isPurchased: true
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(originalUpgrade)

        let decoder = JSONDecoder()
        let decodedUpgrade = try decoder.decode(Upgrade.self, from: data)

        XCTAssertEqual(decodedUpgrade.id, originalUpgrade.id)
        XCTAssertEqual(decodedUpgrade.name, originalUpgrade.name)
        XCTAssertEqual(decodedUpgrade.description, originalUpgrade.description)
        XCTAssertEqual(decodedUpgrade.cost, originalUpgrade.cost, accuracy: 0.001)
        XCTAssertEqual(decodedUpgrade.unlockLevel, originalUpgrade.unlockLevel)
        XCTAssertEqual(decodedUpgrade.isPurchased, originalUpgrade.isPurchased)
    }

    // MARK: - Building Encoding/Decoding Tests

    func testBuildingEncodingDecoding() throws {
        let originalBuilding = Building(
            id: UUID(),
            name: "Sparkler Stand",
            description: "A basic sparkler production stand",
            baseCost: 50,
            baseSparksProduction: 2,
            baseInnovationProduction: 0.1,
            unlockLevel: 1,
            count: 3
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(originalBuilding)

        let decoder = JSONDecoder()
        let decodedBuilding = try decoder.decode(Building.self, from: data)

        XCTAssertEqual(decodedBuilding.id, originalBuilding.id)
        XCTAssertEqual(decodedBuilding.name, originalBuilding.name)
        XCTAssertEqual(decodedBuilding.description, originalBuilding.description)
        XCTAssertEqual(decodedBuilding.baseCost, originalBuilding.baseCost, accuracy: 0.001)
        XCTAssertEqual(decodedBuilding.baseSparksProduction, originalBuilding.baseSparksProduction, accuracy: 0.001)
        XCTAssertEqual(decodedBuilding.baseInnovationProduction, originalBuilding.baseInnovationProduction, accuracy: 0.001)
        XCTAssertEqual(decodedBuilding.unlockLevel, originalBuilding.unlockLevel)
        XCTAssertEqual(decodedBuilding.count, originalBuilding.count)
    }
}
