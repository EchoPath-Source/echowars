# Resonance Clash — Unit Stat Sheet for Don (Code Reference) v1.0

**2026-10-11 · For: Don Gunter · Purpose: code the 24 agreed units (16 base + 8 mid-tier).**
**Status notes:** ★ = locked by Echo. ☆ = recommended value, awaiting Echo's confirm (code it — one-line change if he decides otherwise).
**No Q-RRG needed.** Every ability below is deterministic: auras, zones, on-hit, on-death, timers. The movement/pathing interface stays as specified in the implementation guide.

---

## Global rules (implement once)

- **Resonance:** 1/sec regen, max 10. Card costs 2–7.
- **Drift:** unit below 20% HP enters Drift and can be converted.
- **Conversion:** flipped unit fights for the converter for **15s** ★ (tunable per the guide), then expires. Extensions hard-cap at **9s total**, no re-extension.
- **Ascension:** any unit surviving 30s gets +20% HP and +15% damage, once. Abilities never reset the survival timer; summoned units don't inherit it.
- **Lanes:** Veil (left) and Field (right) converge on the contested Center Node. Ground zones stay in their deployed lane. Nothing deploys onto the Center Node.
- **Speeds (initial, tunable):** Slow 2 m/s · Medium 3.5 m/s · Fast 5 m/s.
- **Attack intervals (initial, tunable):** swarm/fast 0.8s · standard 1.1s · heavy/tank 1.3–1.6s.
- **Ranges (initial, tunable):** melee 1.5m · short 3m · medium 5m.

---

## Awakened Ones

**Wandbearer of Echo** (2) — 240 HP · 80 DMG · Med · melee · 1.1s · Support
Ability: Resonance Pulse — +10 HP/s regen to allies within 120px.
Code: aura tick, heal allies in radius. ☆ Allies-only vs self-heal open (roster says allies; sim modeled self too) — code allies-only, flag the toggle.

**Sigil Keeper** (3) — 320 HP · 85 DMG · Slow · melee · 1.1s · Control
Ability: Anchor Field — maintains 2 sigil plates; enemies in radius −20% speed.
Code: deployable zones, max 2, oldest replaced. Simple.

**Veil Walker** (4) — 300 HP · 120 DMG · Fast · melee · 1.0s · Flank
Ability: Veil Step — switches lanes mid-deployment.
Code: lane reassignment + repath. ☆ TIMING OPEN: deploy-window only or anytime? Needs Echo's answer — affects whether this is a deploy hook or an active button.

**Mirror Sentinel** (4) — 380 HP · 90 DMG · Slow · melee · 1.3s · Tank
Ability: Reflection — reflects 30% of incoming damage to attacker.
Code: on-damage-taken callback. Simple.

**Glyph Crafter** (5) — 680 HP · 48 DMG · Slow · short · 1.3s · Support
Ability: Living Inscription — drops a glyph at current position every 7s; allies crossing recover 4% max HP over 2s and gain 10% slow resist; max 2 glyphs, 7s each.
Code: periodic zone drop, same pattern as Sigil Keeper. Simple.

**Prism Adept** (6) — 620 HP · 85 DMG · Med · short · 1.1s · Redirection
Ability: Refraction Field — every 6s, projects a 3s field; the first projectile targeting an ally inside is negated and redirected to the nearest enemy at 70% damage.
Code: projectile interception within radius. ⚠️ NEEDS ANSWER: are attacks modeled as projectiles or instant/hitscan? If hitscan, this ability needs a redesign (e.g., damage shield instead).

---

## Loopbound

**Echo Leech** (2) — ★ 30 HP · ★ 40 DMG · Fast · melee · 0.8s · Swarm
Ability: deploys as 3 bodies; Resonance Drain −5 Resonance per hit (tunable — sim used 0.5; the roster value is devastating, start low).
Code: spawn 3 agents, shared cost attribution. Simple.

**Cycle Priest** (3) — 280 HP · 80 DMG · Med · melee · 1.1s · Recursion
Ability: False Return — on death, next card in hand −1 cost.
Code: on-death hand modifier. Simple.

**Distortion Walker** (4) — 260 HP · 110 DMG · Fast · melee · 1.0s · Flank
Ability: Fracture Step — leaves a distortion trail; passers slowed 25%.
Code: trail zones with slow. Simple.

**Anchor-Line Enforcer** (4) — 480 HP · 100 DMG · Slow · melee · 1.3s · Control
Ability: Hold the Loop — nearby enemies cannot be converted for 4s (aura).
Code: aura that suppresses the conversion state change. Simple.

**Null Chorister** (5) — 560 HP · 65 DMG · Med · short · 1.1s · Debuff
Ability: Silence Loop — 3m zone for 4s every 8s; enemy auras/channelled suppressed, −10% damage inside.
Code: periodic zone + aura-suppression hook (same hook family as Enforcer). Medium — needs the suppression interface.

**Puppet Priest** (6) — 650 HP · 60 DMG · Slow · short · 1.3s · Summon
Ability: Borrowed Motion — summons a Marionette (160 HP, 35 DMG, expires 6s) every 9s; extends nearby conversion duration +1s (cap 9s total).
Code: periodic summon + conversion-timer extension. Medium — needs the summon spawner and timer hook.

---

## Architects of Collapse

**Measure Guard** (3) — 420 HP · 95 DMG · Slow · melee · 1.3s · Defense
Ability: Formation Hold — takes −20% damage while any ally is nearby.
Code: proximity check on damage taken. Simple.

**Collapse Scribe** (4) — 350 HP · 130 DMG · Med · short · 1.1s · Control
Ability: Sequence Mark — attacks slow the target 40%, stacks 2×.
Code: on-hit debuff with stack counter. Simple. (30% is the first playtest knob if Architects feel oppressive.)

**Geometry Weaver** (4) — 580 HP · 50 DMG · Med · short · 1.3s · Control
Ability: Faultline Diagram — every 7s, marks a visible slow strip ahead (25% slow, 2s); cannot overlap the Center Node.
Code: periodic zone, same pattern as Sigil Keeper. Simple.

**Nullcaster** (5) — 420 HP · 100 DMG · Med · medium · 1.3s · Denial
Ability: Null Zone (80px) — pulsing zone; enemy spells fail for 6s.
Code: periodic zone + spell-fizzle hook (needs the spell system to check the zone). Medium — zone is simple, the hook depends on spell implementation.

**Chrono Frame** (5) — 380 HP · 120 DMG · Slow · melee · 1.6s · Timing
Ability: Interval Lock — on hit, target's next attack delayed 1.5s.
Code: on-hit attack-timer debuff. Simple. (Diminishing returns vs Fracture Engine open — currently hard-counters it 100%.)

**Fracture Engine** (7) — 1200 HP · 145 DMG · Slow · medium · 1.6s · Siege
Ability: Designed Rupture — every 8s, telegraphs a ground zone ahead; after 1.25s wind-up, 180 damage + 20% slow for 2s. Avoidable by movement; cannot hit the opposing lane.
Code: telegraph indicator + delayed AoE. Medium — needs the telegraph UI and lane check.

---

## Forgotten Flame

**Flamebearer** (3) — 280 HP · ☆ 120 DMG (140→120 pending Echo) · Fast · melee · 0.8s · Aggro
Ability: Forward Vow — charges straight, cannot be slowed, first hit 1.5×.
Code: movement lock + slow-immune flag + first-hit multiplier. Simple.

**Ashbound Votary** (3) — 200 HP · 70 DMG · Med · short · 1.1s · Sacrifice
Ability: Sacrifice Rite — drains 3 HP/s from self; allies +20% damage for 6s (aura).
Code: self DoT + damage aura. Simple.

**Cinder Knight** (4) — 380 HP · 160 DMG · Med · melee · 1.3s · Heavy
Ability: Ember Burst — 150 AoE damage on death (80px).
Code: on-death explosion. Simple.

**Pyre Walker** (4) — 320 HP · 130 DMG · Fast · melee · 1.0s · AoE
Ability: Heat Trail — leaves a burning trail dealing 30 dps to crossers.
Code: trail zones with DoT. Simple.

**Rekindler** (5) — 640 HP · 45 DMG · Med · short · 1.3s · Support
Ability: Ember Reprieve — every 7s, restores 7% max HP to the most-damaged ally in range; if an ally dies nearby, drops an ember (3s) granting the next passer +10% move speed for 2s.
Code: periodic targeted heal + drop pickup. Simple.

**Pyre Herald** (6) — 720 HP · 80 DMG · Med · melee · 1.1s · Tempo
Ability: Omen of the Pyre — ★ every 8s, 3s visible wind-up, then allies in radius +15% attack speed for 3s.
Code: telegraph + delayed buff (same pattern as Fracture Engine). Medium.

---

## Complexity summary for Don

**Simple (18):** Wandbearer, Sigil Keeper, Mirror Sentinel, Echo Leech, Cycle Priest, Distortion Walker, Anchor-Line Enforcer, Measure Guard, Collapse Scribe, Geometry Weaver, Chrono Frame, Flamebearer, Ashbound Votary, Cinder Knight, Pyre Walker, Rekindler, Glyph Crafter — all auras, zones, on-hit, on-death, or timers. No new systems.

**Medium (5):** Null Chorister + Nullcaster (zone + suppression/fizzle hooks), Puppet Priest (summon spawner), Fracture Engine + Pyre Herald (telegraph + delayed effect).

**Needs Echo's answer before coding (3):**
1. Prism Adept — projectile vs hitscan determines whether Refraction Field works as designed.
2. Veil Walker — lane-switch timing: deploy window only, or anytime via active trigger?
3. Wandbearer — regen allies-only or including self?

Nothing here requires Q-RRG or any pathing intelligence — all movement is lane-following per the implementation guide's deterministic routing.
