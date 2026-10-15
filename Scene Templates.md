# Resonance Clash — Scene Templates v1.0 (Screenplay Format)

**2026-10-11 · Intake interview output for Don's toolchain.**
Grammar: theater/stage, not engine. Each scene lists LOCATION, LIGHTING, SOUND, CAST (data-bound actors), ACTION (stage directions), and TRIGGERS (what fires it). Don's SceneDirector plays these from data.

**Global palette:** obsidian base, neon accents. Faction neons — Awakened blue/white · Loopbound purple/obsidian · Architects gold/brown · Flame ember-orange/red-black. First color is primary.

---

## SCENE 1 — Versus Intro
**LOCATION:** Void stage, black.
**LIGHTING:** Two sigils ignite left and right in faction neons.
**SOUND:** Low drone; each faction's motif whispers in as its sigil appears.
**CAST:** Sigil actors (bound to Match.Player[1].Faction, Match.Player[2].Faction).
**ACTION:**
- Sigil of faction A ignites stage-left; tagline text fades in beneath it.
- Sigil of faction B ignites stage-right; tagline beneath it.
- Hold ~3s. Skippable on tap.
**TRIGGER:** UC-01 step 1.

## SCENE 2 — Match Opening
**LOCATION:** The chromosome arena, overhead camera. Two lanes (Veiled left, Field right) crossing at the Center Node.
**LIGHTING:** Obsidian field; lane edges traced in faint neutral light; Center Node shimmers white, unclaimed.
**SOUND:** Drone rises; faction motifs layer under it.
**CAST:** Arena, CenterNode actor, both Anchors (one per end), Player hands (5 cards each, face-up to owner).
**ACTION:**
- Camera settles overhead. Node shimmers.
- Hands fan below the arena; Resonance bars glow in faction colors, filling.
- Timer: 3:00.
**TRIGGER:** UC-01 step 2.

## SCENE 3 — Card Deployment
**LOCATION:** Target lane, drop point.
**LIGHTING:** Local flare in faction neon at the tear.
**SOUND:** Rip + shimmer (the veil tearing).
**CAST:** Card actor (bound to Player[1].Card[n]), Unit actor (bound on spawn).
**ACTION:**
- On release, the card BURNS — flame consumes it in under a second.
- A vertical tear rips open in the faction's neon, like a portal through reality.
- The unit steps/floats/charges through within 1s. Tear seals behind it.
**TRIGGER:** UC-02.

## SCENE 4 — Conversion
**LOCATION:** The converting unit, wherever it stands.
**LIGHTING:** Unit's aura flickers; old color drains downward like liquid light; new color rises from the ground.
**SOUND:** A single tuning-fork strike, pure and cold. Then a low detuned wobble as the unit vibrates between frequencies.
**CAST:** Unit actor; faint after-image actor in the old faction color.
**ACTION:**
- Unit SHUDDERS — rapid vibration, caught between two resonances.
- Old neon drains down and out; new neon rises up through the model.
- After-image in the old color lingers, fading across the 15s — a visible countdown of the borrowed allegiance.
- On expiry: the unit dissolves (no death burst — it was never truly theirs).
**TRIGGER:** UC-04.

## SCENE 5 — Ascension
**LOCATION:** The ascending unit.
**LIGHTING:** A vertical pillar of faction-neon light fires skyward from the unit. A billboarded eye-sigil ignites above it, always facing camera.
**SOUND:** Rising chime, resolving on a clear tone.
**CAST:** Unit actor; eye-sigil billboard.
**ACTION:**
- Pillar erupts; sigil opens like a third eye.
- Unit's neon intensifies permanently. It cannot be converted thereafter.
- Pillar collapses after ~2s; sigil remains as a small crown-marker.
**TRIGGER:** UC-05.

## SCENE 6 — Hero Deployment
**LOCATION:** Whole arena.
**LIGHTING:** The field washes to black-and-white. The hero's faction neon is the ONLY color in frame.
**SOUND:** All audio cuts to silence for half a beat. Then a single deep impact.
**CAST:** Hero actor (bound to Player[1].HeroCard).
**ACTION:**
- B&W wash (~1.5–2s max). Short cutscene: the hero revealed in full color against the monochrome field — the Ultra Instinct beat.
- Hero lands; shockwave ring in faction neon.
- Center Node PULSES in the hero's color — the field acknowledging the arrival.
- Color slams back; battle resumes.
**TRIGGER:** UC-06.

## SCENE 7 — Victory
**LOCATION:** Whole arena.
**LIGHTING:** Loser's faction color DRAINS from the arena like water. Winner's neon FLOODS in. Graphics shift toward the winner's field representation (faction-themed environment).
**SOUND:** Loser's motif dies; winner's motif swells.
**CAST:** Losing Anchor actor; arena.
**ACTION:**
- The enemy ANCHOR SHATTERS — crystalline fracture, shards hanging a beat before falling. (Not a building collapse. Ever.)
- Winner's color washes the chromosome; the node burns in the winner's neon.
**TRIGGER:** UC-07.

## SCENE 8 — Defeat
**LOCATION:** Whole arena.
**LIGHTING/SOUND/ACTION:** Identical choreography to SCENE 7, from the losing side. Player's color drains; enemy floods; player's anchor shatters. Legible, not humiliating.
**TRIGGER:** UC-08.

## SCENE 9 — Mythic Forge (Lobby)
**LOCATION:** A vast dark forge. Floating anvils, rivers of slow fire, card plinths.
**LIGHTING:** Obsidian dark; forge-fire provides the key light. Ambience shifts to the selected faction's neon.
**SOUND:** Deep forge rumble; faction motif faint underneath.
**CAST:** Forge actor; faction sigils (4); deck plinth; collection gallery; scroll rack.
**ACTION:**
- Player selects faction → forge ambience shifts to that neon (UC-13).
- Deck builder on the central plinth: 9–10 cards arranged; validation glow when legal (UC-12).
- Collection gallery along the walls; scrolls racked, waiting (UC-10).
**TRIGGER:** App launch / return from match.

## SCENE 10 — Scroll Opening
**LOCATION:** Mythic Forge, center.
**LIGHTING:** Forge fire is the only light. It FLARES — and the flame color is the rarity reveal: dim blue-gray (common), bright blue (rare), purple (epic), white-gold (legendary).
**SOUND:** Scroll unfurling (parchment); fire roar on the flare; anvil-strike on a new unit.
**CAST:** Scroll actor; card actor (materializing).
**ACTION:**
- Scroll floats from the rack, unfurls mid-air.
- Fire flares in the rarity color — the dopamine beat lands BEFORE the card is seen.
- Card materializes from the flame, back-first, then flips to reveal the unit.
- New unit: anvil-strike flash + ring. Duplicate: card melts into embers that flow into the owned card (level-up).
**TRIGGER:** UC-10.
