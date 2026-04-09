# Echo Wars Arena Convergence Addendum

This addendum clarifies the intended battlefield geometry for the mobile prototype.

## Core image

The Echo Wars board should not feel like three parallel roads.

It should feel more like:
- two curved approach strands
- converging into a central ritual / resonance zone
- then peeling forward again under pressure

A useful visual metaphor is:
- a rounded X
- or a DNA-like convergence shape without a full ladder of crossbars

This means the center is not just a third straight lane.
It is the place where both sides naturally meet, clash, and redirect.

## Design truth

The battlefield has:
- **Veil Lane**
- **Field Lane**
- **Center Node** as a shared convergence and control area

The Center Node is:
- open from match start
- a circular contested area
- a field objective, not a normal lane rail
- the place where routing pressure from both sides can overlap

## Practical implementation guidance

### What should stay for now
For the prototype, it is still acceptable to use:
- three deployable horizontal screen regions
- `VEIL`, `CENTER_NODE`, and `FIELD` in code

This keeps touch controls readable.

### What should change conceptually
The center channel should not be treated as a full third lane equal to the others.

Instead:
- Veil and Field are the two true side-lane deployments
- Center Node is a capture / contest area
- pathing should gradually bias units toward the center convergence rather than treat all three paths as parallel columns

## Immediate code implications

### Layer 1 / LaneManager
- Keep `CENTER_NODE` in the enum
- Keep center-node coordinates and capture signal
- Do **not** think of the center as a normal third lane target forever
- Future route helpers should support curved convergence toward center

### Layer 2 / Card deploy
- Temporary three-zone deploy UI is acceptable
- Future refinement may restrict direct center deployment or make center deployment card-specific

### Layer 4 / Q-RRG field
- This is where the real shape should emerge
- scalar ridges should bend movement toward the center node region
- units should appear to converge and braid, not march in three rigid columns

### Layer 5+ / Unit behavior
- units should route through or near center as a macro objective
- later unit types may:
  - prefer lane loyalty
  - dive center aggressively
  - bypass center under special rules

## Recommended prototype rule

For mobile v1:
- keep center node active from match start
- allow the board to read as Veil / Center / Field for touch targeting
- interpret the center as a contested zone, not a third equal lane
- let Q-RRG and later routing layers create the true convergence shape over time

## Summary

Use this rule going forward:

**Echo Wars mobile is best implemented as two side lanes feeding a central node, even if the early prototype temporarily exposes three deploy regions. The final battlefield should read as convergence, not parallel traffic.**
