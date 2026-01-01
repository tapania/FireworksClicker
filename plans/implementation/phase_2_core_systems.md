# Phase 2: Core Systems Expansion

**Goal**: Implement the "missing" game mechanics defined in plans.

## Task 2A: Persistence Engine
**Dependencies**: Phase 1
**Files**: `Services/PersistenceService.swift`, `ViewModels/GameManager.swift`

- [ ] **TDD**: Write test for saving/loading `GameManager` state (resources + building counts).
- [ ] Implement `PersistenceService`:
    - Use `FileManager` (documents directory) or `UserDefaults` (if simple). JSON coding.
    - `save(GameState)`
    - `load() -> GameState?`
- [ ] Integrate into `GameManager`:
    - Load on `init`.
    - Save on `scenePhase` (backgrounding) and periodically (e.g. every 30s).
- [ ] **Verify**: Kill app, restart, data persists.

## Task 2B: Upgrades System & Multipliers
**Dependencies**: Phase 1
**Files**: `Models/Game/GameModels.swift`, `ViewModels/GameManager.swift`

- [ ] Update `Upgrade` struct:
    - Add `UpgradeEffectType` enum (costReduction, productionMultiplier, clickMultiplier).
    - Add `effectValue: Double`.
- [ ] **TDD**: Test `GameManager` multipliers:
    - `buildingCostMultiplier` reduces cost?
    - `globalProductionMultiplier` increases tick income?
- [ ] Implement `GameManager` logic:
    - Computed properties for multipliers based on `upgrades.filter { $0.isPurchased }`.
    - Apply multipliers in `currentCost`, `tick`, and `click`.
- [ ] Implement `buyUpgrade(id:)`:
    - Check cost (IP), deduct IP, mark purchased.

## Task 2C: Level Progression Architecture
**Dependencies**: Task 2B (mostly independent but related to upgrades)
**Files**: `Models/Game/LevelDefinition.swift`, `ViewModels/GameManager.swift`

- [ ] Create `LevelDefinition` struct (unlock cost, buildings unlocked).
- [ ] Implement `LevelLogic`:
    - Define constant levels data (Levels 1-10).
- [ ] **TDD**: Test Level Up:
    - Can only level up if enough IP.
    - Level up deducts IP, increments level.
- [ ] Filter `availableBuildings` based on `currentLevel`.
- [ ] Filter `availableUpgrades` based on `currentLevel`.

## Acceptance Criteria
- [ ] Game saves and loads correctly.
- [ ] Upgrades correctly modify game math (verified by tests).
- [ ] Levels restrict buildings/upgrades until unlocked.
