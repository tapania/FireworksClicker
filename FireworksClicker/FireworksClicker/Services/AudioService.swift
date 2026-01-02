import AVFoundation
import Foundation

/// Service responsible for managing audio playback for game events
class AudioService {
  static let shared = AudioService()

  private var audioPlayers: [String: AVAudioPlayer] = [:]
  private var isEnabled: Bool = true

  private init() {
    setupAudioSession()
  }

  /// Configure the audio session for playback
  private func setupAudioSession() {
    do {
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(.ambient, mode: .default)
      try audioSession.setActive(true)
    } catch {
      print("Failed to setup audio session: \(error.localizedDescription)")
    }
  }

  /// Enable or disable audio playback
  /// - Parameter enabled: Whether audio should be enabled
  func setEnabled(_ enabled: Bool) {
    isEnabled = enabled
    if !enabled {
      // Stop all currently playing sounds
      audioPlayers.values.forEach { $0.stop() }
    }
  }

  /// Play a sound effect
  /// - Parameters:
  ///   - soundName: The name of the sound file (without extension)
  ///   - volume: The playback volume (0.0 to 1.0)
  private func playSound(named soundName: String, volume: Float = 1.0) {
    guard isEnabled else { return }

    // Check if we already have a player for this sound
    if let player = audioPlayers[soundName] {
      player.volume = volume
      player.currentTime = 0
      player.play()
      return
    }

    // Try to load the sound file (support both wav and mp3 formats)
    let extensions = ["wav", "mp3", "m4a"]
    var soundURL: URL?

    for ext in extensions {
      if let url = Bundle.main.url(forResource: soundName, withExtension: ext) {
        soundURL = url
        break
      }
    }

    guard let url = soundURL else {
      // Sound file not found, use system sound as fallback
      playSystemSound(for: soundName)
      return
    }

    do {
      let player = try AVAudioPlayer(contentsOf: url)
      player.volume = volume
      player.prepareToPlay()
      audioPlayers[soundName] = player
      player.play()
    } catch {
      print("Failed to play sound \(soundName): \(error.localizedDescription)")
      playSystemSound(for: soundName)
    }
  }

  /// Fallback to system sounds when audio files are not available
  /// - Parameter soundName: The type of sound to play
  private func playSystemSound(for soundName: String) {
    // Use system sound IDs as fallback
    let soundID: SystemSoundID
    switch soundName {
    case "click":
      soundID = 1104  // Tock sound
    case "purchase":
      soundID = 1106  // SMSReceived sound
    case "levelup":
      soundID = 1016  // USSDAlert sound
    default:
      soundID = 1104
    }
    AudioServicesPlaySystemSound(soundID)
  }

  // MARK: - Public Methods

  /// Play sound effect for a click action
  func playClick() {
    playSound(named: "click", volume: 0.5)
  }

  /// Play sound effect for a purchase action
  func playPurchase() {
    playSound(named: "purchase", volume: 0.7)
  }

  /// Play sound effect for leveling up
  func playLevelUp() {
    playSound(named: "levelup", volume: 0.9)
  }

  /// Preload all sound files for better performance
  func preloadSounds() {
    let soundNames = ["click", "purchase", "levelup"]
    for soundName in soundNames where audioPlayers[soundName] == nil {
      // Attempt to create players for all sounds
      let extensions = ["wav", "mp3", "m4a"]
      for ext in extensions {
        if let url = Bundle.main.url(forResource: soundName, withExtension: ext) {
          if let player = try? AVAudioPlayer(contentsOf: url) {
            player.prepareToPlay()
            audioPlayers[soundName] = player
            break
          }
        }
      }
    }
  }

  /// Clean up audio resources
  func cleanup() {
    audioPlayers.values.forEach { $0.stop() }
    audioPlayers.removeAll()
  }
}
