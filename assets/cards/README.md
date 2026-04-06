# Echo Wars Card Assets

## Purpose
This folder is the home for the mobile/tabletop card UI source files and their sync notes.

## Source files currently in the working project
- `echo-wars-unit-cards.jsx`
- `echo-wars-faction-cards.jsx`

## What these files represent
### `echo-wars-unit-cards.jsx`
Working JSX source for unit card layouts, palette definitions, and SVG unit illustration components. This file is the current template source for turning unit designs into usable game/UI card presentations.

### `echo-wars-faction-cards.jsx`
Working JSX source for larger faction presentation cards and faction-level visual panels.

## Current terminology direction
Player-facing card language should avoid engine/debug phrasing.

Recommended public labels:
- `Field Signature`
- `Focus`
- `Instability`
- `Poise`
- `Weight`

Keep internal pathing/Q-RRG terminology in implementation notes, not on live player cards.

## Visual baseline note
Core card art should follow the anti-drift sheet in `docs/ART_DIRECTION_CORE_UNITS.md` so basic troops do not accidentally render as legendary units.

## Next sync step
Mirror the raw JSX files into this folder in a follow-up repo pass once source snapshots are finalized for commit.
