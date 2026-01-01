# High-Level Implementation Strategy

## Strategy Overview

The implementation will follow a **Test-Driven Development (TDD)** approach. We will prioritize establishing a solid foundation with testing and linting before expanding features.

The project is divided into **4 Phases**. Phases are generally serial, but tasks within Phase 2 and Phase 3 can be executed in parallel by different agents or sessions if needed.

## Phases

### Phase 1: Foundation & Reliability (Serial)
**Goal:** Ensure the existing codebase is robust, tested, and linted.
- Setup Test Bundle & Unit Test targets.
- Implement comprehensive tests for existing `GameManager` logic (Resources, Buildings, Costs).
- Enforce Linting (SwiftLint + swift-format).
- Refactor any untestable code.

### Phase 2: Core Systems Expansion (Parallelizable)
**Goal:** Implement the missing core mechanics (Persistence, Upgrades, Progression).
- **Task 2A: Persistence Engine**: Save/Load game state securely.
- **Task 2B: Upgrades System**: Implement the research lab, effect application (multipliers), and upgrade models.
- **Task 2C: Level Progression**: Implement unlocking logic, prerequisites, and dynamic building availability.

### Phase 3: UI/UX & Interaction (Serial after Phase 2)
**Goal:** Expose new systems to the user with a polished UI.
- **Task 3A: Enhanced Shop**: Tabbed views for Buildings/Upgrades/Research.
- **Task 3B: Feedback Systems**: Level up modals, visual cues for unlocks.
- **Task 3C: Audio & Haptics**: Integrate audio service.

### Phase 4: Polish & Balancing (Serial)
**Goal:** Final tuning and asset verification.
- Verify all assets are correctly mapped.
- Playtesting and parameter tuning.

## Asset Mapping

We will utilize the `Assets.xcassets` as follows:

**Currencies:**
- `sparks` -> `ResourceType.sparks`
- `innovation` -> `ResourceType.innovationPoints`

**Buildings:**
Mapping `Building.name` to Image Set Name:
- "Backyard Amateur" -> `building_backyard_amateur`
- "Firecracker Bundle" -> `building_firecracker_bundle`
- "Roman Candle Battery" -> `building_roman_candle`
- "Mortar Tube" -> `building_mortar_tube`
- "Aerial Shell Rack" -> `building_aerial_shell`
- "Computerized Sequencer" -> `building_sequencer`
- "Drone Swarm" -> `building_drone_swarm`
- "High-Altitude Balloon" -> `building_balloon`
- "Moon Base Launcher" -> `building_moon_base`
- "Orbital Cannon" -> `building_orbital_cannon`
- "Reality Rift" -> `building_reality_rift`

**Icons:**
- `icon_rocket` -> Launch Button / App Icon context.

## Test Strategy (TDD)
1.  **Write Test**: Create a failing test case for the new feature (e.g., "Buying upgrade reduces building cost").
2.  **Implement**: Write the minimal code to pass the test.
3.  **Refactor**: Clean up and optimize.
4.  **Lint**: Ensure no warnings.
5.  **Commit**: Mark task complete.

All phases MUST pass existing and new tests before completion.
