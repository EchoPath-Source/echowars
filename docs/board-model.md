# Echo Wars Board Model

This note clarifies the intended battlefield structure for the mobile prototype and should be treated as a design-level correction to any earlier placeholder three-column logic.

## Core battlefield structure

Echo Wars is **not** intended to be a generic three-lane battler.

The intended board model is:
- **Veil Lane**
- **Field Lane**
- **Center Node** (contested objective)

## Meaning of each space

### Veil Lane
- One of the two active approach lanes.
- Carries the softer, more mystical / hidden-side bias in the field model.
- Can support faction-specific path preference, especially for units with stronger directness or home-lane bias.

### Field Lane
- The second active approach lane.
- Functions as the more exposed / direct tactical lane.
- Should contrast with the Veil Lane in feel, pathing bias, and tactical pressure, without being hard-rigged.

### Center Node
- The Center Node is **not** a normal third lane.
- It is a contested objective space between the two sides.
- Both teams pressure and fight over it.
- It should eventually drive crown pressure, conversion momentum, or other match-state consequences.

## Prototype implication

Any current deployment code that maps the battlefield as left / center / right columns should be treated as a temporary prototype stub only.

That placeholder logic is acceptable for early UI and hand testing, but it does **not** represent the intended final board rules.

## Implementation guidance

### Current acceptable placeholder
- Simple screen-space deployment rules may temporarily return values like:
  - Veil
  - Center
  - Field
- This is only for Layer 2 hand/deployment scaffolding.

### Intended real implementation
- Units are deployed into one of the two real lanes:
  - Veil Lane
  - Field Lane
- The Center Node is a battlefield objective, not a normal deployment lane in the same sense.
- LaneManager, spawn anchors, and board targeting should evolve toward:
  - two-lane movement pressure
  - contested center control
  - objective-driven match flow

## Design intent

The board should feel like:
- two active lines of pressure
- one sacred / strategic point of contest in the middle
- not three equivalent traffic lanes

This preserves the intended Echo Wars identity and should override any accidental drift toward a generic three-lane battler.
