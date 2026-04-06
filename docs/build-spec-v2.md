# Echo Wars Build Spec v2 — Working Summary

_Source reference: `EchoWars_Build_Spec_v2.docx`_

## Project target
Godot 4 build spec for **Echo Wars: Resonance Clash**, focused on the mobile prototype and including the newer Q-RRG gameplay enhancements discussed after the first build spec pass.

## Core additions in v2
### Layer 3 update — Ascend synergy
- Units that survive long enough to Ascend do not just gain more HP and damage.
- Their movement/personality values evolve at the same time.
- This is meant to reinforce faction identity through motion, not just through stat inflation.

### Layer 4 updates — three Q-RRG enhancements
#### 4.A Conversion ripple / resonance scar
- A conversion event should create a local field disturbance.
- Nearby units subtly curve around the scar for a short time.
- Goal: make conversion feel spatial and magical, not only ownership-based.

#### 4.B Veil Lane soft field bias
- The Veil Lane gets a soft standing bias in the scalar field.
- Units with stronger directness tend to favor their home lane without being hard-locked.
- Goal: preserve flavor without making the map feel rigged.

#### 4.C Debug field overlay / god mode
- A live scalar-field heightmap overlay for balance and iteration.
- Lets the team see why units chose a path and whether the field is behaving as intended.
- Essential for tuning lane bias, scars, and personality changes.

## Mobile-first implementation priorities
1. Project shell and match loop
2. Card hand and touch deployment flow
3. Unit spawn, pathing, combat, and death
4. Minimal field logic pass
5. AI pass and balance tooling

## Practical design intent
- Build the mobile version as a readable card battler first.
- Use Q-RRG internally for motion identity and battlefield feel.
- Keep player-facing language fantasy/tactical, not engine-facing.
- Preserve faction movement personality as the major differentiator.

## Suggested repo follow-up
- Mirror code snippets from the source doc into actual Godot script files once the scene tree is in place.
- Maintain player-facing terminology separately from internal field-logic terminology.
