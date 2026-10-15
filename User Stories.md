# Resonance Clash — User Stories v1.0

**2026-10-11 · Intake interview output for Don's toolchain.**
Format: As a [role], I want [goal] so that [benefit]. Acceptance criteria where the beat needs them.

---

## Match flow

**US-01 — Versus intro**
As a player, I want to see the two fighting factions with their taglines before a match starts, so that the battle feels like an event rather than a loading screen.
- Both faction sigils shown with tagline text; ~3 seconds; skippable.

**US-02 — Match opening**
As a player, I want an overhead view of the chromosome arena with the glowing center node, so that I can read both lanes and plan my opening play.
- Veiled lane and Field lane distinguishable; node shimmers neutral until first control.

**US-03 — Hand**
As a player, I want 5 cards visible below the arena with full stats on hover, so that I can evaluate plays without committing.
- Hover reveals cost, HP, DMG, ability text; unaffordable cards dimmed.

**US-04 — Deploy**
As a player, I want to drag a card onto a lane and watch it burn into a faction-colored veil-tear that the unit steps through, so that every summon feels powerful.
- Card burns on release; tear color = faction neon; unit emerges within 1s.

**US-05 — Resonance**
As a player, I want a glowing faction-colored bar under my hand showing Resonance (1/sec, max 10), so that I always know what I can afford.
- Bar pulses when a card becomes affordable.

## Signature beats

**US-06 — Conversion**
As a player, I want conversion to be unmistakable — tuning-fork strike, unit shudder, aura bleeding from one faction color to the other — so that the game's signature mechanic reads instantly.
- Old color drains downward, new color rises; faint after-image in old color fades over the 15s duration.

**US-07 — Hero deployment**
As a player, I want hero deployment to feel like an event — the field washing to black-and-white, a short cutscene, then battle resuming — so that the legendary moment lands.
- B&W beat max ~2s; hero's faction neon the only color in frame; silence half-beat before landing impact.

**US-08 — Ascension**
As a player, I want a clear visual when my unit ascends (light pillar, floating eye-sigil, rising chime), so that surviving 30 seconds feels rewarded.
- Readable at max zoom-out; no geometry change required on the model.

**US-09 — Center node**
As a player, I want the center node to glow and shimmer in the holder's faction color, so that control is readable at a glance.
- Color transitions smoothly on control change; neutral shimmer when uncontested.

## Match resolution

**US-10 — Victory**
As a player, I want victory to flood the arena in my faction color, shift the graphics to my faction's field representation, and shatter the enemy anchor, so that winning feels conclusive.
- Loser color drains first; anchor shatter (not building collapse).

**US-11 — Defeat**
As a player, I want defeat to read clearly — my color draining from the arena, my anchor shattering — so that the loss is legible even when it stings.
- Same choreography as victory, from the losing side; no humiliation beats.

## Meta (Mythic Forge)

**US-12 — Forge lobby**
As a player, I want a mythic forge space to select faction, build my 9–10 card deck, and view my collection, so that preparation feels like part of the world rather than a menu.

**US-13 — Scroll opening**
As a player, I want scroll openings to reveal rarity through the forge-fire's flame color before the card is revealed, so that the reveal has a built-in dopamine beat.
- Rarity ladder: dim blue-gray (common), bright blue (rare), purple (epic), white-gold (legendary).

**US-14 — Level up**
As a player, I want duplicate cards to melt into embers that flow into the owned card, so that leveling a unit feels like forging rather than accounting.
- New unit: anvil-strike flash and ring on reveal.
