import UIKit

/// Service responsible for managing haptic feedback for game events
class HapticService {
  static let shared = HapticService()

  private var lightImpactGenerator: UIImpactFeedbackGenerator?
  private var mediumImpactGenerator: UIImpactFeedbackGenerator?
  private var heavyImpactGenerator: UIImpactFeedbackGenerator?
  private var notificationGenerator: UINotificationFeedbackGenerator?

  private var isEnabled: Bool = true

  private init() {
    setupGenerators()
  }

  /// Initialize and prepare all haptic feedback generators
  private func setupGenerators() {
    lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
    heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    notificationGenerator = UINotificationFeedbackGenerator()

    // Prepare generators for reduced latency
    prepareGenerators()
  }

  /// Prepare all generators for immediate use
  private func prepareGenerators() {
    lightImpactGenerator?.prepare()
    mediumImpactGenerator?.prepare()
    heavyImpactGenerator?.prepare()
    notificationGenerator?.prepare()
  }

  /// Enable or disable haptic feedback
  /// - Parameter enabled: Whether haptics should be enabled
  func setEnabled(_ enabled: Bool) {
    isEnabled = enabled
  }

  // MARK: - Impact Feedback

  /// Trigger light impact haptic feedback (for clicks and small interactions)
  func lightImpact() {
    guard isEnabled else { return }
    lightImpactGenerator?.impactOccurred()
    // Re-prepare for next use
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      self?.lightImpactGenerator?.prepare()
    }
  }

  /// Trigger medium impact haptic feedback (for purchases and significant actions)
  func mediumImpact() {
    guard isEnabled else { return }
    mediumImpactGenerator?.impactOccurred()
    // Re-prepare for next use
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      self?.mediumImpactGenerator?.prepare()
    }
  }

  /// Trigger heavy impact haptic feedback (for major events like level ups)
  func heavyImpact() {
    guard isEnabled else { return }
    heavyImpactGenerator?.impactOccurred()
    // Re-prepare for next use
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      self?.heavyImpactGenerator?.prepare()
    }
  }

  // MARK: - Notification Feedback

  /// Trigger success notification haptic feedback
  func success() {
    guard isEnabled else { return }
    notificationGenerator?.notificationOccurred(.success)
    // Re-prepare for next use
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      self?.notificationGenerator?.prepare()
    }
  }

  /// Trigger warning notification haptic feedback
  func warning() {
    guard isEnabled else { return }
    notificationGenerator?.notificationOccurred(.warning)
    // Re-prepare for next use
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      self?.notificationGenerator?.prepare()
    }
  }

  /// Trigger error notification haptic feedback
  func error() {
    guard isEnabled else { return }
    notificationGenerator?.notificationOccurred(.error)
    // Re-prepare for next use
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      self?.notificationGenerator?.prepare()
    }
  }

  // MARK: - Cleanup

  /// Clean up haptic generators
  func cleanup() {
    lightImpactGenerator = nil
    mediumImpactGenerator = nil
    heavyImpactGenerator = nil
    notificationGenerator = nil
  }

  /// Reset and re-initialize all generators
  func reset() {
    cleanup()
    setupGenerators()
  }
}
