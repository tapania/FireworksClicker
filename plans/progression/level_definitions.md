# Level Progression Definitions

This document defines the core game progression for Fireworks Clicker. Buildings are the primary source of passive income, unlocked as the player advances through levels.

## Buildings Reference

All buildings available in the game, with their stats as implemented in `GameManager.swift`:

| Building | Unlock Level | Base Cost | Spark/s | IP/s | Cost Multiplier |
| :--- | :---: | ---: | ---: | ---: | :---: |
| Backyard Amateur | 1 | 10 | 1 | 0.0 | 1.15x |
| Firecracker Bundle | 1 | 50 | 2 | 0.1 | 1.15x |
| Roman Candle Battery | 2 | 100 | 5 | 0.5 | 1.15x |
| Mortar Tube | 3 | 500 | 25 | 2.0 | 1.15x |
| Aerial Shell Rack | 4 | 2,500 | 100 | 5.0 | 1.15x |
| Computerized Sequencer | 5 | 10,000 | 500 | 15.0 | 1.15x |
| Drone Swarm | 6 | 50,000 | 2,500 | 40.0 | 1.15x |
| High-Altitude Balloon | 7 | 250,000 | 12,000 | 100.0 | 1.15x |
| Moon Base Launcher | 8 | 1,000,000 | 60,000 | 250.0 | 1.15x |
| Orbital Cannon | 9 | 5,000,000 | 300,000 | 700.0 | 1.15x |
| Reality Rift | 10 | 25,000,000 | 1,000,000 | 2,000.0 | 1.15x |

## Level Progression

Levels are unlocked by spending Innovation Points (IP). Each level grants access to new buildings and visual themes.

| Level | Title | Description | Unlocks Building(s) | Research Cost (IP) | Est. Time to Unlock | Visual Theme |
| :---: | :--- | :--- | :--- | ---: | ---: | :--- |
| **1** | **Backyard Amateur** | Just you and a lighter in the garden. | Backyard Amateur, Firecracker Bundle | 0 (Start) | - | Small white pops |
| **2** | **Neighborhood Menace** | You've got a permit. Sort of. | Roman Candle Battery | 100 IP | ~3-5 min | Red & Green sparks |
| **3** | **Town Celebrator** | The mayor actually hired you. | Mortar Tube | 500 IP | ~10-15 min | Blue & Gold bursts |
| **4** | **City Pyrotechnician** | A professional setup on a barge. | Aerial Shell Rack | 2,500 IP | ~30-45 min | Chrysalis / Willows |
| **5** | **National Holiday** | The whole country is watching. | Computerized Sequencer | 10,000 IP | ~1-2 hours | Hearts, Stars, Smileys |
| **6** | **Global Event** | Olympics opening ceremonies level. | Drone Swarm | 50,000 IP | ~3-5 hours | Synchronized Shapes |
| **7** | **Atmospheric Artist** | Launching into the stratosphere. | High-Altitude Balloon | 250,000 IP | ~8-12 hours | Massive Ring Explosions |
| **8** | **Lunar Festival** | Low gravity means bigger booms. | Moon Base Launcher | 1,000,000 IP | ~1-2 days | Low-G Slow Motion |
| **9** | **Solar System Show** | Visible from Mars. | Orbital Cannon | 5,000,000 IP | ~3-5 days | Planetary Rings |
| **10** | **Big Bang Creator** | Rewriting the laws of physics. | Reality Rift | 25,000,000 IP | ~1-2 weeks | Cosmic Nebulas / Black Holes |

## Unlock Flow

### Starting the Game (Level 1)
- Player begins with 0 Sparks and 0 IP
- Two buildings are immediately available: **Backyard Amateur** and **Firecracker Bundle**
- Click the firework to generate 1 Spark per tap
- First goal: Save 10 Sparks to buy the first Backyard Amateur

### Early Game Strategy (Levels 1-3)
1. **Backyard Amateur** generates Sparks but no IP - use it to bootstrap income
2. **Firecracker Bundle** is the first IP generator (0.1 IP/s per building)
3. Players must balance Spark income vs. IP generation
4. Reaching Level 2 requires 100 IP, which takes approximately 1,000 seconds (16 min) with a single Firecracker Bundle

### Mid Game (Levels 4-6)
- Buildings become significantly more expensive but generate proportionally more resources
- IP generation accelerates, allowing faster level progression
- Visual effects become more elaborate

### Late Game (Levels 7-10)
- Idle income dominates over clicking
- Strategic building purchases matter more
- Prestige mechanics (if implemented) become relevant

## Building Balancing Logic

### Cost Formula
```
Current Cost = Base Cost * (1.15 ^ Amount Owned)
```

Example for Backyard Amateur:
- 1st purchase: 10 Sparks
- 2nd purchase: 11.5 Sparks
- 10th purchase: ~40 Sparks
- 50th purchase: ~10,830 Sparks

### Production Formulas
```
Total Sparks/s = Base Spark Production * Count
Total IP/s = Base Innovation Production * Count
```

### Scaling Ratios

| Tier Transition | Cost Ratio | Spark/s Ratio | IP/s Ratio |
| :--- | ---: | ---: | ---: |
| Backyard Amateur -> Firecracker Bundle | 5x | 2x | N/A |
| Firecracker Bundle -> Roman Candle Battery | 2x | 2.5x | 5x |
| Roman Candle Battery -> Mortar Tube | 5x | 5x | 4x |
| Mortar Tube -> Aerial Shell Rack | 5x | 4x | 2.5x |
| Aerial Shell Rack -> Computerized Sequencer | 4x | 5x | 3x |
| Computerized Sequencer -> Drone Swarm | 5x | 5x | 2.67x |
| Drone Swarm -> High-Altitude Balloon | 5x | 4.8x | 2.5x |
| High-Altitude Balloon -> Moon Base Launcher | 4x | 5x | 2.5x |
| Moon Base Launcher -> Orbital Cannon | 5x | 5x | 2.8x |
| Orbital Cannon -> Reality Rift | 5x | 3.33x | 2.86x |

### Design Notes
- **Sparks Generation**: Primary income. Scales approximately 5x per tier.
- **Innovation Generation**: Secondary income. Scales approximately 2.5-3x per tier. This makes early buildings still relevant for "farming" IP with different strategies.
- **Cost Scaling**: Generally 4-5x between tiers, keeping new buildings aspirational but achievable.

## Time-to-Unlock Estimates

These estimates assume active play with reasonable building investments:

| Level | IP Required | Cumulative IP | Assumed IP/s at Start | Time from Previous |
| :---: | ---: | ---: | ---: | ---: |
| 1 | 0 | 0 | 0 | - |
| 2 | 100 | 100 | ~0.5 | ~3-5 min |
| 3 | 500 | 600 | ~2-3 | ~3-5 min |
| 4 | 2,500 | 3,100 | ~10-15 | ~15-20 min |
| 5 | 10,000 | 13,100 | ~30-50 | ~20-30 min |
| 6 | 50,000 | 63,100 | ~100-150 | ~1-2 hours |
| 7 | 250,000 | 313,100 | ~300-500 | ~2-4 hours |
| 8 | 1,000,000 | 1,313,100 | ~1,000-2,000 | ~6-12 hours |
| 9 | 5,000,000 | 6,313,100 | ~5,000-10,000 | ~1-2 days |
| 10 | 25,000,000 | 31,313,100 | ~20,000-50,000 | ~3-5 days |

**Note**: These are rough estimates. Actual times depend heavily on player strategy, clicking activity, and upgrade purchases.
