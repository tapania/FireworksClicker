# File Structure & Architecture Plan

## Architectural Pattern: MVVM + Services

We use **MVVM (Model-View-ViewModel)** for UI logic, separated from **Services** for business logic and data persistence.

```
┌─────────────────────────────────────────────────────────────────┐
│                         MVVM Data Flow                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────┐    User Action     ┌─────────────────┐            │
│   │  View   │ ─────────────────> │   ViewModel     │            │
│   │         │                    │  (GameManager)  │            │
│   │         │ <───────────────── │                 │            │
│   └─────────┘   @Published       └────────┬────────┘            │
│        │         State Update             │                     │
│        │                                  │                     │
│        │                                  │ Reads/Writes        │
│        │                                  ▼                     │
│        │                         ┌─────────────────┐            │
│        │                         │     Model       │            │
│        │                         │  (GameModels)   │            │
│        └─────────────────────────│                 │            │
│            Displays Model Data   └─────────────────┘            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Component Relationships

```
FireworksClickerApp (Entry Point)
         │
         ▼
    MainGameView
         │
         ├── @StateObject: GameManager (ViewModel)
         │        │
         │        ├── @Published sparks: Double
         │        ├── @Published innovationPoints: Double
         │        ├── @Published buildings: [Building]
         │        ├── @Published upgrades: [Upgrade]
         │        │
         │        ├── tick()      ← Timer (1s interval)
         │        ├── click()     ← User tap action
         │        └── buyBuilding() ← Purchase action
         │
         ├── @StateObject: ParticleSystem
         │        │
         │        └── explode() ← Triggered on click
         │
         └── Child Views
              ├── ResourceView (inline, displays sparks/innovation)
              ├── BuildingRow (inline, per-building purchase UI)
              └── FireworksEffectView (particle rendering layer)
```

---

## Directory Layout

> Legend: `[EXISTS]` = Implemented | `[PLANNED]` = Future work

```text
FireworksClicker/
├── FireworksClicker.xcodeproj/      [EXISTS]
└── FireworksClicker/
    ├── App/
    │   ├── FireworksClickerApp.swift    [EXISTS]  # Entry point, launches MainGameView
    │   └── Constants.swift              [PLANNED] # Global constants (layout metrics, magic numbers)
    │
    ├── Models/
    │   ├── Game/
    │   │   └── GameModels.swift         [EXISTS]  # ResourceType, Resource, Building, Upgrade structs
    │   │   # Note: All models consolidated in one file. Consider splitting if complexity grows:
    │   │   #   - Resource.swift         [PLANNED]
    │   │   #   - Building.swift         [PLANNED]
    │   │   #   - Upgrade.swift          [PLANNED]
    │   │   #   - GameState.swift        [PLANNED] # Root state object for persistence
    │   └── Unlocks/
    │       └── LevelDefinition.swift    [PLANNED] # Progression data, unlock conditions
    │
    ├── ViewModels/
    │   ├── GameManager.swift            [EXISTS]  # Main game loop, state holder, timer, actions
    │   └── ShopViewModel.swift          [PLANNED] # Logic for filtering/sorting shop items
    │
    ├── Services/
    │   ├── PersistenceService.swift     [PLANNED] # Save/Load (UserDefaults or FileManager)
    │   └── AudioService.swift           [PLANNED] # SFX and Haptics
    │
    ├── Views/
    │   ├── DesignSystem/
    │   │   ├── Theme.swift              [EXISTS]  # Color.Theme extension (background, panel, text colors)
    │   │   └── AssetProvider.swift      [EXISTS]  # Maps resource types & buildings to icons/colors
    │   │
    │   ├── Components/
    │   │   ├── ResourceHeaderView.swift [PLANNED] # Extract from MainGameView
    │   │   ├── ClickerButtonView.swift  [PLANNED] # Extract from MainGameView
    │   │   └── BuildingRowView.swift    [PLANNED] # Extract from MainGameView (currently inline)
    │   │   # Note: ResourceView and BuildingRow exist inline in MainGameView.swift
    │   │
    │   ├── Screens/
    │   │   ├── MainGameView.swift       [EXISTS]  # Main game UI (includes inline ResourceView, BuildingRow)
    │   │   ├── ShopView.swift           [PLANNED] # Dedicated shop/upgrades screen
    │   │   └── SettingsView.swift       [PLANNED] # Settings, audio toggles, reset
    │   │
    │   └── Effects/
    │       └── FireworksEffectView.swift [EXISTS] # ParticleSystem class + Canvas rendering
    │
    ├── Assets.xcassets/                 [EXISTS]
    │   ├── sparks.imageset/             [EXISTS]  # Sparks currency icon
    │   ├── innovation.imageset/         [EXISTS]  # Innovation currency icon
    │   ├── icon_rocket.imageset/        [EXISTS]  # Rocket icon
    │   └── building_*.imageset/         [EXISTS]  # 11 building images
    │       # backyard_amateur, firecracker_bundle, roman_candle, mortar_tube,
    │       # aerial_shell, sequencer, drone_swarm, balloon, moon_base,
    │       # orbital_cannon, reality_rift
    │
    └── Extensions/
        ├── Double+Formatting.swift      [PLANNED] # Number formatting ("1.5M", "500K")
        └── Color+Theme.swift            [PLANNED] # Additional theme utilities
        # Note: formatNumber() currently exists inline in MainGameView.swift
```

---

## Data Flow Details

### 1. Game Loop Flow

```
Timer (1 second interval)
         │
         ▼
   GameManager.tick()
         │
         ├─► Calculate production from all buildings
         │      sparksGen = sum(building.totalSparksPerSecond())
         │      innovationGen = sum(building.totalInnovationPerSecond())
         │
         └─► Update @Published properties
                sparks += sparksGen
                innovationPoints += innovationGen
                     │
                     ▼
              SwiftUI re-renders affected views
```

### 2. User Click Flow

```
User taps LAUNCH button
         │
         ▼
   MainGameView Button action
         │
         ├─► gameManager.click()
         │        │
         │        └─► sparks += 1 (base click value)
         │
         └─► particleSystem.explode(at: center, color: .sparks)
                  │
                  └─► Creates 20 particles with random velocities
                            │
                            ▼
                  FireworksEffectView renders via Canvas
```

### 3. Building Purchase Flow

```
User taps building cost button
         │
         ▼
   BuildingRow Button action
         │
         └─► gameManager.buyBuilding(buildingId:)
                  │
                  ├─► Validate: sparks >= building.currentCost()
                  │
                  ├─► Deduct: sparks -= cost
                  │
                  └─► Increment: building.count += 1
                            │
                            ▼
                  @Published triggers UI update
                  (new cost displayed, production increases)
```

---

## Current Implementation Status

### Completed (v0.1)
- [x] Project structure (FireworksClicker)
- [x] Basic MVVM architecture
- [x] GameManager with timer-based game loop
- [x] Building and Resource models with cost scaling (1.15^count formula)
- [x] Main game view with clicker button and building list
- [x] Particle effect system (Canvas + TimelineView)
- [x] Theme system (dark background, color palette)
- [x] Asset infrastructure (11 buildings, 2 currencies)
- [x] Number formatting (inline, K/M suffixes)

### Next Steps (v0.2)
- [ ] **Persistence**: Implement PersistenceService (save on background, load on launch)
- [ ] **View Extraction**: Move ResourceView, BuildingRow to Components/
- [ ] **Upgrades System**: Implement upgrade purchasing and effects
- [ ] **Level Progression**: Add level unlock conditions and UI

### Future Enhancements (v0.3+)
- [ ] **Audio**: Sound effects on click, purchase, level-up
- [ ] **Haptics**: Feedback on actions
- [ ] **Settings Screen**: Volume controls, reset progress
- [ ] **Shop Screen**: Dedicated view for upgrades/buildings
- [ ] **Achievements**: Track milestones
- [ ] **Offline Progress**: Calculate gains while app was closed

---

## Key Architecture Decisions

### Why GameManager holds all state
The GameManager acts as a single source of truth, simplifying:
- Timer management (one timer updates all resources)
- State consistency (no sync issues between multiple ViewModels)
- Future persistence (serialize one object)

### Why inline helper views (for now)
ResourceView and BuildingRow remain in MainGameView.swift because:
- They are tightly coupled to GameManager
- Extraction adds boilerplate without current benefit
- Will extract when adding multiple screens that share components

### ParticleSystem as separate @StateObject
Keeps visual effects independent of game logic:
- Can be disabled without affecting gameplay
- Performance isolation (particle updates don't trigger game state changes)
- Reusable across different views if needed
