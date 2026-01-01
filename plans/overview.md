# Project Overview: Fireworks Clicker

## Game Concept

**Fireworks Clicker** is an incremental idle game where players evolve from a backyard pyrotechnics enthusiast to a cosmic engineer. Players tap to earn Sparks, purchase buildings for passive income, and unlock progressively grander firework displays across 10 levels.

## Game Scale

| Aspect | Count | Details |
| :--- | :---: | :--- |
| Buildings | 11 | Backyard Amateur through Reality Rift |
| Levels | 10 | Each unlocks new buildings and visual themes |
| Upgrades | 21 | Across 6 tiers (1, 1.5, 2, 2.5, 3, 3.5) |
| Currencies | 2 | Sparks (primary), Innovation Points (secondary) |

## Core Loop

1. **Tap** to launch fireworks and earn Sparks (1 per tap)
2. **Buy Buildings** that passively generate Sparks and Innovation Points each second
3. **Spend Innovation Points** to unlock the next Level and purchase upgrades
4. **Progress** through 10 levels, from small backyard pops to cosmic nebulas

## Technical Stack

| Aspect | Choice |
| :--- | :--- |
| Language | Swift 5+ |
| Platform | iOS 17+ |
| UI Framework | Pure SwiftUI (no SpriteKit) |
| Architecture | MVVM with Combine |
| Game Loop | Timer-based, 1-second tick |

## Key Files

| File | Purpose |
| :--- | :--- |
| `MainGameView.swift` | Main game interface with clicker button and building shop |
| `GameManager.swift` | Game state, tick loop, and business logic |
| `GameModels.swift` | Data structures for Building, Upgrade, Resource |
| `FireworksEffectView.swift` | Canvas-based particle system |

## Implementation Status

### Completed
- [x] Core game loop (click, earn, buy)
- [x] Dual-resource economy (Sparks & Innovation Points)
- [x] 11 buildings with 1.15x cost scaling formula
- [x] Particle effects system (pure SwiftUI Canvas)
- [x] Theme system and asset infrastructure

### In Progress / Planned
- [ ] Persistence (save/load game state)
- [ ] Upgrades system (21 upgrades defined, not yet implemented)
- [ ] Level unlock UI and progression gating
- [ ] Audio and haptic feedback

## Related Documents

For detailed specifications, see:

- **[setup.md](setup.md)** - Project structure, component details, and implementation notes
- **[architecture_and_structure.md](architecture_and_structure.md)** - MVVM diagrams, data flow, file layout with status markers
- **[game-mechanics.md](game-mechanics.md)** - Tick system, cost formula, and gameplay loops
- **[progression/level_definitions.md](progression/level_definitions.md)** - Complete building stats and level unlock costs
- **[progression/upgrades.md](progression/upgrades.md)** - All 21 upgrades with implementation guidance
