# Setup Plan: Fireworks Clicker

## Project Overview

Fireworks Clicker is an incremental (idle) game where players tap to generate "Sparks" currency, purchase buildings for passive production, and unlock upgrades to multiply their output. The game features a dual-currency system and a progression system spanning 10 levels.

## Project Structure

- **Language**: Swift 5+
- **Platforms**: iOS 17+
- **Interface**: Pure SwiftUI (no SpriteKit)
- **Architecture**: MVVM with Combine

```
FireworksClicker/
├── FireworksClicker.xcodeproj
└── FireworksClicker/
    ├── App/
    │   └── FireworksClickerApp.swift       # App entry point
    ├── Models/
    │   └── Game/
    │       └── GameModels.swift            # Data structures
    ├── ViewModels/
    │   └── GameManager.swift               # Game state & logic
    └── Views/
        ├── Screens/
        │   └── MainGameView.swift          # Main game interface
        ├── Effects/
        │   └── FireworksEffectView.swift   # Particle system
        └── DesignSystem/
            ├── Theme.swift                 # Color definitions
            └── AssetProvider.swift         # Icons & colors for resources/buildings
```

## Core Components

### 1. Data Models (`GameModels.swift`)

#### ResourceType
An enum representing the two currency types:
- `sparks` - Primary currency earned from clicking and buildings
- `innovationPoints` - Secondary currency for advanced upgrades

#### Building
Represents purchasable production units:
- **Properties**: `id`, `name`, `description`, `baseCost`, `baseSparksProduction`, `baseInnovationProduction`, `unlockLevel`, `count`
- **Methods**:
  - `currentCost() -> Double`: Calculates cost using formula `baseCost * pow(1.15, count)`
  - `totalSparksPerSecond() -> Double`: Returns `baseSparksProduction * count`
  - `totalInnovationPerSecond() -> Double`: Returns `baseInnovationProduction * count`

#### Upgrade
Represents one-time purchases that modify game mechanics:
- **Properties**: `id`, `name`, `description`, `cost`, `unlockLevel`, `isPurchased`

### 2. Game State Management (`GameManager.swift`)

An `ObservableObject` class that manages all game state:

#### Published Properties
- `sparks: Double` - Current Sparks balance
- `innovationPoints: Double` - Current Innovation Points balance
- `currentLevel: Int` - Player's progression level (1-10)
- `buildings: [Building]` - All available buildings
- `upgrades: [Upgrade]` - All available upgrades

#### Game Loop
Uses Combine's `Timer.publish` to create a 1-second tick:
```swift
Timer.publish(every: 1.0, on: .main, in: .common)
    .autoconnect()
    .sink { [weak self] _ in self?.tick() }
```

#### Core Methods
- `click()` - Awards base Sparks (currently 1) when player taps
- `tick()` - Runs each second to calculate and add passive income from buildings
- `buyBuilding(buildingId:)` - Handles building purchase logic
- `setupBuildings()` - Initializes the 11 building types with their configurations

### 3. Main Game View (`MainGameView.swift`)

A SwiftUI view with a `ZStack` layout:

#### Layer Structure
1. **Background**: Dark theme (`Color.Theme.background`)
2. **Effects Layer**: `FireworksEffectView` for particle animations (zIndex: 1)
3. **UI Layer**: Main interface (zIndex: 2)

#### UI Components
- **Header**: Game title
- **Resource Display**: `ResourceView` components showing Sparks and Innovation Points
- **Click Button**: Large circular button that triggers `gameManager.click()` and spawns particles
- **Buildings List**: Scrollable list of `BuildingRow` components for purchasing buildings

#### Helper Views
- `ResourceView` - Displays a currency type with icon, label, and formatted amount
- `BuildingRow` - Shows building info with purchase button, disabled state when unaffordable

### 4. Particle System (`FireworksEffectView.swift`)

A pure SwiftUI particle system (no SpriteKit):

#### Particle Model
```swift
struct Particle: Identifiable {
    var x, y: Double        // Position
    var vx, vy: Double      // Velocity
    var color: Color
    var size: Double
    var life: Double        // 1.0 to 0.0
    var decay: Double       // Life reduction rate
}
```

#### ParticleSystem Class
- `particles: [Particle]` - Active particles
- `gravity: Double = 200.0` - Downward acceleration
- `update(deltaTime:)` - Updates positions, applies gravity, removes dead particles
- `explode(at:color:count:)` - Spawns particles in random directions from a point

#### Rendering
Uses SwiftUI's `TimelineView(.animation)` with `Canvas` for 60fps rendering:
- Particles drawn as circles with opacity based on `life`
- `allowsHitTesting(false)` ensures clicks pass through to game UI

### 5. Design System

#### Theme (`Theme.swift`)
Defines app-wide colors via `Color.Theme`:
- `background` - Black
- `panel` - Semi-transparent gray
- `text` - White
- `secondaryText` - Gray
- `sparks` - Yellow
- `innovation` - Cyan
- `forLevel(_:)` - Returns level-specific accent colors

#### AssetProvider (`AssetProvider.swift`)
Maps resources and buildings to icons/colors:
- `icon(for: ResourceType)` - Returns SF Symbol name for currency
- `color(for: ResourceType)` - Returns currency color
- `icon(forBuilding:)` - Returns building-specific icon
- `color(forBuilding:)` - Returns building-specific theme color

## Building Progression (Levels 1-10)

| Level | Building | Base Cost | Sparks/sec | Innovation/sec |
|-------|----------|-----------|------------|----------------|
| 1 | Backyard Amateur | 10 | 1 | 0.0 |
| 1 | Firecracker Bundle | 50 | 2 | 0.1 |
| 2 | Roman Candle Battery | 100 | 5 | 0.5 |
| 3 | Mortar Tube | 500 | 25 | 2.0 |
| 4 | Aerial Shell Rack | 2,500 | 100 | 5.0 |
| 5 | Computerized Sequencer | 10,000 | 500 | 15.0 |
| 6 | Drone Swarm | 50,000 | 2,500 | 40.0 |
| 7 | High-Altitude Balloon | 250,000 | 12,000 | 100.0 |
| 8 | Moon Base Launcher | 1,000,000 | 60,000 | 250.0 |
| 9 | Orbital Cannon | 5,000,000 | 300,000 | 700.0 |
| 10 | Reality Rift | 25,000,000 | 1,000,000 | 2,000.0 |

## Features To Implement

### Persistence (`Persistence.swift`)
- Save game state to UserDefaults or file storage
- Properties to persist: `sparks`, `innovationPoints`, `currentLevel`, building counts, purchased upgrades
- Load on app launch, save on state changes and app background

### Upgrades System
- Implement upgrade effects (click multipliers, production bonuses)
- Create upgrade UI (shop sheet or dedicated view)
- Track `isPurchased` state in GameManager

### Level Progression
- Define unlock thresholds for levels 2-10
- Filter buildings list by `unlockLevel <= currentLevel`
- Show level-up notifications

### Audio & Haptics (Optional for V1)
- Haptic feedback on tap
- Sound effects for clicks, purchases, level-ups

## Assets Needed

### Required
- **App Icon**: Firework-themed icon in all required sizes
- **Building Icons**: Custom SF Symbols or image assets for each building

### Optional
- **Particle Textures**: Currently using circles; could add stars, sparks
- **Sound Effects**: Pop/explosion sounds, purchase confirmation
- **Background Music**: Ambient or upbeat loop

## Technical Notes

### Number Formatting
The app uses a helper function to display large numbers:
- Under 1,000: Show as integer
- 1,000 - 999,999: Show as "X.XK"
- 1,000,000+: Show as "X.XXM"

### Cost Scaling Formula
Building costs increase by 15% per owned unit: `baseCost * 1.15^count`

### Performance Considerations
- Particle system uses Canvas for efficient rendering
- Timer runs on main thread at 1-second intervals
- Consider optimizing for very high particle counts
