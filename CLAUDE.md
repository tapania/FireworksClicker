# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
# Build the project
xcodebuild -project FireworksClicker/FireworksClicker.xcodeproj -scheme FireworksClicker -sdk iphonesimulator build

# Run on iOS Simulator
xcrun simctl boot "iPhone 15"
xcodebuild -project FireworksClicker/FireworksClicker.xcodeproj -scheme FireworksClicker -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15' build
xcrun simctl install booted build/Build/Products/Debug-iphonesimulator/FireworksClicker.app
xcrun simctl launch booted com.example.FireworksClicker

# Clean build
xcodebuild -project FireworksClicker/FireworksClicker.xcodeproj -scheme FireworksClicker clean
```

## Linting

```bash
# Format/lint (swift-format via Xcode toolchain)
xcrun swift-format lint -r FireworksClicker

# SwiftLint (install once: brew install swiftlint)
swiftlint lint --strict
```

## Testing

```bash
# Run tests on iOS Simulator
xcodebuild -project FireworksClicker/FireworksClicker.xcodeproj -scheme FireworksClicker -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15' test
```

Testing approach:
- Use XCTest unit tests for game logic in `FireworksClickerTests/` with `@testable import FireworksClicker`.
- Focus on deterministic model/view-model behavior: cost scaling, click/tick resource updates, and buy/insufficient funds paths in `GameManager`.
- Avoid UI tests unless needed; if adding them, place in `FireworksClickerUITests/`.

## Architecture

**Fireworks Clicker** - An incremental/idle game built with SwiftUI using MVVM pattern.

### Key Components

- **GameManager** (`FireworksClicker/ViewModels/GameManager.swift`): Central state holder and game loop controller. Runs a 1-second tick timer via Combine. Manages resources (Sparks, Innovation Points) and all game state.

- **GameModels** (`FireworksClicker/Models/Game/GameModels.swift`): Data structures for `Building`, `Upgrade`, and `Resource`. Buildings use exponential cost scaling: `baseCost * 1.15^count`.

- **MainGameView** (`FireworksClicker/Views/Screens/MainGameView.swift`): Primary UI. Displays resources, click button, and building shop.

### Dual-Currency Economy

1. **Sparks** - Primary currency from clicking and buildings. Used to purchase buildings.
2. **Innovation Points** - Secondary currency from buildings. Used to unlock progression levels.

### Project Structure

```
FireworksClicker/
├── App/                  # Entry point (FireworksClickerApp.swift)
├── Models/Game/          # Data structures
├── ViewModels/           # GameManager (game loop, state)
└── Views/Screens/        # SwiftUI views
```

### Planned Features (Not Yet Implemented)

- Visual effects/particle system
- Save/Load persistence
- Services layer (AudioService, PersistenceService)
- Component decomposition (ResourceHeaderView, BuildingRowView)

## Game Design Reference

See `plans/` directory for detailed specs:
- `plans/overview.md` - Game concept and status
- `plans/game-mechanics.md` - Core loop, currencies, progression
- `plans/architecture_and_structure.md` - Target file structure
- `plans/progression/` - Level definitions and upgrades
