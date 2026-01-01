# Phase 1: Foundation & Reliability

**Goal**: Establish a stable, tested codebase with automated linting. This is a prerequisite for all future features.

## Tasks

### 1.1 Testing Infrastructure Setup
- [ ] Create `FireworksClickerTests` target if not fully configured.
- [ ] Ensure `GameManager` and Models are accessible (public/testable) to the test target.
- [ ] Create base `XCTestCase` class.

### 1.2 Core Logic Unit Tests
**File**: `FireworksClickerTests/GameModelTests.swift`
- [ ] Test `Building.currentCost()` formula (1.15^count).
- [ ] Test `Building.totalSparksPerSecond()`.
- [ ] Test `Usage` of Resources.

**File**: `FireworksClickerTests/GameManagerTests.swift`
- [ ] Test `click()`: Increments sparks.
- [ ] Test `tick()`: Increments resources based on buildings.
- [ ] Test `buyBuilding()`:
    - Successful purchase (deducts cost, increments count).
    - Insufficient funds (no change).
- [ ] Test Reset/Init state.

### 1.3 Linting & Formatting Enforcement
- [ ] Helper script to run `swift-format` and `swiftlint`.
- [ ] Fix any existing warnings in `Models/` and `ViewModels/`.
- [ ] Setup `pre-commit` hook or just a manual check step in the workflow.

## Acceptance Criteria
- [ ] `swift test` passes with 100% success.
- [ ] `swiftlint` reports 0 warnings (strict mode).
- [ ] Code coverage > 80% for `GameManager` and `Models`.
