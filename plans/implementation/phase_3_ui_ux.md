# Phase 3: UI/UX & Interaction

**Goal**: Visualizing the new systems.

## Task 3A: Shop & Research UI
**Dependencies**: Phase 2

- [ ] Create `ShopView`:
    - Segmented Control: [Buildings] | [Research]
- [ ] Component: `BuildingRowView`:
    - Show Icon (from assets), Name, Description.
    - Buy Button with Cost (Sparks). Disable if cannot afford.
- [ ] Component: `UpgradeRowView`:
    - Show Name, Effect Description.
    - Buy Button with Cost (IP). Disable if cannot afford or already bought.
- [ ] Integrate into `MainGameView`:
    - Show Shop below the "Clicker" area.

## Task 3B: Level Unlock Feedback
**Dependencies**: Task 2C

- [ ] Unlocking a level should not just happen silently.
- [ ] Add `GameManager.showLevelUpModal` state.
- [ ] Create `LevelUpView` modal:
    - "Level X Unlocked!"
    - Show rewards (new building unlocked).
    - Dismiss button to continue.

## Task 3C: Audio & Haptics
**Dependencies**: None (Can be parallel)

- [ ] Create `AudioService` (can use `AVAudioPlayer`).
- [ ] Add sounds for:
    - Click (Pop/Firework sound).
    - Purchase (Cash register/Coin).
    - Level Up (Fanfare).
- [ ] Add Haptics (`UIImpactFeedbackGenerator`).
    - Light impact on Click.
    - Medium impact on Purchase.
    - Heavy/Notification impact on Level Up.

## Acceptance Criteria
- [ ] UI clearly separates Buildings vs Upgrades.
- [ ] Level Up event is celebratory.
- [ ] App feels responsive with Audio/Haptics.
