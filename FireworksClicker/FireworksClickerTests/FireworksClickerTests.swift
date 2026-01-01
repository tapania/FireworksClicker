import XCTest

@testable import FireworksClicker

final class GameManagerTests: XCTestCase {
  var gameManager: GameManager!

  override func setUp() {
    super.setUp()
    gameManager = GameManager()
  }

  override func tearDown() {
    gameManager = nil
    super.tearDown()
  }

  // MARK: - Initial State Tests

  func test_initialState() {
    // Verify initial state values
    XCTAssertEqual(gameManager.sparks, 0, "Initial sparks should be 0")
    XCTAssertEqual(gameManager.innovationPoints, 0, "Initial innovation points should be 0")
    XCTAssertEqual(gameManager.currentLevel, 1, "Initial level should be 1")
  }

  func test_setupBuildings_createsAllBuildings() {
    // Verify all 11 buildings are created
    XCTAssertEqual(gameManager.buildings.count, 11, "Should have 11 buildings")

    // Verify all buildings start with count 0
    for building in gameManager.buildings {
      XCTAssertEqual(building.count, 0, "Building \(building.name) should start with count 0")
    }
  }

  // MARK: - Click Tests

  func test_click_incrementsSparks() {
    let initialSparks = gameManager.sparks
    gameManager.click()
    XCTAssertEqual(gameManager.sparks, initialSparks + 1, "Click should add 1 spark")
  }

  func test_click_multipleClicks_incrementsSparksCorrectly() {
    gameManager.click()
    gameManager.click()
    gameManager.click()
    XCTAssertEqual(gameManager.sparks, 3, "Three clicks should add 3 sparks")
  }

  // MARK: - Tick Tests

  func test_tick_withNoBuildings_noResourceChange() {
    // All buildings start with count 0, so no production
    let initialSparks = gameManager.sparks
    let initialInnovation = gameManager.innovationPoints

    // Directly call tick() for deterministic testing
    gameManager.tick()

    XCTAssertEqual(gameManager.sparks, initialSparks, "Sparks should not change with no buildings owned")
    XCTAssertEqual(
      gameManager.innovationPoints, initialInnovation,
      "Innovation points should not change with no buildings owned")
  }

  func test_tick_withBuildings_incrementsResources() {
    // Give player enough sparks to buy a building
    gameManager.sparks = 100

    // Buy the first building (Backyard Amateur: baseCost=10, sparksProduction=1, innovationProduction=0)
    let firstBuildingId = gameManager.buildings[0].id
    gameManager.buyBuilding(buildingId: firstBuildingId)

    // Verify building was purchased
    XCTAssertEqual(gameManager.buildings[0].count, 1, "Building should be purchased")

    let sparksAfterPurchase = gameManager.sparks
    let innovationAfterPurchase = gameManager.innovationPoints

    // Directly call tick() for deterministic testing
    gameManager.tick()

    // First building produces 1 spark per second, 0 innovation
    XCTAssertEqual(
      gameManager.sparks, sparksAfterPurchase + 1,
      "Sparks should increase by building production")
    XCTAssertEqual(
      gameManager.innovationPoints, innovationAfterPurchase,
      "Innovation points should match building production (0 for first building)")
  }

  func test_tick_withMultipleBuildings_incrementsResourcesCorrectly() {
    // Give player enough sparks
    gameManager.sparks = 1000

    // Buy first building (1 spark/sec, 0 innovation/sec)
    let firstBuildingId = gameManager.buildings[0].id
    gameManager.buyBuilding(buildingId: firstBuildingId)

    // Buy second building (2 sparks/sec, 0.1 innovation/sec)
    let secondBuildingId = gameManager.buildings[1].id
    gameManager.buyBuilding(buildingId: secondBuildingId)

    let sparksAfterPurchase = gameManager.sparks
    let innovationAfterPurchase = gameManager.innovationPoints

    // Directly call tick() for deterministic testing
    gameManager.tick()

    // Total production: 1 + 2 = 3 sparks/sec, 0 + 0.1 = 0.1 innovation/sec
    XCTAssertEqual(
      gameManager.sparks, sparksAfterPurchase + 3,
      "Sparks should increase by combined building production")
    XCTAssertEqual(
      gameManager.innovationPoints, innovationAfterPurchase + 0.1, accuracy: 0.001,
      "Innovation points should increase by combined building production")
  }

  // MARK: - Buy Building Tests

  func test_buyBuilding_withSufficientFunds_success() {
    // First building costs 10 sparks
    gameManager.sparks = 100
    let initialSparks = gameManager.sparks

    let firstBuildingId = gameManager.buildings[0].id
    let buildingCost = gameManager.buildings[0].currentCost()  // Should be 10

    gameManager.buyBuilding(buildingId: firstBuildingId)

    XCTAssertEqual(gameManager.buildings[0].count, 1, "Building count should increment to 1")
    XCTAssertEqual(gameManager.sparks, initialSparks - buildingCost, "Sparks should be deducted by cost")
  }

  func test_buyBuilding_withInsufficientFunds_noChange() {
    // First building costs 10 sparks, give player only 5
    gameManager.sparks = 5
    let initialSparks = gameManager.sparks

    let firstBuildingId = gameManager.buildings[0].id

    gameManager.buyBuilding(buildingId: firstBuildingId)

    XCTAssertEqual(gameManager.buildings[0].count, 0, "Building count should remain 0")
    XCTAssertEqual(gameManager.sparks, initialSparks, "Sparks should not change")
  }

  func test_buyBuilding_withExactFunds_success() {
    // First building costs exactly 10 sparks
    gameManager.sparks = 10

    let firstBuildingId = gameManager.buildings[0].id

    gameManager.buyBuilding(buildingId: firstBuildingId)

    XCTAssertEqual(gameManager.buildings[0].count, 1, "Building count should increment to 1")
    XCTAssertEqual(gameManager.sparks, 0, "Sparks should be exactly 0 after purchase")
  }

  func test_buyBuilding_costScalesWithCount() {
    // Buy multiple of the same building and verify cost scaling
    gameManager.sparks = 1000

    let firstBuildingId = gameManager.buildings[0].id
    let baseCost = gameManager.buildings[0].baseCost  // 10

    // First purchase: cost = 10 * 1.15^0 = 10
    let firstCost = gameManager.buildings[0].currentCost()
    XCTAssertEqual(firstCost, baseCost, accuracy: 0.01, "First purchase cost should equal base cost")

    gameManager.buyBuilding(buildingId: firstBuildingId)

    // Second purchase: cost = 10 * 1.15^1 = 11.5
    let secondCost = gameManager.buildings[0].currentCost()
    XCTAssertEqual(
      secondCost, baseCost * 1.15, accuracy: 0.01, "Second purchase cost should be base * 1.15")

    gameManager.buyBuilding(buildingId: firstBuildingId)

    // Third purchase: cost = 10 * 1.15^2 = 13.225
    let thirdCost = gameManager.buildings[0].currentCost()
    XCTAssertEqual(
      thirdCost, baseCost * pow(1.15, 2), accuracy: 0.01, "Third purchase cost should be base * 1.15^2")
  }

  func test_buyBuilding_withInvalidId_noChange() {
    gameManager.sparks = 1000
    let initialSparks = gameManager.sparks
    let invalidId = UUID()

    gameManager.buyBuilding(buildingId: invalidId)

    // Nothing should change
    XCTAssertEqual(gameManager.sparks, initialSparks, "Sparks should not change with invalid building ID")
    for building in gameManager.buildings {
      XCTAssertEqual(building.count, 0, "No building counts should change")
    }
  }
}
