# A Quiet Almanac — Changelog

Live at <https://gardensync-almanac.pages.dev>. Project page:
<https://samizdat-publications.github.io/gardensync-almanac/>

Its sibling edition, the original GardenSync planner, lives at
<https://github.com/Samizdat-Publications/gardensync>
(live at <https://gardensync-e4e.pages.dev>).

Version numbers up to v6.1 were shared with the planner, back when both
editions lived in one repository. They are kept here rather than renumbered,
so the tags in this repo still line up with the commits they describe.

---

## v7.0 — 2026-07-26

**Moved into its own repository.**

The almanac was built inside the planner's repo as `fable/` and deployed as a
subdirectory of the planner's site. It never shared a line of code with the
planner — only a folder, a deploy script and the plant dataset. It now stands
on its own.

- Lifted out with `git subtree split`, so all seven of its commits came across
  intact rather than arriving as a single squashed import.
- The four app files moved to the repo root; `index.html`, `style.css`,
  `app.js` and `plants.js` are the whole program.
- Its own `deploy.sh`, publishing to a separate Cloudflare Pages project.
- Canonical, Open Graph and Twitter URLs repointed from
  `gardensync-e4e.pages.dev/fable/` to `gardensync-almanac.pages.dev`.
- The `Planner ↗` cross-link now points at the planner's own site by absolute
  URL, since the two are no longer siblings in one deployment.
- Its ten screenshots came with it.

Nothing about the running app changed.

---

## v6.1 — 2026-07-26

### Ask the almanac now answers for everyone

The chat only worked where a Claude proxy was running, which is nowhere on the
public build — every visitor who asked a question got *"The almanac is
resting"*. It now falls back to its own reading of the plant library and the
garden in front of it.

- Answers sowing calendars, companions and quarrels, container suitability, sun
  and water, spacing, what is ready to pick on the viewed date, the season's
  projected yield, and what wants doing this week.
- The proxy is tried once. If nothing answers it stops asking, and every later
  question is instant and local — measured at 3ms with no network.
- Where a key is configured, the full model still answers as before.

Two bugs in the question matching, both found by testing rather than reading:

- *"keep away from potatoes"* matched the container branch, because `" pot"` is
  a substring of `" potatoes"`. Word boundaries now.
- *"how much will I harvest"* hit the what-is-ripe branch ahead of the yield
  branch. Weight questions are caught first.

### Garlic grows the right way round

Garlic was scheduled as a spring crop. All three of its sowing fields are
`null`, which the spring maths reads as *plant at last frost* and lands the
harvest on **December 14** — for a crop whose own notes say plant October,
harvest July.

Fall-sown crops now have their own window that wraps the turn of the year: in
the ground **Oct 10**, growing through winter, harvested **Jul 12–26**, resting
August to September. The year strip draws it as two bars, the calendar gained
the missing *plant for next summer* entry, and spring crops are untouched.

### Keyboard navigation

Each plot is a single tab stop; arrows walk its plants in reading order, Home
and End jump to the ends, and Delete already worked on the selection. Focus
survives the re-render. Focus-visible outlines throughout, and the hover-only
note and delete buttons now reveal on focus.

### Link previews

Open Graph and Twitter card tags, a canonical URL and a theme colour.
`deploy.sh` copies the hero screenshot in as the card image at publish time.

---

## v6.0 — 2026-07-26

First public release, alongside the planner.

- Ask the almanac moved from Claude Sonnet 4.6 to **Claude Sonnet 5**, with
  thinking disabled and effort low — the answers are three warm sentences and
  there are no tools in play, so the reduced tool-eagerness costs nothing.
- Response parsing walks all text blocks instead of assuming `content[0]`.
- A `Planner ↗` link in the masthead, across to the other edition.

---

## Expansion 4 — harvest logging

Log actual picks per plant. The goal bar fills with what has really come in,
layered over what is projected. Season tallies per crop, persisted and included
in export and import.

---

## Expansion 3 — the smaller things

A *ready to pick* line for the viewed date, green dots in the seed drawer
marking what is already growing, frame-throttled ribbon scrubbing,
`prefers-reduced-motion` support, and dialog roles on the overlays.

---

## Expansion 2 — sharing

Share links that fold the whole garden into the URL hash, a PNG poster export
of the beds, succession sowing reminders for crops that genuinely want them,
and a first-visit hint on the ribbon pin.

---

## Expansion 1 — containers and the year

- **The potting shed.** Terracotta pots, tree pots, half barrels, grow bags,
  window boxes and steel troughs, each drawn with its own chrome. Container
  rules apply: everything fits one square, and sprawlers are warned they will
  sulk.
- **Harvest outlook.** Projected pounds, a progress bar against the 500 lb
  season goal, and a month-by-month chart.
- **A printable year.** Every sowing, transplant, succession round and first
  harvest, laid out month by month for the volunteer crew.
- **Field notes and caretakers** per plot.
- **Frost watch** reading the real seven-day Canton forecast.
- Redo, and a help overlay.

---

## Initial build — 2026-06-10

A ground-up rebuild of GardenSync with a different temperament: warm paper,
botanical ink, and a garden you plan by scrubbing through the year.

- The season ribbon: drag the pin to any date and every plot re-renders as the
  almanac imagines it then — dashed plans, sprouts, full plants, gold harvest
  rings, spent sepia.
- Companion halos instead of error messages: friends glow, foes blush, before
  you commit.
- Bed moods, SVG square-foot beds, a context-sensitive almanac panel, and
  *Ask the almanac*.

Shares the 77-plant Zone 6a dataset with the planner. The agronomy is
inherited; the design and the code are not.
