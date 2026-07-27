# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**GardenSync — A Quiet Almanac** is a square-foot garden planner for Canton, Ohio
(USDA Zone 6a). You lay out beds and containers, plant them from a drawer of 77 seed packets, then
drag a pin along a season ribbon to watch the whole year play out: dashed plans before sowing,
sprouts, full plants, gold rings when a crop is ready, sepia when it is spent. The harvest feeds
neighbours, so the agronomy — frost dates, days to harvest, companion pairs — is the part that has
to stay honest.

Live: <https://gardensync-almanac.pages.dev>

This is a ground-up rebuild of the original GardenSync planner (punk aesthetic, six workspaces,
Garden Buddy), which lives in its own repo at
<https://github.com/Samizdat-Publications/gardensync> and is deployed at
<https://gardensync-e4e.pages.dev>. **The two share no code.** The only inheritance is the plant
research: `plants.js` here was generated from the planner's `js/constants.js`, so the agronomy is
the same while every line of interface is new. The header carries a link to the other edition;
they are siblings, not rivals.

## Architecture

Four files, no build step, no framework, no bundler, no dependencies. Open `index.html` in a
browser and the app runs.

| File | Lines | What it holds |
|------|-------|---------------|
| `index.html` | ~160 | The whole page skeleton: masthead, season ribbon `<svg>`, the trifold (seed drawer / garden / almanac panel), the potting-shed row of add-plot buttons, and the calendar and help overlays. Two script tags: `plants.js` then `app.js`. |
| `style.css` | ~660 | Every style. `:root` custom properties for the paper-and-ink palette, the grain overlay, layout, and a `prefers-reduced-motion` block. |
| `app.js` | ~1,600 | All behaviour, in labelled sections: calendar → geometry & plot kinds → yields → state → occupancy & companions → templates → whisper → season ribbon → seed drawer → plot chrome → plot rendering → plot interaction → tasks → almanac panel → sharing → a picture of the garden (PNG) → the year calendar overlay → header tools → weather & frost watch → ask the almanac → the almanac's own reading → boot. The growth-window maths (`windowsOf`, `stageAt`) has no banner of its own — it closes out the geometry section. |
| `plants.js` | 3 | Generated data: `PLANTS` (77 entries) and `PLANT_BY_ID`. Treat as read-only — regenerate from the planner's `js/constants.js` rather than hand-editing. |

`docs/` is more than a picture folder: `docs/index.html` is the project landing page, and
`docs/screenshots/` holds the ten captures used by it and by the README. `deploy.sh` copies
`almanac-hero.png` in as the og:image and deliberately leaves the rest of `docs/` out of `dist/` —
the landing page is not part of the app. `proxy.py` is the dev server (shared, identical to the
planner's copy).

## The core model

```js
state.beds = [{
  id, name, w, h,        // w/h in feet; every plot is a grid of square feet
  kind,                  // key of KINDS: bed | pot | treepot | barrel | bag | window | trough
  notes, caretaker,      // field notes and a "tended by" name
  plants: [{ uid, pid, c, r }]   // pid = plant id; c/r = column/row on the square-foot grid
}]
```

- `state.harvests` is a flat list of `{date:'YYYY-MM-DD', pid, lbs}` — what actually came in.
- Persistence: `localStorage` key `gardensync-almanac-v1`, payload
  `{app, version:2, beds, harvests}`, written by a debounced `save()`. Import/export uses the same
  shape; `migrateBeds()` back-fills `kind`, `notes` and `caretaker` on older saves.
- Undo/redo snapshot **`state.beds` only** (`snapshot()` is `JSON.stringify(state.beds)`).
  Harvest entries are deliberately outside that; if you add new persistent garden data, decide
  consciously whether it belongs in the snapshot.

### Time
Everything is scheduled in day-of-year integers, from Canton's Zone 6a frost dates:

```js
const LAST_FROST  = DOY(3, 18);   // Apr 18 → day 107
const FIRST_FROST = DOY(9, 28);   // Oct 28 → day 300
```

`windowsOf(p)` turns a plant's `sowIndoors` / `directSow` / `transplantAfterFrost` offsets (in
weeks, relative to last frost) plus `daysToHarvest` into `{indoor, inBed, hStart, hEnd, wraps}`.
`stageAt(p, doy)` maps a date onto `planned | sprout | growing | harvest | rest`, which drives chip
size (`STAGE_SCALE`), colour, the gold harvest ring, and every sentence the almanac writes.

## Invariants — do not break these

**1. Fall-sown crops wrap the year.** `FALL_SOWN` records crops whose season crosses Dec 31
(currently `garlic`: sown Oct 10, pulled Jul 12). The plant library has no field for this — all of
garlic's sowing offsets are `null`, which the spring maths reads as "plant at last frost" and lands
the harvest in December. `windowsOf()` returns `wraps: true` for these, and `stageAt()` takes a
separate branch using `inSpan(a, b, x)`, which handles ranges that run backwards past the turn of
the year. Anything that reasons about `hStart`/`hEnd`/`inBed` must handle the wrapping case:
`yearStrip()` draws two bars, `gardenEvents()` phrases the sowing task as "for next summer", and
`localAnswer()` has its own paragraph for it. Adding a fall-sown crop means adding a `FALL_SOWN`
entry, not editing `plants.js`.

**2. `renderBeds()` rebuilds the DOM, so focus must be carried back.** It replaces the entire
`#beds` innerHTML and then calls `wireBeds()` to re-attach listeners — so every element reference
held across a render is stale. The keyboard handler (arrows walk a plot's plants, Home/End jump to
the ends) re-focuses `.bed-svg[data-bed="…"]` immediately after re-rendering; without that, one
arrow press drops focus to `<body>` and the garden stops being keyboard-navigable. Each plot is a
single tab stop, with Delete/Backspace removing the selection. Keep that contract intact.

**3. All dynamic markup goes through `escapeHtml()`; chat uses `textContent`.** Bed names,
caretaker names and field notes are user input and land in `innerHTML` — they must be escaped at
every interpolation site (`renderBeds`, `plantPage`, `renderAlmanac`, the drawer). Chat messages
(`addMsg`) set `.textContent`, never `innerHTML`, so a model reply can never inject markup. The
file header comment states this rule; keep it true.

**4. `setupAsk()` must degrade to the offline almanac.** The public build ships with no answering
service. `apiAlive` starts `null`; the first question is POSTed to `/api/claude/v1/messages` — with
an `x-api-key` header when `localStorage['almanac-claude-key']` is set, and no key header otherwise,
since `proxy.py` holds no key of its own and never reads `.env`. Without a key Anthropic returns an
error, so `apiAlive` flips to `false` and every later question is answered by `localAnswer()`
without another network round-trip; an empty response or a thrown fetch does the same. `localAnswer()` reads the plant
library and the actual garden — frost dates, sowing windows, companions, container suitability,
what is ready to pick, projected yield, this week's tasks — so the offline path is a real feature,
not an error message. If you touch the request, keep the fallback; if you add a question type to
the panel's copy, teach `localAnswer()` to answer it. (Note the word-boundary regex in the
container branch: a substring match on "pot" would answer questions about potatoes.)

**5. Vessels force a 1×1 footprint.** `spanOf(p)` derives a footprint from real spacing (1, 2 or 3
feet), but `plantSpan(bed, p)` returns `1` for any plot whose `KINDS` entry is `vessel: true` —
container rules, roots make do. Occupancy (`cellsFree`), neighbour distance (`footprintGap`), chip
geometry (`chipCenter`, `chipSvg`), template filling (`fillBed`) and the drag ghost all call
`plantSpan()`. Calling `spanOf()` directly inside a plot will corrupt occupancy and let plants
overlap. Vessel dimensions come from `KINDS`, not from the caller: `makeBed()` ignores the passed
`w`/`h` for vessels. Plants that genuinely resent a container (`sulksInVessel`) get a gentle
warning, not a block.

## Other things worth knowing

- **Ribbon scrubbing is rAF-coalesced.** Dragging the pin re-renders every plot; `setupRibbon()`
  coalesces pointer moves into one render per animation frame. Do not call `renderBeds()` straight
  from a `pointermove`.
- **Share links carry the whole garden in the URL hash.** `encodeGarden()` packs beds into a
  compact array and base64url-encodes it; `decodeGarden()` is the trust boundary and sanitises
  everything it reads — kind against `KINDS`, `w`/`h` clamped to 1–20, names and caretakers
  truncated, unknown plant ids dropped. Keep it defensive. On boot, a `#g=` hash replaces the
  garden but pushes an undo first, so a visitor's own garden is one Ctrl+Z away.
- **SVG `<defs>` ids are per plot** (`soil-${bed.id}`). Duplicated ids across plots would make
  every bed take the first one's gradient.
- **`savePoster()` clears selection and armed packet, re-renders for clean SVGs, then restores
  them** and re-renders again. Any new visual state that should not appear in the exported PNG has
  to join that dance.
- **`state.openNotes` is a `Set` and is intentionally not persisted.**
- **Weather and frost watch** come from Open-Meteo for Canton (40.80, -81.38), no key needed. The
  frost warning only fires March–November, when a cold night actually threatens something.
- **The chat request** uses `claude-sonnet-5` with `thinking: {type:'disabled'}` and
  `output_config: {effort:'low'}` — the answers are three warm sentences and there are no tools, so
  extended thinking would only add latency and cost.
- **Yield estimates** live in `yieldOf()` (a regex table of rough field estimates, lbs per
  planting) and `HARVEST_GOAL = 500` lbs is the season goal the progress bar measures against.
  These are honest approximations; if you refine them, refine them from a source.

## Conventions

- **Vanilla JS**, `'use strict'`, plain functions at module scope. No framework, no bundler, no npm
  dependencies, no TypeScript, no build step. Anything that needs a build step does not belong here.
- **SVG for the garden, not canvas.** Plots, the season ribbon, the year strips and the harvest
  chart are all SVG built as template strings. `<canvas>` appears once, in `savePoster()`, to
  flatten the SVGs into a PNG.
- **CSS custom properties** hold the palette — `--paper #F5EFDF`, `--ink #2C3527`, `--moss #5E7350`,
  `--clay #B5613D`, `--gold #C09A2C`. Use the variables, not the hex codes, in CSS. (SVG built in
  JS does use literal hex, since those strings are not styled by the sheet — keep them in step with
  `:root`.)
- **Fonts:** Fraunces (serif, display and italic asides) and Karla (sans, labels and body), from
  Google Fonts. Set them via `--serif` / `--sans`.
- **Voice.** The interface speaks quietly and in full sentences: "empty, full of possibility",
  "lifted gently and set aside". Transient messages go through `whisper()`. No exclamation marks,
  no emoji stuffing beyond the plant glyphs, no shouting. The community-garden mission is real and
  is never used as decoration.
- **Accessibility is load-bearing:** each plot is one tab stop with arrow-key walking, overlays are
  `role="dialog" aria-modal="true"` and close on Escape, and animation respects
  `prefers-reduced-motion`.

## How to run, test and deploy

### Development server
```bash
python proxy.py
# http://localhost:8080
```
The proxy serves the static files and forwards `/api/claude/*` and `/api/gemini/*`, passing along
whatever key header the browser sends — it holds none of its own and never reads `.env`. To wake the
model behind "Ask the almanac", run locally and set `localStorage['almanac-claude-key']` to your own
key; the request then carries it as `x-api-key`. Without a key, or without the proxy at all, the app
still works from `file://` or any static server — the ask panel simply uses the offline almanac,
which is the path nearly every visitor takes.

### Tests
There is no test runner and no test suite. Verify by hand, and cover these paths for any change
that touches scheduling or placement:
1. Drag the ribbon across the whole year — plants pass planned → sprout → growing → harvest → rest.
2. Check garlic specifically: planted in October, still in the ground in January, picked in July.
3. Tab into a plot, walk it with the arrows, delete a plant, undo.
4. Plant into a vessel — everything should occupy exactly one square.
5. Copy a share link, open it in a new tab, confirm the garden and the Ctrl+Z escape hatch.
6. Ask the almanac something with no proxy running — the offline answer must be sensible.

### Deploy
```bash
./deploy.sh            # stage dist/ and publish to Cloudflare Pages
./deploy.sh --stage    # stage only
```
`dist/` is assembled fresh each run — never edit it. It contains only the four app files, a
`preview.png` copied from `docs/screenshots/almanac-hero.png` for link previews, and a `_headers`
file. The Pages project is `gardensync-almanac`, branch `main`.

## External APIs

- **Open-Meteo** — weather and the frost watch (no key required)
- **Anthropic Claude** — "Ask the almanac", via `/api/claude/*` with a key from
  `localStorage['almanac-claude-key']`; falls back to `localAnswer()` whenever that call does not
  come back with an answer
