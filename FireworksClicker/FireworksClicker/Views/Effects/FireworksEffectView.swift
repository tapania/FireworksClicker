import SwiftUI

struct Particle: Identifiable {
  let id = UUID()
  var positionX: Double
  var positionY: Double
  var velocityX: Double
  var velocityY: Double
  var color: Color
  var size: Double
  var life: Double  // 1.0 to 0.0
  var decay: Double
}

class ParticleSystem: ObservableObject {
  @Published var particles: [Particle] = []

  // Configuration
  let gravity: Double = 200.0  // Pixels per second^2

  func update(deltaTime: Double) {
    // Update existing particles
    particles = particles.compactMap { particle in
      var updatedParticle = particle
      updatedParticle.positionX += updatedParticle.velocityX * deltaTime
      updatedParticle.positionY += updatedParticle.velocityY * deltaTime
      updatedParticle.velocityY += gravity * deltaTime  // Gravity
      updatedParticle.life -= updatedParticle.decay * deltaTime

      if updatedParticle.life <= 0 {
        return nil
      }
      return updatedParticle
    }
  }

  func explode(at point: CGPoint, color: Color = .yellow, count: Int = 20) {
    for _ in 0..<count {
      let angle = Double.random(in: 0...(2 * .pi))
      let speed = Double.random(in: 50...250)

      let velocityX = cos(angle) * speed
      let velocityY = sin(angle) * speed

      let particle = Particle(
        positionX: point.x,
        positionY: point.y,
        velocityX: velocityX,
        velocityY: velocityY,
        color: color,
        size: Double.random(in: 2...6),
        life: 1.0,
        decay: Double.random(in: 0.5...1.5)
      )
      particles.append(particle)
    }
  }
}

struct FireworksEffectView: View {
  @ObservedObject var system: ParticleSystem

  var body: some View {
    TimelineView(.animation) { timeline in
      Canvas { context, _ in
        // We handle update in a separate tick or here, but Canvas is for drawing.
        // Ideally, logic update happens in an .onChange or similar, but for strict 60fps loop
        // inside TimelineView is tricky for state updates.
        // Better pattern for SwiftUI particles:

        for particle in system.particles {
          let rect = CGRect(
            x: particle.positionX - particle.size / 2,
            y: particle.positionY - particle.size / 2,
            width: particle.size,
            height: particle.size
          )

          var pContext = context
          pContext.opacity = particle.life
          pContext.fill(
            Path(ellipseIn: rect),
            with: .color(particle.color)
          )
        }
      }
      .onChange(of: timeline.date) {
        // Assume ~60fps, calculate delta properly if needed
        // For simple visual, 0.016 is fine or track last date
        system.update(deltaTime: 0.016)
      }
    }
    .allowsHitTesting(false)  // Let clicks pass through
  }
}
