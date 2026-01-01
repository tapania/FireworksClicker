import Foundation

/// Service responsible for saving and loading game state to/from disk
class PersistenceService {
  private let fileURL: URL
  private let encoder: JSONEncoder
  private let decoder: JSONDecoder

  /// Initialize with default file location in documents directory
  convenience init() {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsDirectory.appendingPathComponent("game_state.json")
    self.init(fileURL: fileURL)
  }

  /// Initialize with custom file URL (useful for testing)
  init(fileURL: URL) {
    self.fileURL = fileURL
    self.encoder = JSONEncoder()
    self.decoder = JSONDecoder()

    // Configure encoder for readable output
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    encoder.dateEncodingStrategy = .iso8601

    // Configure decoder to match
    decoder.dateDecodingStrategy = .iso8601
  }

  /// Save game state to disk
  /// - Parameter gameState: The current game state to save
  /// - Throws: Encoding or file system errors
  func save(gameState: GameState) throws {
    let data = try encoder.encode(gameState)
    try data.write(to: fileURL, options: [.atomic])
  }

  /// Load game state from disk
  /// - Returns: The saved game state, or nil if no save file exists
  /// - Throws: Decoding errors if save file is corrupted
  func load() throws -> GameState? {
    // Check if file exists
    guard FileManager.default.fileExists(atPath: fileURL.path) else {
      return nil
    }

    let data = try Data(contentsOf: fileURL)
    let gameState = try decoder.decode(GameState.self, from: data)
    return gameState
  }

  /// Delete the saved game state file
  /// - Throws: File system errors
  func deleteSave() throws {
    guard FileManager.default.fileExists(atPath: fileURL.path) else {
      return
    }
    try FileManager.default.removeItem(at: fileURL)
  }

  /// Check if a save file exists
  /// - Returns: True if a save file exists, false otherwise
  func saveExists() -> Bool {
    return FileManager.default.fileExists(atPath: fileURL.path)
  }
}
