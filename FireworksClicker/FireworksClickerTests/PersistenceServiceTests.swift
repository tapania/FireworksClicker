import XCTest
@testable import FireworksClicker

final class PersistenceServiceTests: XCTestCase {

  var persistenceService: PersistenceService!
  var testFileURL: URL!

  override func setUp() {
    super.setUp()
    // Use a test-specific file to avoid interfering with actual saves
    let testFileName = "test_game_state_\(UUID().uuidString).json"
    testFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      .appendingPathComponent(testFileName)
    persistenceService = PersistenceService(fileURL: testFileURL)
  }

  override func tearDown() {
    // Clean up test file
    try? FileManager.default.removeItem(at: testFileURL)
    persistenceService = nil
    testFileURL = nil
    super.tearDown()
  }

  // MARK: - Save and Load Tests

  func testSaveAndLoadGameState_preservesAllData() throws {
    // Create test game state
    let buildingId1 = UUID()
    let buildingId2 = UUID()
    let upgradeId = UUID()

    let buildings = [
      GameState.BuildingState(id: buildingId1, count: 5),
      GameState.BuildingState(id: buildingId2, count: 3),
    ]

    let upgrades = [
      Upgrade(
        id: upgradeId,
        name: "Test Upgrade",
        description: "A test upgrade",
        cost: 500,
        unlockLevel: 2,
        isPurchased: true,
        effectType: .productionMultiplier,
        effectValue: 1.5,
        targetBuildingName: nil
      ),
    ]

    let originalState = GameState(
      sparks: 1234.56,
      innovationPoints: 78.90,
      currentLevel: 3,
      buildings: buildings,
      upgrades: upgrades,
      lastSaved: Date()
    )

    // Save the state
    try persistenceService.save(gameState: originalState)

    // Load the state
    let loadedState = try persistenceService.load()

    // Verify all data is preserved
    guard let loadedState = loadedState else {
      XCTFail("loadedState should not be nil")
      return
    }

    XCTAssertEqual(loadedState.sparks, originalState.sparks, accuracy: 0.001)
    XCTAssertEqual(loadedState.innovationPoints, originalState.innovationPoints, accuracy: 0.001)
    XCTAssertEqual(loadedState.currentLevel, originalState.currentLevel)

    // Verify buildings
    XCTAssertEqual(loadedState.buildings.count, originalState.buildings.count)
    XCTAssertEqual(loadedState.buildings[0].id, buildingId1)
    XCTAssertEqual(loadedState.buildings[0].count, 5)
    XCTAssertEqual(loadedState.buildings[1].id, buildingId2)
    XCTAssertEqual(loadedState.buildings[1].count, 3)

    // Verify upgrades
    XCTAssertEqual(loadedState.upgrades.count, originalState.upgrades.count)
    XCTAssertEqual(loadedState.upgrades[0].id, upgradeId)
    XCTAssertEqual(loadedState.upgrades[0].name, "Test Upgrade")
    XCTAssertEqual(loadedState.upgrades[0].isPurchased, true)

    // Verify timestamp is preserved (within 1 second tolerance for encoding)
    XCTAssertEqual(loadedState.lastSaved.timeIntervalSince1970, originalState.lastSaved.timeIntervalSince1970, accuracy: 1.0)
  }

  func testLoadGameState_whenNoSavedData_returnsNil() throws {
    // Ensure no file exists
    try? FileManager.default.removeItem(at: testFileURL)

    // Attempt to load
    let loadedState = try persistenceService.load()

    // Should return nil when no save file exists
    XCTAssertNil(loadedState)
  }

  func testSaveGameState_createsFile() throws {
    // Ensure file doesn't exist initially
    try? FileManager.default.removeItem(at: testFileURL)
    XCTAssertFalse(FileManager.default.fileExists(atPath: testFileURL.path))

    // Create minimal game state
    let gameState = GameState(
      sparks: 100,
      innovationPoints: 10,
      currentLevel: 1,
      buildings: [],
      upgrades: []
    )

    // Save
    try persistenceService.save(gameState: gameState)

    // Verify file was created
    XCTAssertTrue(FileManager.default.fileExists(atPath: testFileURL.path))
  }

  func testSaveGameState_overwritesPreviousSave() throws {
    // Save first state
    let firstState = GameState(
      sparks: 100,
      innovationPoints: 10,
      currentLevel: 1,
      buildings: [],
      upgrades: []
    )
    try persistenceService.save(gameState: firstState)

    // Save second state with different values
    let secondState = GameState(
      sparks: 500,
      innovationPoints: 25,
      currentLevel: 2,
      buildings: [],
      upgrades: []
    )
    try persistenceService.save(gameState: secondState)

    // Load and verify we get the second state
    let loadedState = try persistenceService.load()
    guard let loadedState = loadedState else {
      XCTFail("loadedState should not be nil")
      return
    }
    XCTAssertEqual(loadedState.sparks, 500, accuracy: 0.001)
    XCTAssertEqual(loadedState.currentLevel, 2)
  }

  func testLoadGameState_withEmptyBuildingsAndUpgrades() throws {
    // Create state with no buildings or upgrades
    let gameState = GameState(
      sparks: 999.99,
      innovationPoints: 111.11,
      currentLevel: 5,
      buildings: [],
      upgrades: []
    )

    try persistenceService.save(gameState: gameState)
    let loadedState = try persistenceService.load()

    guard let loadedState = loadedState else {
      XCTFail("loadedState should not be nil")
      return
    }
    XCTAssertEqual(loadedState.sparks, 999.99, accuracy: 0.001)
    XCTAssertEqual(loadedState.buildings.count, 0)
    XCTAssertEqual(loadedState.upgrades.count, 0)
  }

  func testGameStateCreation_fromFactoryMethod() {
    // Test the factory method for creating GameState from game components
    let buildingId = UUID()
    let upgradeId = UUID()

    let buildings = [
      Building(
        id: buildingId,
        name: "Test Building",
        description: "Test",
        baseCost: 100,
        baseSparksProduction: 5,
        baseInnovationProduction: 1,
        unlockLevel: 1,
        count: 7,
      ),
    ]

    let upgrades = [
      Upgrade(
        id: upgradeId,
        name: "Test Upgrade",
        description: "Test",
        cost: 200,
        unlockLevel: 2,
        isPurchased: false,
        effectType: .productionMultiplier,
        effectValue: 1.5,
        targetBuildingName: nil
      ),
    ]

    let gameState = GameState.from(
      sparks: 500,
      innovationPoints: 50,
      currentLevel: 3,
      buildings: buildings,
      upgrades: upgrades
    )

    XCTAssertEqual(gameState.sparks, 500, accuracy: 0.001)
    XCTAssertEqual(gameState.innovationPoints, 50, accuracy: 0.001)
    XCTAssertEqual(gameState.currentLevel, 3)
    XCTAssertEqual(gameState.buildings.count, 1)
    XCTAssertEqual(gameState.buildings[0].id, buildingId)
    XCTAssertEqual(gameState.buildings[0].count, 7)
    XCTAssertEqual(gameState.upgrades.count, 1)
  }
}
