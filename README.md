# Fireworks Clicker

An incremental/idle game built with SwiftUI for iOS. Become the world's greatest pyrotechnician by clicking to generate Sparks, building your fireworks empire, researching upgrades, and progressing through 10 levels of achievement.

## Features

- **Dual Currency System**: Earn Sparks through clicking and buildings, use Innovation Points for progression and upgrades
- **11 Buildings**: From Backyard Amateur to Reality Rift, each with unique production rates
- **10 Upgrades**: Click multipliers, production boosts, and cost reductions
- **10 Levels**: Progress from Backyard Beginner to Universal Legend
- **Audio & Haptics**: Tactile feedback for all interactions
- **Persistence**: Game state saves automatically

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Getting Started

### Build

```bash
xcodebuild -project FireworksClicker/FireworksClicker.xcodeproj -scheme FireworksClicker -sdk iphonesimulator build
```

### Run Tests

```bash
xcodebuild -project FireworksClicker/FireworksClicker.xcodeproj -scheme FireworksClicker -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16' test
```

### Lint

```bash
# SwiftLint
swiftlint lint --strict

# swift-format
xcrun swift-format lint -r FireworksClicker
```

## Architecture

The app follows the **MVVM pattern** with SwiftUI.

```
FireworksClicker/
├── App/                      # Entry point
│   └── FireworksClickerApp.swift
├── Models/Game/              # Data structures
│   ├── GameModels.swift      # Building, Upgrade, Resource types
│   ├── GameState.swift       # Saveable state structure
│   └── LevelDefinition.swift # Level definitions (1-10)
├── ViewModels/
│   └── GameManager.swift     # Central game state and logic
├── Views/
│   ├── Screens/
│   │   ├── MainGameView.swift    # Primary game screen
│   │   └── ShopView.swift        # Buildings/Research tabs
│   ├── Components/
│   │   ├── BuildingRowView.swift
│   │   ├── UpgradeRowView.swift
│   │   ├── LevelProgressBar.swift
│   │   └── LevelUpView.swift     # Level unlock celebration
│   ├── Effects/
│   │   └── FireworksEffectView.swift
│   └── DesignSystem/
│       ├── Theme.swift       # Colors and styling
│       └── AssetProvider.swift
└── Services/
    ├── PersistenceService.swift  # Save/load game state
    ├── AudioService.swift        # Sound effects
    └── HapticService.swift       # Tactile feedback
```

### Key Components

**GameManager** (`ViewModels/GameManager.swift`)
- Central `@ObservableObject` holding all game state
- Manages resources, buildings, upgrades, and level progression
- Runs 1-second tick timer for passive production
- Integrates audio and haptic feedback

**GameModels** (`Models/Game/GameModels.swift`)
- `Building`: Production units with exponential cost scaling (`baseCost * 1.15^count`)
- `Upgrade`: Permanent bonuses (click multipliers, production boosts, cost reductions)
- `Resource`: Currency types (Sparks, Innovation Points)

**LevelDefinition** (`Models/Game/LevelDefinition.swift`)
- 10 levels with increasing unlock costs
- Each level unlocks new buildings and upgrades

### Game Economy

| Currency | Source | Use |
|----------|--------|-----|
| Sparks | Clicking, Buildings | Purchase buildings |
| Innovation Points | Buildings (higher tiers) | Level progression, Upgrades |

### Upgrade Types

| Type | Effect |
|------|--------|
| `clickMultiplier` | Increases value per click |
| `productionMultiplier` | Increases all production |
| `costReduction` | Reduces building costs |

## Testing

72 unit tests covering:
- `GameModelTests`: Building cost scaling, production calculations, encoding/decoding
- `GameManagerTests`: Click mechanics, building purchases, tick updates
- `UpgradeTests`: Multiplier calculations, upgrade purchases
- `LevelProgressionTests`: Level progression logic, unlock conditions
- `PersistenceServiceTests`: Save/load functionality

## Development Notes

See `CLAUDE.md` for Claude Code-specific guidance and `plans/` for detailed design documents:
- `plans/overview.md` - Game concept
- `plans/game-mechanics.md` - Core loop and currencies
- `plans/architecture_and_structure.md` - Target structure
- `plans/progression/` - Level and upgrade definitions

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
