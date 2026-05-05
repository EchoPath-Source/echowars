# Echo Wars — Layer 2 Handoff to Layer 3

## Status

Layer 2 is now functionally complete enough to proceed into Layer 3.

The current prototype runs in Godot 4.6 Android/mobile editor with:

- match scene loading
- portrait arena camera framing
- HUD timer and crown labels visible
- starter deck preload from `arena.gd`
- four starter cards visible in the hand
- card input interaction working
- card drag following pointer/touch
- card release calling the deploy path
- null `unit_scene` warnings expected and non-fatal until Layer 3

GitHub remains the source of truth. Godot should be used mainly for scene wiring, exported resources, autoload checks, and playtesting.

## Confirmed Design Correction

Echo Wars is not a generic three-lane battler.

The mobile arena model is:

- **Veil Lane**
- **Field Lane**
- **Center Node**

The implementation may temporarily expose three deploy regions:

- `VEIL`
- `CENTER_NODE`
- `FIELD`

But the Center Node is not a normal third lane. It is a contested convergence/control zone.

The intended battlefield feel is closer to:

- a rounded X
- two side pressures bending toward a central ritual node
- a DNA-like convergence shape without extra ladder strands
- convergence, not parallel traffic

Relevant docs:

- `docs/board-model.md`
- `docs/center-node-correction.md`
- `docs/arena-convergence-addendum.md`

## Layer 2 Files and Current Meaning

### `arena.tscn`

Current responsibilities:

- root match scene
- contains arena anchors
- contains `Camera2D` centered on the 720x1920 board
- contains `matchhud` CanvasLayer
- contains `CardHand` under `matchhud/HUDRoot`

The camera is intended to frame the portrait arena:

- position: `Vector2(360, 960)`
- HUD remains fixed through `CanvasLayer`

### `scripts/arena/arena.gd`

Current responsibilities:

- starts the match
- preloads the four starter cards
- calls `CardManager.load_deck(STARTER_DECK)`

This file is intentionally minimal until Layer 3.

### `scripts/arena/lane_manager.gd`

Current responsibilities:

- owns lane constants and center-node geometry
- exposes lane enum with:
  - `VEIL`
  - `CENTER_NODE`
  - `FIELD`
- provides spawn and macro route helpers
- defines Center Node position/radius
- supports future center capture signal logic

Important: keep the Center Node as a control/convergence zone, not a normal third lane.

### `scripts/autoloads/resonance_manager.gd`

Current responsibilities:

- maintains resonance pool
- regenerates while match is active or overtime
- supports `can_spend(amount)`
- supports `spend(amount)`
- emits `resonance_changed`
- supports future double regen state

### `scripts/autoloads/card_manager.gd`

Current responsibilities:

- deck / hand / discard cycle
- hand size of 4
- emits `hand_updated`
- spends resonance before play
- calls `_spawn_card`

Layer 3 note:

`_spawn_card()` currently warns if `unit_scene` is null. This is expected. Layer 3 should create unit scenes and wire card `unit_scene` references.

### `scripts/data/card_data.gd`

Current responsibilities:

- Resource class for cards
- card identity
- faction
- type
- resonance cost
- stats
- future `unit_scene`
- Q-RRG movement personality values

### `data/cards/*.tres`

Starter cards currently exist:

- `awakened_wandbearer.tres`
- `loopbound_echo_leech.tres`
- `architects_collapse_scribe.tres`
- `forgotten_flame_flamebearer.tres`

Layer 3 should assign valid `unit_scene` references when BaseUnit scenes exist.

### `scenes/ui/card_hand.tscn`

Current responsibilities:

- bottom-screen hand container
- uses `scripts/ui/card_hand.gd`
- exported `card_ui_scene` is wired to `res://scenes/ui/card_ui.tscn`

### `scripts/ui/card_hand.gd`

Current responsibilities:

- listens for `CardManager.hand_updated`
- rebuilds visible hand
- handles touch/mouse drag behavior
- releases card into deploy helper
- calls `CardManager.play_card(drag_origin_index, lane, screen_pos)`
- maps deploy zones:
  - left = Veil
  - center = Center Node zone
  - right = Field

Important: center wording must remain Center Node zone, not generic center lane.

### `scenes/ui/card_ui.tscn`

Current responsibilities:

- visual card body
- cost label
- card name label
- faction color strip

### `scripts/ui/card_ui.gd`

Current responsibilities:

- displays card cost and short name
- sets faction color
- receives card press input
- emits `drag_started`
- supports touch and mouse/editor input

### `scripts/ui/match_hud.gd`

Current responsibilities:

- reads HUD labels from actual scene tree
- updates timer
- updates crown labels
- shows win screen on match end
- optional future resonance bar support

## Current Known Acceptable Warnings

- `unit_scene` missing on cards is acceptable until Layer 3.
- AuraManager and ConversionManager placeholders are acceptable.
- Layer 3 will replace warnings with actual unit spawning.

## Avoid Regressions

Do not:

- reintroduce root duplicate `Lane manager.gd`
- revert `arena.gd` starter deck preload
- remove `card_ui_scene` assignment from `card_hand.tscn`
- rename `CENTER_NODE` to `CENTER`
- treat center as a normal third lane
- start full combat before BaseUnit is defined
- overbuild aura/conversion systems during the first Layer 3 pass

## Layer 3 Goal

Layer 3 should create the first playable unit loop while staying minimal.

Target:

- define `BaseUnit`
- create at least one simple unit scene
- assign card `unit_scene` references
- allow playing a card to spawn a visible unit
- unit moves along a simple macro route:
  1. spawn position
  2. Center Node region
  3. opposing anchor / king direction
- unit ownership/team is tracked
- unit does not need full combat polish yet

Layer 3 should prove:

- card deploy spends resonance
- hand refills
- card spawns a unit
- spawned unit moves
- the Center Node is positioned and available as a route/control objective

## Suggested Layer 3 File Plan

Add or update only what is needed.

Suggested new files:

- `scripts/units/base_unit.gd`
- `scenes/units/base_unit.tscn`
- optionally `scenes/units/test_unit.tscn`

Suggested updates:

- `scripts/autoloads/card_manager.gd`
- `data/cards/*.tres`
- possibly `scripts/arena/lane_manager.gd`
- possibly `arena.tscn` if a test unit scene must be assigned manually

## Suggested `BaseUnit` Responsibilities

Initial minimal BaseUnit:

- `is_player_owned: bool`
- `lane: int`
- `card_data: CardData`
- `hp`
- `damage`
- `speed`
- macro route points
- route index
- `initialize(card: CardData, is_player: bool, lane: int, route: Array[Vector2])`
- `_physics_process(delta)` or `_process(delta)` movement toward route point

Keep combat shallow for first pass. Movement and spawn are the priority.

## Suggested CardManager Layer 3 Update

`CardManager._spawn_card(card, lane, pos)` should:

- instantiate `card.unit_scene`
- add it to current scene
- get route from LaneManager if available
- initialize unit with card, ownership, lane, and route
- fallback gracefully if route helper is unavailable

For now, player-owned can default to `true` because enemy AI is not implemented yet.

## Suggested Acceptance Criteria for Layer 3 First Pass

- Project opens in Godot 4.6
- Main scene runs
- Timer and crowns still work
- Four cards still appear
- Drag still works
- Releasing a card spends resonance
- A visible test unit spawns
- The unit moves toward/through the Center Node region
- No fatal red errors on launch
- Missing advanced combat/aura/conversion behavior is acceptable

## Recommended Codex Prompt

Use this in the next Codex session:

```text
You are continuing Echo Wars Layer 3 in the private repo EchoPath-Source/echowars.

Layer 2 is functionally complete. Read docs/layer2_handoff_to_layer3.md first.

Goal: implement the smallest safe Layer 3 unit-spawn/movement loop. Do not overbuild combat. Do not implement full aura/conversion systems yet.

Preserve the confirmed arena design:
- Veil Lane
- Field Lane
- Center Node as contested convergence/control zone

The Center Node is not a normal third lane. It may exist as CENTER_NODE in code, but comments and behavior should treat it as a Center Node zone.

Tasks:
1. Inspect current repo state.
2. Add a minimal BaseUnit script and scene.
3. Update CardManager spawn logic so playing a card can instantiate a unit_scene.
4. Assign starter cards to a test unit scene or create minimal per-card unit scenes only if necessary.
5. Route spawned units from their deploy/spawn position toward the Center Node region, then toward the opposing anchor/king direction.
6. Preserve existing Layer 2 card hand behavior.
7. No full combat system yet.

Acceptance criteria:
- Scene runs.
- Four cards appear.
- Drag/release card still works.
- Releasing card spends resonance.
- A visible unit spawns.
- Unit moves along a simple route involving the Center Node.
- Null unit_scene warnings should be eliminated for the starter cards.
- No fatal red errors.

Use small commits. Preferred commit messages:
- "Layer 3: add base unit scaffold"
- "Layer 3: spawn units from cards"
- "Layer 3: route units through center node"

Summarize files changed, why, manual Godot wiring needed, and next steps.
```

## Layer 2 Closure Statement

Layer 2 is considered complete when the following is observed in Godot:

- HUD visible
- timer/crowns update
- cards visible
- cards draggable
- card release calls deploy flow
- no fatal runtime errors

Layer 3 begins with unit spawning and movement.
