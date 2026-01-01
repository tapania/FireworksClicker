# Game Mechanics: Fireworks Clicker

## Core Loop

1. **Click**: User taps to launch fireworks -> Earns **1 Spark** per tap.
2. **Build**: User spends Sparks to purchase **Buildings** (Fireworks Launchers).
3. **Generate**: Buildings passively generate **Sparks** and **Innovation Points** every tick.
4. **Research**: User spends **Innovation Points** to unlock the **Next Level**.
5. **Expand**: Unlocking a level reveals new, more powerful buildings and upgrades.

### Tick System

The game runs on a 1-second tick cycle managed by `GameManager.swift`:

- **Tick Interval**: 1 second (1000ms)
- **Per Tick**: All owned buildings generate their per-second resources
- **Calculation**:
  - `Total Sparks/tick = Sum of (building.baseSparksProduction * building.count)`
  - `Total IP/tick = Sum of (building.baseInnovationProduction * building.count)`

## Currencies

| Currency | Source | Usage |
| :--- | :--- | :--- |
| **Sparks** | Tapping (1/click), Buildings (passive) | Purchasing Buildings, Click Upgrades |
| **Innovation Points (IP)** | Buildings (passive, lower volume) | Unlocking Levels, Research Upgrades |

**Note**: All currency generation is tied to the tick system or manual clicking. There are no special events currently implemented.

## Building Cost Formula

Buildings use an exponential cost scaling formula:

```
Current Cost = Base Cost * (1.15 ^ count)
```

Where `count` is the number of that building type already owned.

### Examples (Backyard Amateur, Base Cost: 10)

| Purchase # | Calculation | Cost |
| :---: | :--- | ---: |
| 1st | 10 * 1.15^0 | 10 |
| 2nd | 10 * 1.15^1 | 11.5 |
| 5th | 10 * 1.15^4 | ~17.5 |
| 10th | 10 * 1.15^9 | ~35.2 |
| 25th | 10 * 1.15^24 | ~287 |
| 50th | 10 * 1.15^49 | ~10,830 |

This 15% increase per building creates meaningful decisions about when to buy more of a cheap building versus saving for a new tier.

## Progression System: The 10 Levels

The game has 10 distinct levels. Each level unlocks new buildings with higher production rates. Players start at Level 1; higher levels are hidden until unlocked.

### Starting State (Level 1)

- **Two buildings available immediately**: Backyard Amateur and Firecracker Bundle
- **Backyard Amateur**: 10 Sparks, generates 1 Spark/s, 0 IP/s
- **Firecracker Bundle**: 50 Sparks, generates 2 Sparks/s, 0.1 IP/s

**Important**: Backyard Amateur generates 0 IP. The Firecracker Bundle is the first IP generator.

### Unlock Mechanism

To unlock Level `N+1`, the player must pay a "License Fee" in **Innovation Points**.

Unlocking a level grants:
- Access to the next Building type
- New visual theme for fireworks
- Potential passive multipliers (via upgrades)

See [Level Definitions](progression/level_definitions.md) for complete building stats and unlock costs.

## Game Loop Timing

| Event | Frequency | Handler |
| :--- | :--- | :--- |
| User Tap | On demand | `click()` - adds 1 Spark |
| Resource Generation | Every 1 second | `tick()` - calculates and adds all building production |
| Building Purchase | On demand | `buyBuilding()` - deducts cost, increments count |

The tick system ensures consistent idle income regardless of framerate or device performance.

## Engagement Hooks

### 1. Unfolding Complexity
The UI reveals features progressively:
- **Initial State**: Only the main firework tap area and basic building list visible
- **After First Building**: Production stats become more prominent
- **After Earning IP**: Research/Level unlock UI becomes visible
- **Higher Levels**: More elaborate visual effects and UI elements unlock

### 2. Visual Reward
Each level introduces new firework visuals:
- Level 1: Small white pops
- Level 5: Hearts, Stars, Smileys
- Level 10: Cosmic Nebulas / Black Holes

### 3. The Wall
Cost to unlock the next level grows exponentially:
- Level 2: 100 IP
- Level 5: 10,000 IP
- Level 10: 25,000,000 IP

This forces strategic optimization: buy cheap buildings for steady IP, or save for expensive ones with higher Spark output.

### 4. Idle vs. Active Balance
- **Active Play**: Rapid clicking for Sparks to quickly bootstrap building purchases
- **Idle Play**: Let buildings accumulate IP for the next level unlock
- **Hybrid**: Click while waiting for big purchases, idle overnight for major milestones

## Upgrades

Upgrades are purchased with Innovation Points and provide permanent bonuses. They are organized into tiers that unlock at specific levels.

See [Upgrades](progression/upgrades.md) for the complete upgrade list.

### Tier 1: Operations Optimization (Level 2)
| Upgrade | Cost | Effect |
| :--- | ---: | :--- |
| Bulk Buying | 50 IP | Building Spark costs -10% |
| Safety Inspector | 75 IP | +10% Passive Spark Gen |
| Flyer Campaign | 100 IP | +5% Click Value |

### Tier 2: Chemical Engineering (Level 5)
| Upgrade | Cost | Effect |
| :--- | ---: | :--- |
| Sulfur Synthesis | 5,000 IP | Building Spark costs -15% |
| Neon Compounds | 7,500 IP | +25% Passive Spark Gen |
| Auto-Loader | 10,000 IP | +1% of PPS added to Click |

### Tier 3: Quantum Pyrotechnics (Level 8)
| Upgrade | Cost | Effect |
| :--- | ---: | :--- |
| Matter Conversion | 500,000 IP | Building Spark costs -20% |
| Time Dilation | 750,000 IP | +50% Passive Spark Gen |
| Neural Link | 1,000,000 IP | Auto-click 10 times/sec |

## Implementation Reference

The core game loop is implemented in `GameManager.swift`:

- `click()`: Adds 1 Spark per tap
- `tick()`: Called every 1 second, sums all building production
- `buyBuilding()`: Handles purchase logic with cost formula
- `setupBuildings()`: Initializes all 11 buildings with stats from level_definitions.md
