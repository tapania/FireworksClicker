# Innovation Point Upgrades (Research Lab)

These upgrades are purchased with **Innovation Points (IP)** and provide permanent bonuses. Unlike level progression, upgrades enhance existing mechanics rather than unlocking new content.

---

## Implementation Overview

### Upgrade Effect Types

The game supports four distinct effect types that modify core gameplay:

| Effect Type | Code Identifier | Description | Stacking |
| :--- | :--- | :--- | :--- |
| **Building Cost Reduction** | `buildingCostMultiplier` | Reduces Spark cost for all buildings | Multiplicative |
| **Passive Production Bonus** | `passiveProductionMultiplier` | Increases all Sparks/second | Multiplicative |
| **Click Value Bonus** | `clickValueMultiplier` | Increases Sparks per tap | Multiplicative |
| **Click PPS Scaling** | `clickPPSPercent` | Adds % of passive income to clicks | Additive |
| **Auto-Click** | `autoClicksPerSecond` | Automatic clicks per second | Additive |

### GameManager Integration

```swift
// Add these properties to GameManager:
@Published var buildingCostMultiplier: Double = 1.0      // Lower = cheaper (0.9 = 10% off)
@Published var passiveProductionMultiplier: Double = 1.0 // Higher = more production
@Published var clickValueMultiplier: Double = 1.0        // Higher = more per click
@Published var clickPPSPercent: Double = 0.0             // % of PPS added to click
@Published var autoClicksPerSecond: Double = 0.0         // Auto-clicks

// Modified methods:
func click() {
    let baseClick = 1.0 * clickValueMultiplier
    let ppsBonus = totalSparksPerSecond() * clickPPSPercent
    sparks += baseClick + ppsBonus
}

func calculateBuildingCost(building: Building) -> Double {
    return building.currentCost() * buildingCostMultiplier
}

func tick() {
    // Passive production with multiplier
    let sparksGen = buildings.reduce(0) { $0 + $1.totalSparksPerSecond() } * passiveProductionMultiplier
    sparks += sparksGen

    // Auto-clicks
    if autoClicksPerSecond > 0 {
        for _ in 0..<Int(autoClicksPerSecond) {
            click()
        }
    }
}
```

---

## Tier Unlock Analysis

Upgrades unlock at specific levels. Here's how tier unlocks align with progression:

| Tier | Unlock Level | Level Cost | When Player Has Access | Design Rationale |
| :---: | :---: | ---: | :--- | :--- |
| 1 | 2 | 100 IP | Early game (~5 min) | First meaningful IP spending choice |
| 1.5 | 3 | 500 IP | Early-mid (~15 min) | Bridge gap, reward continued play |
| 2 | 5 | 10,000 IP | Mid game (~1-2 hours) | Significant power spike before long grind |
| 2.5 | 6 | 50,000 IP | Mid-late (~3-5 hours) | Maintain engagement during slower phase |
| 3 | 8 | 1,000,000 IP | Late game (~1-2 days) | Major rewards for dedicated players |
| 3.5 | 9 | 5,000,000 IP | End game (~3-5 days) | Final power boosts |

---

## Tier 1: Operations Optimization
*Unlocks at Level 2 (100 IP to reach)*

Entry-level upgrades that introduce the Research Lab system. Costs are balanced to be achievable shortly after reaching Level 2.

| Upgrade Name | Cost (IP) | Effect | Effect Value | Flavor Text |
| :--- | ---: | :--- | :--- | :--- |
| **Bulk Buying** | 50 | Building cost reduction | -5% | "Buying in quantity saves pennies." |
| **Safety Inspector** | 75 | Passive Spark production | +10% | "Fewer accidental explosions." |
| **Flyer Campaign** | 100 | Click value bonus | +10% | "Tell the neighbors!" |

**Tier 1 Totals:**
- Total Cost: **225 IP**
- Cumulative Effects: -5% building cost, +10% passive, +10% click value

---

## Tier 1.5: Local Expansion
*Unlocks at Level 3 (500 IP to reach)*

Bridge tier to maintain engagement between Levels 3-5.

| Upgrade Name | Cost (IP) | Effect | Effect Value | Flavor Text |
| :--- | ---: | :--- | :--- | :--- |
| **Wholesale Account** | 200 | Building cost reduction | -5% | "Preferred customer discount." |
| **Night Shift** | 300 | Passive Spark production | +15% | "Double the shifts, double the sparks." |
| **Sparkler Spinner** | 400 | Click value bonus | +15% | "A little flair goes a long way." |

**Tier 1.5 Totals:**
- Total Cost: **900 IP**
- Cumulative Effects (with Tier 1): -9.75% building cost, +26.5% passive, +26.5% click value

---

## Tier 2: Chemical Engineering
*Unlocks at Level 5 (10,000 IP to reach)*

Significant upgrades representing a leap in pyrotechnic science. Players should have accumulated substantial IP by this point.

| Upgrade Name | Cost (IP) | Effect | Effect Value | Flavor Text |
| :--- | ---: | :--- | :--- | :--- |
| **Sulfur Synthesis** | 2,000 | Building cost reduction | -10% | "Homemade chemical compounds." |
| **Neon Compounds** | 3,500 | Passive Spark production | +25% | "Brighter colors attract crowds." |
| **Auto-Loader** | 5,000 | Click adds % of PPS | +1% PPS to click | "Save your fingers." |
| **Precision Timing** | 7,500 | Click value bonus | +25% | "Every millisecond counts." |

**Tier 2 Totals:**
- Total Cost: **18,000 IP**
- Cumulative Effects (with previous): -18.78% building cost, +58.13% passive, +58.13% click, +1% PPS to click

---

## Tier 2.5: Advanced Systems
*Unlocks at Level 6 (50,000 IP to reach)*

Bridge tier for the long grind between Levels 6-8. These upgrades make the wait more bearable.

| Upgrade Name | Cost (IP) | Effect | Effect Value | Flavor Text |
| :--- | ---: | :--- | :--- | :--- |
| **Supply Chain Mastery** | 15,000 | Building cost reduction | -10% | "Just-in-time delivery." |
| **Parallel Processing** | 25,000 | Passive Spark production | +30% | "Multiple launch pads." |
| **Crowd Favorite** | 35,000 | Click value bonus | +30% | "They came to see YOU." |

**Tier 2.5 Totals:**
- Total Cost: **75,000 IP**
- Cumulative Effects (with previous): -26.9% building cost, +105.6% passive, +105.6% click, +1% PPS to click

---

## Tier 3: Quantum Pyrotechnics
*Unlocks at Level 8 (1,000,000 IP to reach)*

Late-game power upgrades. These represent mastery of physics-defying technology.

| Upgrade Name | Cost (IP) | Effect | Effect Value | Flavor Text |
| :--- | ---: | :--- | :--- | :--- |
| **Matter Conversion** | 200,000 | Building cost reduction | -15% | "Turn trash into treasure." |
| **Time Dilation** | 350,000 | Passive Spark production | +50% | "More booms per second." |
| **Quantum Entanglement** | 500,000 | Click adds % of PPS | +2% PPS to click | "Touch one, affect many." |
| **Neural Link** | 750,000 | Auto-click | 5 clicks/sec | "Think it, launch it." |

**Tier 3 Totals:**
- Total Cost: **1,800,000 IP**
- Cumulative Effects (with previous): -37.87% building cost, +208.4% passive, +105.6% click, +3% PPS to click, 5 auto-clicks/sec

---

## Tier 3.5: Reality Manipulation
*Unlocks at Level 9 (5,000,000 IP to reach)*

Final tier for dedicated players approaching endgame content.

| Upgrade Name | Cost (IP) | Effect | Effect Value | Flavor Text |
| :--- | ---: | :--- | :--- | :--- |
| **Dimensional Sourcing** | 1,000,000 | Building cost reduction | -15% | "Import from cheaper realities." |
| **Temporal Echo** | 2,000,000 | Passive Spark production | +75% | "Yesterday's fireworks, today's sparks." |
| **Reality Tap** | 3,000,000 | Click adds % of PPS | +3% PPS to click | "Each tap ripples through dimensions." |
| **Hive Mind** | 4,500,000 | Auto-click | +10 clicks/sec | "A thousand hands, one purpose." |

**Tier 3.5 Totals:**
- Total Cost: **10,500,000 IP**
- Cumulative Effects (with all previous): -47.19% building cost, +439.7% passive, +105.6% click, +6% PPS to click, 15 auto-clicks/sec

---

## Complete Upgrade Summary

### All Upgrades by Cost

| # | Upgrade Name | Tier | Cost (IP) | Running Total | Effect |
| :---: | :--- | :---: | ---: | ---: | :--- |
| 1 | Bulk Buying | 1 | 50 | 50 | -5% building cost |
| 2 | Safety Inspector | 1 | 75 | 125 | +10% passive |
| 3 | Flyer Campaign | 1 | 100 | 225 | +10% click |
| 4 | Wholesale Account | 1.5 | 200 | 425 | -5% building cost |
| 5 | Night Shift | 1.5 | 300 | 725 | +15% passive |
| 6 | Sparkler Spinner | 1.5 | 400 | 1,125 | +15% click |
| 7 | Sulfur Synthesis | 2 | 2,000 | 3,125 | -10% building cost |
| 8 | Neon Compounds | 2 | 3,500 | 6,625 | +25% passive |
| 9 | Auto-Loader | 2 | 5,000 | 11,625 | +1% PPS to click |
| 10 | Precision Timing | 2 | 7,500 | 19,125 | +25% click |
| 11 | Supply Chain Mastery | 2.5 | 15,000 | 34,125 | -10% building cost |
| 12 | Parallel Processing | 2.5 | 25,000 | 59,125 | +30% passive |
| 13 | Crowd Favorite | 2.5 | 35,000 | 94,125 | +30% click |
| 14 | Matter Conversion | 3 | 200,000 | 294,125 | -15% building cost |
| 15 | Time Dilation | 3 | 350,000 | 644,125 | +50% passive |
| 16 | Quantum Entanglement | 3 | 500,000 | 1,144,125 | +2% PPS to click |
| 17 | Neural Link | 3 | 750,000 | 1,894,125 | 5 auto-clicks/sec |
| 18 | Dimensional Sourcing | 3.5 | 1,000,000 | 2,894,125 | -15% building cost |
| 19 | Temporal Echo | 3.5 | 2,000,000 | 4,894,125 | +75% passive |
| 20 | Reality Tap | 3.5 | 3,000,000 | 7,894,125 | +3% PPS to click |
| 21 | Hive Mind | 3.5 | 4,500,000 | 12,394,125 | +10 auto-clicks/sec |

**Grand Total: 12,394,125 IP** to purchase all upgrades

---

### Cumulative Effect Progression

| After Tier | Building Cost | Passive Bonus | Click Bonus | PPS to Click | Auto-Clicks |
| :--- | ---: | ---: | ---: | ---: | ---: |
| Tier 1 | -5.00% | +10.0% | +10.0% | 0% | 0/sec |
| Tier 1.5 | -9.75% | +26.5% | +26.5% | 0% | 0/sec |
| Tier 2 | -18.78% | +58.1% | +58.1% | 1% | 0/sec |
| Tier 2.5 | -26.90% | +105.6% | +105.6% | 1% | 0/sec |
| Tier 3 | -37.87% | +208.4% | +105.6% | 3% | 5/sec |
| Tier 3.5 | -47.19% | +439.7% | +105.6% | 6% | 15/sec |

*Note: Building cost reductions stack multiplicatively (0.95 * 0.95 * 0.90 * ...). Production bonuses also stack multiplicatively.*

---

## Balance Analysis

### Upgrade Impact at Key Milestones

| Milestone | Base PPS | With Upgrades | Improvement | Notes |
| :--- | ---: | ---: | ---: | :--- |
| 5x Firecracker Bundle | 10 Sparks/s | 12.65 Sparks/s | +26.5% | Tier 1.5 complete |
| First Computerized Sequencer | 500 Sparks/s | 1,028 Sparks/s | +105.6% | Tier 2.5 complete |
| First Moon Base Launcher | 60,000 Sparks/s | 184,920 Sparks/s | +208.4% | Tier 3 complete |

### Click Value Scaling

With 15 auto-clicks/sec and 6% PPS bonus at endgame:

| Passive Income | Click Value | Auto-Click Income | Total Effective |
| ---: | ---: | ---: | ---: |
| 1,000 Sparks/s | 2.06 + 60 = 62.06 | 930.9/s | +93% effective |
| 100,000 Sparks/s | 2.06 + 6,000 = 6,002 | 90,030/s | +90% effective |
| 1,000,000 Sparks/s | 2.06 + 60,000 = 60,002 | 900,030/s | +90% effective |

**Design Note:** Auto-click with PPS scaling provides approximately 90% additional effective income at endgame, making it a powerful but not game-breaking bonus.

### Cost Efficiency Rankings

Ranked by value-per-IP-spent:

1. **Safety Inspector** (Tier 1) - 0.133% passive per IP
2. **Bulk Buying** (Tier 1) - 0.100% cost reduction per IP
3. **Flyer Campaign** (Tier 1) - 0.100% click per IP
4. **Night Shift** (Tier 1.5) - 0.050% passive per IP
5. **Neon Compounds** (Tier 2) - 0.0071% passive per IP

Early upgrades are intentionally the most efficient to reward players for engaging with the system.

---

## Developer Implementation Checklist

### 1. Update GameModels.swift

```swift
enum UpgradeEffectType: String, Codable {
    case buildingCostMultiplier
    case passiveProductionMultiplier
    case clickValueMultiplier
    case clickPPSPercent
    case autoClicksPerSecond
}

struct UpgradeEffect: Codable {
    let type: UpgradeEffectType
    let value: Double  // e.g., 0.95 for -5% cost, 1.10 for +10% production
}

struct Upgrade: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let flavorText: String
    let cost: Double
    let unlockLevel: Int
    let tier: Double  // 1, 1.5, 2, 2.5, 3, 3.5
    let effect: UpgradeEffect
    var isPurchased: Bool
}
```

### 2. Add Multiplier Properties to GameManager

```swift
// Computed from purchased upgrades
var buildingCostMultiplier: Double {
    upgrades.filter { $0.isPurchased && $0.effect.type == .buildingCostMultiplier }
        .reduce(1.0) { $0 * $1.effect.value }
}

var passiveProductionMultiplier: Double {
    upgrades.filter { $0.isPurchased && $0.effect.type == .passiveProductionMultiplier }
        .reduce(1.0) { $0 * $1.effect.value }
}

// Similar for other effect types...
```

### 3. Modify Core Game Methods

- `buyBuilding()`: Apply `buildingCostMultiplier` to cost calculation
- `tick()`: Apply `passiveProductionMultiplier` to Sparks generation
- `click()`: Apply `clickValueMultiplier` and add `clickPPSPercent * totalPPS`
- Add auto-click logic to game loop

### 4. Create Upgrade Data

Initialize the `upgrades` array in `setupUpgrades()` with all 21 upgrades defined above.

### 5. UI Requirements

- Research Lab view showing available upgrades by tier
- Locked indicator for upgrades from higher tiers
- Purchase confirmation with effect preview
- Purchased upgrade indicators

---

## Future Considerations

### Prestige Integration
When prestige mechanics are added, consider:
- Upgrade persistence across prestiges (always keep)
- Prestige-exclusive upgrade tiers
- Upgrade cost scaling based on prestige count

### Building-Specific Upgrades
Future tiers could include upgrades that boost specific buildings:
- "Backyard Expertise" - +100% Backyard Amateur production
- "Drone Optimization" - -25% Drone Swarm cost

### Achievement Unlocks
Some upgrades could unlock via achievements rather than purchase:
- "Speed Demon" - 1,000 clicks in one session unlocks +5% click bonus
- "Patient Investor" - 1 hour idle unlocks +10% passive bonus
