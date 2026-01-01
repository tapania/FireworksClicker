# Gorgeous Particle Effects System Design

To achieve a "gorgeous" and "premium" feel, we cannot just spawn circles. We need a layered physics-based system.

## 1. The Anatomy of an Explosion
A single "firework" event will actually trigger multiple **Emitters**:
1.  **The Flash**: A single large, short-lived glow at the center (0.1s duration).
2.  **The Core Burst**: High speed, high drag particles. They explode out fast but slow down quickly.
3.  **The Trails**: Particles that leave a trace behind them (or emit sub-particles).
4.  **The Sparkles**: Slow falling, twinkling dust (affected by gravity and turbulence).

## 2. Physics & Motion
Each particle needs advanced properties to feel "alive":
-   **Velocity**: Vector based movement.
-   **Damping (Air Resistance)**: Particles should start fast and slow down (`velocity *= 0.95`).
-   **Gravity**: Constant downward force.
-   **Turbulence**: Perlin-noise/Sine-wave offset to make smoke/dust drift naturally.

## 3. Visual Fidelity
We will use SwiftUI `Canvas` which supports:
-   **Additive Blending**: Essential for glowing fire effects. Overlapping particles become brighter (`BlendMode.plusLighter`).
-   **Gradient Trails**: Particles shouldn't just be solid colors. They should shift hue or fade opacity over time.
-   **Scalability**: We need to draw 500+ particles at 60 FPS.

## 4. Advanced Particle Types
| Type | Behavior | Visual |
| :--- | :--- | :--- |
| **Spark** | High gravity, bounces? | Small dot, yellow/orange |
| **Rocket** | Wobbly upward path, emits smoke | elongated shape |
| **Ring** | Expands outward uniformly | Stroked circle fading out |
| **Glitter** | High drag, oscillates opacity | Starlight shape |

## 5. Technical Implementation Details
### `Particle` Struct Update
```swift
struct Particle: Identifiable {
    var id = UUID()
    var pos: CGPoint
    var vel: CGPoint
    var color: Color
    var opacity: Double
    var scale: Double
    var life: Double // 0.0 to 1.0
    var damping: Double // 0.9 to 1.0
    var blendMode: GraphicsContext.BlendMode
}
```

### `ParticleSystem` Optimization
-   **Pre-allocation**: Reuse particle objects if possible to reduce GC pressure (Object Pool pattern).
-   **TimelineView**: Use `TimelineView(.animation)` instead of `Timer` for buttery smooth 120Hz support on ProMotion displays.

## 6. Color Palettes
Using "Oklch" or HSB for vibrant colors.
-   **Neon**: High saturation, high brightness.
-   **Pastel**: Low saturation, high brightness (Level 1).
-   **Cosmic**: Pinks, Purples, Cyans (Level 10).
