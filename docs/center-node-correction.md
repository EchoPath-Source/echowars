# Echo Wars Center Node Correction

This document refines the battlefield model for the mobile prototype and should be used alongside `docs/board-model.md`.

## Design clarification

Echo Wars should not be treated as a generic three-lane battler.

However, for implementation purposes, the arena does use **three deployment and routing channels**:
- **Veil**
- **Center Node**
- **Field**

The important distinction is that the **Center Node is not just another ordinary lane**.
It is a contested midpoint objective and convergence path that both sides fight over.

## Recommended framing

### Design truth
- There are two side lanes: **Veil Lane** and **Field Lane**.
- There is one central contested objective: **Center Node**.

### Implementation truth
For touch deployment, lane routing, and early prototype pathing, it is acceptable and useful to model the battlefield as three deployable channels:
- `VEIL`
- `CENTER_NODE`
- `FIELD`

This keeps the control scheme readable on mobile while preserving the actual gameplay identity.

## Why this matters

If the center is treated as a normal third lane, the game drifts toward a generic lane battler.

If the center is ignored in implementation, the board loses its intended convergence logic and central contest.

The correct compromise is:
- three deployment/routing channels in code
- one of them (`CENTER_NODE`) functions as a special contested objective space

## Code guidance

### Lane enum
Prefer:

```gdscript
# Recommended naming
enum Lane { VEIL, CENTER_NODE, FIELD }
```

Use `CENTER_NODE` rather than `CENTER` so the design intent stays visible in code.

### Deploy zones
Touch deployment may temporarily map to three horizontal regions:
- left → `VEIL`
- center → `CENTER_NODE`
- right → `FIELD`

This is acceptable for the prototype.

### Pathing guidance
- Macro routing should usually bias units through the center-node region.
- Q-RRG / field logic should treat the center as a convergence space.
- Future units may override this behavior for flanking, lane loyalty, or special movement identities.

### Objective guidance
The center node should be treated as:
- a control point
- a signal-emitting objective space
- a source of field bonuses, routing pressure, or match-state effects

It should **not** be treated as a normal third tower or equivalent side-lane anchor.

## Recommended future updates

The following systems should eventually reflect this correction:
- `LaneManager`
- card deploy detection
- `QRRGField` center convergence behavior
- unit macro-routing
- arena anchor placement and objective logic

## Summary

Use this rule going forward:

**Echo Wars has three routing channels in implementation, but only two side lanes in design. The center channel is the Center Node: a contested convergence objective, not a generic third lane.**

## Follow-up note: Center Node routing / geometry

The current prototype now draws the Center Node as a foreground convergence zone and routes side pressure through it before peeling toward enemy-side pressure. This is still a small macro-route approximation, not the final Q-RRG movement solution.

Remaining issue for the next pass:
- Center Node deployment is still allowed for touch readability, but it should eventually become a special contest/capture interaction rather than a normal deploy lane.
- The current route helper uses fixed rounded-X waypoints; later field logic should replace these with smoother, personality-aware curves so units braid through or near the node instead of snapping between macro points.
- Side-lane exits currently cross from Veil pressure through Center Node toward Field-side enemy pressure, and vice versa. Validate in playtest whether this reads better than same-side exits before locking board geometry.
