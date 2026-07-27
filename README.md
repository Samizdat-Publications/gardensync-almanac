# A Quiet Almanac

A square-foot garden planner you use by scrubbing through the year. Built for
[Canton, Ohio](https://en.wikipedia.org/wiki/Food_Not_Bombs), Ohio — USDA Zone 6a,
last frost April 18, first frost October 28, 193 days in between.

**Live: <https://gardensync-almanac.pages.dev/>**

![The almanac open in a browser: a warm cream page with a horizontal season ribbon across the top
running January to December, a seed drawer of plant packets down the left, and six plots in the
middle — The Greens Bed, Root Cellar, Potato Patch, Bean Machine, Garlic & Herbs and a Spud Sack
grow bag — each a rounded soil-brown rectangle ruled into square-foot cells, every planted square a
pale disc holding a small plant drawing. The panel on the right is headed "The garden on Jul 26"
with counts of plots, plantings and varieties, a ready-to-pick strip and the harvest
outlook.](docs/screenshots/almanac-hero.png)

---

## The season ribbon

Most garden planners draw one moment: the bed as it would look if everything were full-grown at
once. That is not a garden, that is a shopping list.

The ribbon across the top of the page is the whole year. Drag the pin to any date and **every
plot re-renders as the almanac reckons it on that day**. Nothing else in the interface changes —
same beds, same plants, same positions — only time moves.

The drawing states are:

| What you see | What it means |
|---|---|
| Dashed ghost outline | Not sown yet on this date — a plan, not a plant |
| Small sprout | Sown or transplanted, still growing |
| Full plant | Mature |
| Gold ring | Ready to pick right now |
| Sepia, faded | Spent — the season is over for this one |

Frost dates are marked on the ribbon; today sits pinned in clay red. The clearest way to see
what this buys you is to look at the same garden twice:

**Mid-April.** Cool-season crops are up; the summer plantings are still dashed intentions.

![The garden on April 16. The Greens Bed carries three full kale heads, one of them selected with
companion threads arcing out to its neighbours; the Root Cellar is a grid of half-grown onions and
carrots. The whole Bean Machine bed and the herb rows of Garlic & Herbs are drawn only as small
dashed outlines because their sowing dates have not arrived yet. The season ribbon pin sits just
short of the April 18 last-frost marker, and the line above the garden reads "Viewing Apr
16".](docs/screenshots/almanac-scrub.png)

**Mid-October.** The same beds, unchanged by you, six months later. The summer is spent; the herbs
are still worth picking; and the garlic that went in on October 10 is already in the ground.

![The same garden on October 16. The potatoes, beans and greens are washed pale to show they are
finished, while parsley and chives carry gold ready-to-pick rings and the two garlic rows are drawn
solid. The season ribbon pin has moved to October, just short of the October 28 first-frost marker,
and the panel is headed "The garden on Oct 16 — as the almanac imagines it", with a ready-to-pick
line reading parsley, chives and oregano.](docs/screenshots/almanac-october.png)

That pair is the whole argument. A bed that looks crowded in July is often half-empty in May,
and you cannot see that in a static plan.

Fall-sown crops wrap the year correctly rather than being clamped to it — garlic goes in on
October 10 and comes out on July 12, sleeping under straw across the New Year boundary in
between.

---

## Warm paper, botanical ink

The design is cream paper (`#F5EFDF`) with a real grain texture, deep green ink (`#2C3527`),
terracotta and gold accents, Fraunces for headings and Karla for everything else. Beds are drawn
as SVG, so they stay crisp at any zoom.

![The full garden view on textured cream paper: five rectangular raised beds — The Greens Bed, Root
Cellar, Potato Patch, Bean Machine, Garlic & Herbs — beside the Spud Sack, a stitched fabric grow
bag, with the Blueberry Pot beginning below. Each bed is ruled into square-foot cells and every
planted square is a pale disc holding a small botanical drawing, a count like ×4 or ×16 in small
type beside it, and a dashed gold ring where the crop is ready to
pick.](docs/screenshots/almanac-garden.png)

---

## Companion halos

Pick up a seed packet from the drawer and the garden answers before you commit. Every already-planted
friend of that crop glows moss green; every foe blushes terracotta. There is no modal, no
validation error, no red X after the fact — the information arrives while you are still deciding
where to put your hand.

![Holding a tomato seed packet — a banner above the beds reads "Planting Tomato — tap any open
square." The onions and carrots, the garlic and herb rows, the lettuce and parsley, and the
nasturtiums tucked into the corner of the Bean Machine are ringed in solid moss green as good
companions; the beans and chard carry only their gold ready-to-pick rings. The kale heads, every
square of the Potato Patch and the potatoes in the Spud Sack are dotted in terracotta to mark them
as conflicts. The side panel lists tomato's friends and foes, a tick beside each one actually
standing in the garden.](docs/screenshots/almanac-halos.png)

Each bed also reports its own temperament in plain words underneath — *thriving — friends all
around*, *content — good company*, or *uneasy — 2 quarrels*. It is a summary you can read at a
glance without opening anything.

---

## The potting shed

Not every garden is raised beds, so the shed offers seven kinds of plot, each drawn with its own
chrome:

- **raised bed** — any size, the default
- **terracotta pot** — 1 × 1
- **tree pot** — 2 × 2, deep (the blueberries approve)
- **half barrel** — 2 × 2, with visible staves and bands
- **grow bag** — 2 × 2, fabric, famously good for potatoes
- **window box** — 4 × 1
- **steel trough** — 6 × 2

![The potting shed: two rows of pill-shaped buttons on cream paper beneath the beds. The first is
labelled "raised beds —" and offers 8′ × 4′, 10′ × 5′ and 4′ × 4′; the second is labelled
"containers —" and offers terracotta pot, tree pot, half barrel, grow bag, window box and steel
trough.](docs/screenshots/almanac-shed.png)

Container rules apply. A vessel holds one plant per square, and sprawlers like squash get a
gentle warning that they will survive in a barrel but sulk about it.

---

## The plant page

Click any plant and the almanac panel becomes its page: a year-strip showing its own sowing,
growing and harvest windows against the calendar, the companions and enemies **that are actually
standing in your garden right now**, spacing, days to harvest, sun and water needs, seed-starting
instructions and care notes.

![The almanac panel showing the page for Kale: a horizontal year-strip with its sowing and harvest
windows shaded, a list of companion plants currently in the garden with ticks beside them, spacing
and days-to-harvest figures, and a short paragraph of care notes.](docs/screenshots/almanac-plant.png)

All 77 plants carry the same fields — 45 vegetables, 14 herbs, 15 flowers, 3 fruit — with sow and
transplant timings expressed relative to frost, so the whole library re-dates itself if the zone
does.

---

## Harvest outlook, and what you actually picked

The almanac projects pounds for the season by adding up a per-crop yield for every planting
standing in the beds — a fifth off for anything growing in a container — and spreads each crop's
pounds across the months of its harvest window to draw a month-by-month chart of when that food
arrives. There is a progress bar against a 500 lb season goal — the number that matters for a group
that feeds people.

Projection is not the same as dinner, so you can also **log real picks per plant**. The goal bar
then shows both: a lighter fill for what is projected, a solid fill for what has genuinely been
carried out of the garden. Season tallies persist and travel in the export.

For whichever date the ribbon is on, a "ready to pick" line names what is standing there ripe
today.

---

## The printable year

The calendar overlay lays the whole plan out month by month — every sowing, every transplant,
every succession round, every first harvest. It is designed to print on paper and go on a shed
wall, because that is where volunteer crews actually read things.

![The calendar overlay, headed "The year in the garden" and subtitled "Canton, Ohio
· Zone 6a · 7 plots · ≈251 lbs projected", with Print and Close buttons in the corner. Twelve month
blocks run three to a row on cream paper, each a dated list — "Feb 7 · Start Onion seeds indoors",
"Apr 18 · Direct sow Chives", "May 15 · First Kale harvest" — and the quiet months simply read
"rest."](docs/screenshots/almanac-calendar.png)

---

## Ask the almanac

There is a small chat companion that knows your exact beds and the date you are looking at.

It posts your question to `/api/claude/v1/messages` first, carrying an `x-api-key` header only if
you have put a key in `localStorage['almanac-claude-key']` yourself. When nothing answers there —
no proxy on the public build, or no key behind it — **it answers offline instead**, from the plant
library and your actual garden, not from a canned FAQ. Ask it what to sow this week, whether squash
will tolerate a barrel, how far along the harvest goal is, or which of your plants dislike each
other, and it reads the real data and replies.

![The Ask the almanac panel. The typed question reads "when should I plant garlic?" and the answer
begins "Garlic goes in the wrong way round: plant the cloves around Oct 10, mulch them under straw,
and let them sleep through the winter", going on to give a Jul 12 harvest, to note that there are 16
in the ground, and to cover scapes, curing and when the leaves brown. An "ask quietly…" box and a
send button sit underneath.](docs/screenshots/almanac-ask.png)

This mattered enough to build twice. An AI feature that only works if you paste in an API key is a
demo, not a feature.

---

## Keyboard and accessibility

The garden is fully navigable without a pointer:

- Each plot is a single tab stop
- Arrow keys walk the plants inside the focused plot; <kbd>Home</kbd> / <kbd>End</kbd> jump to the ends
- <kbd>Delete</kbd> removes the selected plant
- <kbd>Ctrl</kbd>+<kbd>Z</kbd> / <kbd>Ctrl</kbd>+<kbd>Y</kbd> for undo and redo

Overlays are real dialogs (`role="dialog"`, `aria-modal`), regions are labelled, decorative
elements are `aria-hidden`, and the ribbon animation respects `prefers-reduced-motion`.

---

## Keeping and sharing

- **Autosave** to `localStorage`, including harvest logs
- **Share link** — the whole garden folds into the URL hash, so sending a plan is sending a link
- **PNG poster** export of the garden as drawn
- **JSON export / import** for real backups
- **Undo / redo** across the whole session
- **Frost watch** — the weather chip reads the live 7-day Open-Meteo forecast for Canton and warns
  when a cold night threatens the tender plantings

---

## The help overlay

The whole manual is in the app, one `?` away. No wiki, no separate docs site to go stale.

![The help overlay on cream paper, headed "How to tend this place" with a Close button, holding five
short labelled sections — Plant something, Travel through the year, Get to know a plant, Tend the
beds, Keep it safe — covering the seed drawer, the ribbon pin, the plant page, renaming beds, and
autosave and undo.](docs/screenshots/almanac-help.png)

---

## Running it locally

```bash
git clone https://github.com/Samizdat-Publications/gardensync-almanac.git
cd gardensync-almanac
python proxy.py
```

Open <http://localhost:8080>.

`proxy.py` serves the static files and forwards `/api/claude/*` and `/api/gemini/*`. It holds no key
of its own — it passes along whatever `x-api-key` the browser sends, and the browser sends one only
if you have set `localStorage['almanac-claude-key']` yourself. **You do not need to.** With no key
the Anthropic call errors and the chat answers offline instead, which is the same code path the
public site uses.

Deploying is `./deploy.sh` — it stages a clean `dist/` (the four app files, an og:image, and
security headers; not the proxy, docs or screenshots) and publishes to Cloudflare Pages.

## Architecture

Four files. No build step, no bundler, no framework, no dependencies.

| File | Lines | What |
|---|---:|---|
| `index.html` | 161 | Structure |
| `style.css` | 660 | The paper, the ink, the grain |
| `app.js` | 1,630 | Everything: ribbon, SVG rendering, growth model, harvest maths, chat |
| `plants.js` | — | The 77-plant library |

Plus `proxy.py` for local development and `deploy.sh` for publishing. That is the entire
repository.

The restraint is deliberate and worth stating plainly: a tool a volunteer garden depends on
should still open in five years without anyone running an install command first. There is
nothing here to rot.

---

## Its sibling

This is a rebuild of **GardenSync**, and it shares the 77-plant dataset and the Zone 6a agronomy
with the original — the frost windows, the companion relationships, the spacing research. It
shares none of the code and none of the design.

The original planner is still very much alive and is the better tool if you want drag-and-drop
placement, six workspaces, 33 modules, demo gardens, volunteer scheduling, and an AI assistant with
tool use that can rearrange beds for you.

> **The planner** — [repo](https://github.com/Samizdat-Publications/gardensync) · [live](https://gardensync-e4e.pages.dev/)

Two temperaments on the same research. Pick whichever one you will actually open.

---

## Credit

Built for Canton, Ohio. The harvest feeds neighbours; the software should get out
of the way of that.
