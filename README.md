# ESP-Enclosure

A parametric ESP devkit enclosure for OpenSCAD, with the header broken out
through the floor.

The board sits hard against the inside of the USB end wall so its socket lines up
with the opening, carried and located by its own header pins. Those pins drop
through a thin hole plate into a pocket under each one, and Dupont connectors push
up into those pockets from below, finishing **flush with the floor** instead of
hanging out of the case, with the wires leaving straight down through the open
underside. Past the board's far edge is a clear bay for the onboard antenna.

**The geometry is one file.** [`esp-enclosure.scad`](esp-enclosure.scad) has no
`use <>` and no `include <>`, so the tray, the fit template and the coupon
render from it alone. The lid is the exception: its vents are cut from artwork
in an SVG beside it, so that file has to travel with the model — which also
means the Thingiverse and Printables customizers cannot render the lid. Set
`vents = false` and everything is standalone again.

## Quick start

1. Install [OpenSCAD](https://openscad.org/).
2. Open `esp-enclosure.scad`.
3. **Window → Customizer**, set your parameters.
4. Choose a part with `part` at the top, press **F6**, then **File → Export → STL**.

Print the `tray` and the `lid` — but print the two check parts first. They are
quick, and they cover the two ways a full case goes wrong: the `template` says
whether your board fits, the `coupon` says whether your pins grip.

> **Nothing here has been tested physically.** Whether a Dupont terminal grips at
> the default clearance, whether your devkit's pins are long enough, whether the
> latch holds the lid shut — none of that is testable by rendering. The Dupont
> and PCB defaults are starting points, **not specifications**. Print the coupon
> and check the console's pin-engagement figure before committing to a full case.

### Print the template first

Set `part = "template"`. It is a shallow stand-in for the tray — same footprint,
same interior outline, same pin holes in the same places, same screw bosses —
but 4.2 mm tall instead of 13.1.

Drop your actual devkit into it and you can see all three things at once:

| Check | What you are looking for |
| --- | --- |
| Does the board fit? | It drops between the walls without forcing |
| Does the header line up? | Every pin finds its hole, with the board seated flat |
| Is there room for the antenna? | The module clears the scored line, and the bay past it is empty |

The scored line across the floor marks where the board's far edge should land.
Everything past it is the antenna bay. If your module overhangs the board and
crosses into that space, that is exactly what the bay is for — raise
`antenna_gap` until it fits with air to spare.

### Print the coupon too

Set `part = "coupon"`. A few minutes and five layers, and it reproduces the real
hole plate at its real thickness — **everything cut at the size the model is
currently set to.** It is not a clearance sweep: there are no trial sizes and
nothing to label, because every hole is the hole your case will have.

**13.60 × 10.86 × 1.0 mm** — deliberately tiny, so you can put it straight over
five of your header's pins without the body fouling the neighbours.

**It is there to check the pitch.** Pick a preset, print this, push your
module's pins through the row. If they go in, the pitch you set is the pitch
your header actually is. That is why the engraved number is the **pitch** —
2.54, 2.00, 1.27 — and not the hole size.

**Its length is set by the pins either side of the run**, not by the rows. Those
two neighbours get **0.50 mm** of real clearance: a printer moves an edge a
tenth either way between elephant's foot, extrusion width and shrinkage, so a
coupon sized to *just touch* fouls in practice.

| | Measured |
| --- | --- |
| Pin holes | 5 × **0.840 mm**, centre-to-centre **2.54 exactly**, 1.22 mm to each end |
| Neighbouring pins | clear by **0.50 mm** each side |
| Dupont slot | one opening, **12.000 mm**, 0.80 mm rim each end |
| Depth | stacked at the floor: 0.80 rim / slot / 1.60 / pin holes / label / rim |

The Dupont slot's ends carry less material than the pin row's, 0.80 against 1.22:
only the pin row goes over a live header, so only its end material and side
clearance have to be right.

**The Dupont row is a slot, and that is correct.** Five surround openings on the
pitch is 2.70 on 2.54, so they overlap by 0.16 and run together, exactly as in
the tray. It is *cut* as one slot rather than five touching cubes, because
cutting them individually at a spacing equal to their own size butts one cut onto
the next, which is how this model makes non-manifold edges and a negative genus.
Only when the opening is narrower than the pitch do five holes appear.

The pin row is sized from the **bare post**, not from `hole`, so it reports what a
bare pin meets — from `hole` it would cut 2.70 mm openings with the surround on
and call that a pin fit. The Dupont row only appears with `dupont_housing` on.
Both parts cut their holes with the tray's own `plate_hole` module, so neither
can drift from the real case; if the fit is wrong, change `hole_clearance` and
reprint.

**The holes are plain square bores**, `hole` across at every depth, with no
lead-in chamfer. That is what makes the coupon trustworthy: the old 65°
`lead_angle` cut 1.07 mm into a 1.00 mm coupon and reported holes 0.1 mm
oversize, two whole steps of the coupon's own scale.

It costs nothing, because **the hole is a clearance hole by construction** —
whatever passes through it plus `hole_clearance`, already wider than that thing
before anything is chamfered:

| Preset | Post | Hole | Gap per side | |
| --- | --- | --- | --- | --- |
| 2.54mm standard | 0.64 | 0.84 | 0.10 | hole 31% wider than the pin |
| 2.00mm compact | 0.50 | 0.70 | 0.10 | 40% wider |
| 1.27mm micro | 0.40 | 0.60 | 0.10 | 50% wider |

The funnel only helped a pin *find* a hole it already fitted, and what does the
finding is the pitch. The exception is `hole_clearance = 0`, which the slider
allows: the hole is then exactly the post and printing shrinks it. Below 0.1 the
console warns and points you here.

Tick [`dupont_housing`](#the-plastic-surround) and the clearance is measured off
the **plastic surround** instead, which is most of a pitch to begin with, so the
proportions above stop applying and the coupon reports a housed connector's fit.

### Check your pin length

This is the one thing most likely to catch you out. For a connector to grip, the
pin has to clear the standoff *and* the hole plate and still have 2–4mm left
over. The model works this out and prints it to the console:

```
ECHO: "Case 60.92 x 34.46 x 15.1 mm | header 19 x2 @ 2.54 (2.5 mm plastic
surround) | 3 x 3 mm pin channel (clearance, not a fit) | 1.2 mm wire
channels, 1.34 mm rib (set) | 8 mm of pin inside the trough | board
gap 2.2 mm each side / 6 mm at the far end | USB micro 8.1 x 3.1 at 1.3 above
the floor | antenna bay 6 mm | vents from slots.svg"
```

If it warns you, it means the pins are too short:

```
WARNING: only 0.8 mm of pin reaches into the trough. A crimp terminal needs
roughly 2-4mm to grip. Use longer pins, or lower pcb_standoff / hole_plate_t.
```

**The stock tail on a pre-soldered devkit is only about 3mm, which is not
enough.** The defaults assume long-tail headers (`pin_length = 6`). With short
pins, set `terminal_recess = false` and let the connectors sit below the case.

## Parameters

What each setting is *for*, with the reasoning and the measured consequences.
Every parameter's default and slider range is listed once in [Every
parameter](#every-parameter), generated from the `.scad`.

### Board

> **There is no `board_clearance`.** It measured the same span as `side_margin`
> minus `board_side_margin` minus `wall` — three parameters for two distances,
> and only ever one of them live: below `side_margin` 3.6 the board chain sets
> the width, above it the reverse. `side_margin` survived because it is what the
> troughs and pin holes are checked against.

The gap between board and wall is now **derived, not requested**. You place the
wall with `side_margin` and the board's edge with `board_side_margin`, and the
gap is what is left over:

```
gap each side = side_margin - board_side_margin - wall
              = 5.8 - 2 - 1.6 = 2.2 at the defaults
```

The console prints it, and warns below 0.2 mm — half an extrusion width, under
which the board has to be forced rather than dropped in. Raising
`board_side_margin` past `side_margin - wall` (4.2 at the defaults) makes the
board set the width, the gap goes to zero and you get that warning; raise
`side_margin` to match. Lengthwise the room is `antenna_gap` alone, so
`antenna_gap = 0` is a press fit and warns too. The USB end is flush on purpose
— clearance there would push the socket off its opening.

> **There are no rest pads.** Four corner blocks used to stop the board rocking,
> sized by `ledge_d` and `ledge_w`; both parameters are gone with them. The
> header pins carry and locate the board, which is what the pads were riding on
> anyway. Removing them changed nothing else: same genus, same downward-facing
> area.
>
> What the board's long edges land on is the **plinth**, which runs out to the
> side wall for that reason — see [Only the connectors get a thick
> floor](#only-the-connectors-get-a-thick-floor). Its top is the floor's top, so
> it is a seat, not a support to design around.

**`pcb_standoff` is the header's plastic strip**, which is why the pads are not
needed: the board sits on the strip its pins are moulded into, and the strip sits
on the plinth tops. The case does not set this — measure it on your own header,
about 2.5 mm on a standard 2.54 one.

#### It is a measurement, not a lever

**It does nothing at the shipped defaults.** With the pin channel on, which
`dupont_housing` forces, the spacer sinks into it and the board lands on the
plinth tops, so only the part *taller than the channel is deep* has any effect:

```
board_under = max(0, pcb_standoff − pin_slot_depth)
```

The tray mesh is **byte-identical** across `pcb_standoff` 0, 1, 2 and 3; raise
`pin_slot_depth` to 5 and it is inert to 5. That is the board datumed off a
printed surface instead of your spacer, which is the good case.

**Where it is live:** with `dupont_housing` **and** `pin_slot` both off — no
channel, the board rests on the spacer, and every value changes the mesh. That is
the crimped-terminal mode.

| Channel swallows the spacer? | 1.2 | 2.5 |
| --- | --- | --- |
| yes (default) | 15.1, grip 8.0 | 15.1, grip 8.0 |
| no (`dupont_housing` and `pin_slot` off) | 15.1, grip 6.8 | 15.6, grip 5.5 |

#### It will not lift the PCB off the bottom of the box

Raising it pushes the board up **off the pins**, so it spends grip; and the floor
shrinks underneath by the same amount, because the floor is sized to swallow the
pin and there is less pin left below the board. Two effects cancelling. The
outside distance is:

```
bottom of box → underside of PCB
    = max(pin_length, terminal_len + hole_plate_t + board_under)
    = max(9, 6 + 1 + board_under)
```

— flat at `pin_length` until `board_under` passes 2, i.e. `pcb_standoff` 5:

| `pcb_standoff` | 0 | 3 | 4 | 5 | 6 | 10 |
| --- | --- | --- | --- | --- | --- | --- |
| Floor | 9.0 | 9.0 | 8.0 | 7.0 | 7.0 | 7.0 |
| Bottom → PCB | 9.0 | 9.0 | 9.0 | 9.0 | 10.0 | 14.0 |
| Grip | 8.0 | 8.0 | 7.0 | 6.0 | 5.0 | 1.0 |

**For more room under the board, use `pin_length`** — it lifts the board *and*
buys grip, where this spends it. `pin_length` 12 gives 12.0 mm and 11.0 mm of
grip; `pcb_standoff` 6 gives 10.0 mm and 5.0 mm. `terminal_len` deepens the
trough the same way.

### Dupont preset / pin pitch

**`pin_pitch` holds the pitch itself**, not a preset code — the number in the
dropdown is the number in the variable. The three Dupont families each carry
their own pitch and post size, so picking one sets both:

| `pin_pitch` | Post | Hole at default clearance |
| --- | --- | --- |
| 2.54 — standard | 0.64 | 0.84 |
| 2.00 — compact | 0.50 | 0.70 |
| 1.27 — micro | 0.40 | 0.60 |

> **There is no `Custom`**, and no `custom_post`. Both only did anything at *one*
> of the four dropdown values and sat inert at the other three. It bit hardest on
> the fit coupon, which exists to check the pitch: you would reach for the pitch
> setting, nothing would move, and the coupon looked broken when it was not. An
> `assert` now catches any `pin_pitch` that is not one of the three.

Look at the last two columns together. The plate left standing *between* one
hole and the next is pitch − hole: 1.70 mm at 2.54 pitch, 1.30 mm at 2.00, and
**0.67 mm at 1.27** — under the 0.8 mm two perimeters want. The micro preset
cannot be printed as separate holes on a 0.4 mm nozzle, which is what the pin
channel is for.

### The plastic surround

`dupont_housing` is **on by default**, so the openings are sized for the
connector's **plastic square surround** and a fully housed Dupont goes through.
Untick it and they go back to the **bare metal post**, which is what you want if
you are pushing crimped terminals up into the troughs instead.

The table above is the post case, i.e. the tick *off*.

The surround's size is not a measurement you take. Housings are moulded to
**tile the pitch** — that is exactly what lets a row of them sit shoulder to
shoulder on a header — so it *is* the pitch, less the moulding gap that stops
two of them jamming:

| Preset | Pitch | Surround | Opening at default clearance |
| --- | --- | --- | --- |
| 2.54mm standard | 2.54 | 2.50 | 2.70 |
| 2.00mm compact | 2.00 | 1.96 | 2.16 |
| 1.27mm micro | 1.27 | 1.23 | 1.43 |

#### It merges the row, and that is not a choice

Read the last two columns together again. The opening is **wider than the
pitch** — 2.70 against 2.54 — so the plate between one hole and the next is
0.32 mm of *negative* material, and so is the wall between one pocket and the
next. No setting rescues that, because it is the connector's own shape doing
it: a row of surrounds touching is what a row of surrounds *is*.

So the tick derives the merged forms rather than asserting against them. While
it is on:

| Setting | Held at | Why |
| --- | --- | --- |
| `pin_slot` | on | One continuous channel — there is no rib to keep. |
| `pin_slot_w` | ≥ the opening | Below it the surround does not fit through; above it is yours. |
| `pocket_wall` | 0 | The troughs merge into one slot per row. |

The console prints them with their numbers when you tick it, so nothing goes
quiet, and unticking makes both live again exactly as they were.

**`wire_channel_w` is not on that list.** A wire channel is sized to the pin,
never to the surround, and stays a live setting with the tick on — see [Wire
channels](#wire-channels).

#### `terminal_len` decides how much housing shows

The tick sizes the trough **across** but not **down**. `terminal_len` is the
trough's depth, so it controls how much of the connector is buried and how much
shows below the case — and **there is no warning about it**, because leaving some
proud is legitimate: a housing sticking out is easier to grip and unplug, and it
costs no case height.

Every millimetre you bury is a millimetre of case, and that is the whole trade:

| `terminal_len` | Case height | A ~15 mm housing then shows |
| --- | --- | --- |
| 3 | 15.1 | 12.0 |
| **6 (default)** | **15.1** | **9.0** |
| 10 | 17.1 | 5.0 |
| 15 | 22.1 | 0.0 — flush underneath |

Pick the row you want. How long your housings are is a measurement only you have,
so the model does not guess at it.

**The tick itself costs no height at all.** At the same `terminal_len` the case
is the same either way — the surround only widens cuts that already existed.

### Pin channel

`pin_slot` replaces the whole row of square holes with **one continuous
channel** running the length of the header. The pins still drop through it into
the trough and the terminals still push up from below; what goes away is the rib
between one hole and the next.

`pin_slot_w` defaults to **3** — a clearance channel wider than the 2.54 pitch, so
the header's strip drops into it and [the board goes down with
it](#the-board-drops-when-pin_slot-is-on) by 1.2 mm. Set it to **0** and the
channel is exactly as wide as a hole: the pins stay gripped, the coupon's reading
stays meaningful, and the board does not move.

`dupont_housing` forces `pin_slot` on at any pitch, since a plastic surround
leaves no rib either, and holds `pin_slot_w` at or above the opening.

Two things follow, and the console prints both with your own numbers:

- **4 mm is clearance, not a fit.** A 0.64 mm pin gets three millimetres of air,
  located in neither direction, and **the coupon no longer describes the part**.
  `pin_slot_w = 0` makes the channel as wide as a hole was, and both come back.
- **A channel wider than the pocket is a wide slot over a narrower hole.** At
  4 mm over a 1.74 mm pocket, the 1.13 mm each side is the top of solid plinth:
  it prints fine, facing up, but it is floor, not passage.

`pin_slot_depth` only has to get through the hole plate, 1.0 mm at the defaults;
below that the channel opens into nothing and is clamped up rather than rejected.
Past the plate the trough is square and full width, so extra depth only removes
more plinth. (Square pockets removed an interaction the old ridged roof had: a
3.0 and a 4.2 trough both gave the same 1.865 mm opening at `pin_slot_depth = 3`.)

A channel down the middle of a plinth has to leave a wall each side, and under
two 0.4 mm perimeters that wall is weak. There is room at the defaults — an
8.40 mm plinth around a 3 mm channel leaves 2.70 mm each side — and the warning
names the lever that will actually move it, which is not always `plinth_wall`:
see [the plinth reaches the side wall](#only-the-connectors-get-a-thick-floor).

The template follows the tray: at the pitch that makes the channel worth having,
a template full of separate holes is as unprintable as the tray. The coupon does
not follow — its job is to report a hole size, so its pin row stays a row of
holes on the pitch.

The wire channels still need a rib between one channel and the next, so at
1.27 pitch they have to be narrowed to 0.45 or set to 0 — `pin_slot` does not
rescue them, since those channels run *across* the plate rather than along it.

### Terminal recess

**The pocket takes whichever of two demands is larger.** The "terminal" is the
Dupont crimp terminal, the metal socket that crimps to a wire and pushes onto a
pin, and burying it is why the pocket exists. But the pin's own tail has to fit
in there too, or it comes out through the underside:

```
pocket = max(terminal_len,  pin_length − board_under − hole_plate_t)
       = max(6.0,           9.0 − 0.0 − 1.0 = 8.0)          =  8.0
floor  = pocket + hole_plate_t                              =  9.0

board_under = pcb_standoff − board_drop = 1.2 − 1.2 = 0.0   at the defaults
```

They are not two names for one thing — a longer pin does not make a connector
bigger — but both land on this one dimension, so it takes the larger. That is
what makes `pin_length` change the case at all:

| `pin_length` | 3 | 6 | 7 | **9 (default)** | 12 | 16 |
| --- | --- | --- | --- | --- | --- | --- |
| Pocket | 6.0 | 6.0 | 6.0 | **8.0** | 11.0 | 15.0 |
| Case height | 13.1 | 13.1 | 13.1 | **15.1** | 18.1 | 22.1 |

**The board drop is already in this.** With the pin channel on the board sits
1.2 mm lower, the pin reaches 1.2 mm further down, and the floor grows to swallow
it. The pins never show below the case: at `pin_length` 16 the floor is 16.0 mm
deep for a 16 mm pin. The threshold where the pin starts driving the floor moves
with the drop too — **past 7.0 mm** at the defaults, against 8.2 with no channel.

Pins *can* come through with `terminal_recess = false`, where the floor is a fixed
`floor_solid` slab with no pocket to grow. The console reports how far: at
`pin_length` 6 they reach 2.8 mm past the underside.

It only ever *grows* the case. Cutting the pins short does not shrink it, because
the connector still needs its room — lower `terminal_len` as well. **Soldering
straight to the board?** Set `terminal_recess = false`: no connector to bury and
no tail to swallow, so the floor drops to `floor_solid` and the case loses 5 mm.

`pin_length` is checked at both ends. Below `pcb_standoff + plate_t` it is an
error — the pin never leaves the plate, so a terminal has nothing to grip.

**There is one square pocket per pin, not a slot.** Each runs straight from the
case underside up to the hole plate, the same size in both directions, with
`pocket_wall` dividers between them.

Measured at the defaults: **1.740 × 1.743 mm**, square at every depth.

`pocket_wall` is the only control, and it is the divider, not the pocket — the
pocket takes whatever is left of the pitch, `pitch - pocket_wall`, in both
directions. Set it to **0** and the pockets touch and merge into one continuous
slot per row, which is the older behaviour.

| `pocket_wall` | Pocket | Result |
| --- | --- | --- |
| 0 | 2.54 | **Merged** — one slot per row |
| 0.8 (default) | 1.74 | Separate, two clean perimeters |
| 1.2 | 1.34 | Separate |
| 3.0 | 0.84 | Clamped to the hole, divider 1.70 |

There is no `trough_w`: it set the pocket across the row while `pocket_wall` set
it along, making the pockets rectangles for no reason. One number, one shape.

The one thing it will not let you do is go below the hole above it — a pocket
narrower than its own hole would choke the pin it exists to receive. At the 1.27
micro preset, and at any `pocket_wall` past about 1.5, that clamp bites: the
divider comes out thicker than you asked and the console says so.

And **at 2.54 pitch, separate pockets and full-width crimp terminals are mutually
exclusive.** A Dupont crimp terminal is roughly 2.4 mm across; a pocket with
printable dividers is 1.74. `pocket_wall = 0` is there for that case, and
[`dupont_housing`](#the-plastic-surround) is the same trade one step further out,
for a terminal still wearing its plastic.

**Merged pockets are cut as one trough, not as a row of touching cubes.** That
is a correctness matter rather than a tidiness one: a pocket exactly `pitch`
long on a `pitch` spacing leaves every cube butting its neighbour face to face,
which is how this model makes non-manifold edges. It renders `Status: NoError`
and reports a *negative* genus, which is the only sign you get. The extent is
identical either way, so nothing moves — what goes away is interior faces that
never had any business existing.

The topology tells you which you got. Sealed-base with a merged slot is genus 37:
one blind pocket per row reached by 19 openings, 18 handles apiece, plus the USB
opening. Sealed-base with separate pockets is **genus 1** — each pocket is
reached by exactly one hole, so it contributes no handle at all, and only the USB
opening is left.

### Sealing the bottom

The troughs are the only thing that opens through the bottom of the case: the pin
holes stop at the trough, and the relieved floor is already solid.
`seal_bottom = true` puts a slab of `floor_solid` under them, so the base has no
holes at all.

**Nothing else changes.** The pin holes, troughs, plinths and wire channels all
stay as they are; the pockets become blind pockets, which is where the pin tails
then sit. The case grows by the thickness of the slab.

| | Default | Sealed |
| --- | --- | --- |
| Case height | 15.10 mm | 17.10 mm (+`floor_solid`) |
| Underside over a trough | open | **solid 2.00 mm** |
| Pin into the trough | 3.8 mm | 3.8 mm — unchanged |
| Genus | 39 | 37 |

Genus 37 is the arithmetic working out: each trough becomes one blind pocket
reached by 19 hole-and-channel openings, 18 handles apiece, plus the USB opening.
Turn the USB opening off and it is exactly 36.

You cannot fit a crimp terminal into a sealed trough, so the model stops reporting
terminal grip when the base is closed and warns instead if the pins are longer
than the pocket is deep:

```
WARNING: the pins reach 9.8 mm into a sealed trough only 6 mm deep, so they
will bottom out and lift the board 3.8 mm. Raise terminal_len, or trim the
pins and lower pin_length.
```

### Only the connectors get a thick floor

That floor is 9.0mm at the defaults — the trough's **depth** plus the hole
plate, `max(terminal_len, pin tail) + hole_plate_t` = 8.0 + 1.0, and nothing
else. The pin tail is what wins there: `pin_length` 9.0 less the plate leaves 8.0
to swallow, against the 6.0 `terminal_len` asks for. (Not `pocket`, which is the
trough's *width*, 2.70.) But only the two strips carrying the troughs need to be
that thick. So with `floor_relief` on, the middle drops to `floor_solid` and each
pin row keeps a **raised plinth**.

The plinth tops sit exactly where the old floor top was, so the PCB seat and the
lid are unaffected — it is purely plastic removed, and the case outside does not
move.

#### The plinth reaches the side wall

Each plinth is the larger of two demands, and the console says which one it took:

```
plinth_w = 2 * max(pocket / 2 + plinth_wall,     the trough plus its walls
                   row centre - wall)            reaching the side wall
```

The second is what binds at the defaults. Left at the trough's own width the
plinth stops 1.65 mm short of the side wall, and that gap is not relief worth
having: **1.65 mm across and 7.0 mm deep**, four extrusions wide. On a wide board
it is also where the **board's own edge** lands — at `board_side_margin` 3 that
edge sits at y 2.8, outboard of a plinth face at 3.25, with no rest pads to carry
it. So the plinth runs out to the wall, growing inboard by the same amount to
stay centred on the trough it carries.

The relief then comes out as **one bay down the middle**, not three regions.
Measured across the width at `z = 5`:

| Region | Span in Y | Width |
| --- | --- | --- |
| Plinth, row A | 1.60 → 10.00 | 8.40, with the 2.70 trough at 4.45 → 7.15 |
| The bay between the rows | 10.00 → 24.46 | **14.46** |
| Plinth, row B | 24.46 → 32.86 | 8.40 |

Probed at the board's edge, `y = 2.5` is solid from 0.00 to 9.00 — full floor,
where it used to be 2.0 mm of `floor_solid` with a trench above it. Nothing else
moves: the bounding box is unchanged and the downward-facing area is still
0.5 / 1.0 / 1.6 mm² at 45/55/60°.

`plinth_wall` still sets the width wherever the trough asks for more than the wall
does — past **2.85** at the defaults, where 3.0 gives a plinth of 8.70 and the
console names the trough as what set it. Widening the pocket does the same. What
it will not do is widen a plinth already reaching the wall; there the lever is
`side_margin`, and the thin-channel warning says so.

Push the rows far enough out and the two plinths meet in the middle. Once the bay
is under a millimetre it would be a slot too narrow to print, so it is spared as
**one** solid floor rather than two plinths butting face to face — the same rule
the plinth's ends use, and for the same reason: touching cuts make non-manifold
edges. At the defaults that happens at `side_margin` 12.53. The wire channels
have nowhere to break out into once it does, and the console warns.

### Wire channels

Every pin hole has a channel beside it, so you can take a wire off a pin and
bring it **into the box** rather than down through the underside — for wiring a
sensor or a display to a GPIO inside the case.

There is no `wire_channels` tick: a tick and a width are two settings for one
decision, and with both of them there was no way to see which one was the reason
you had no channels.

**The default is sized for the WIRE, not for the pin**: 1.2 mm, which is 26 AWG
with its insulation on. What travels down the channel is a wire, so the wire is
what it is measured against — at the pin's own 0.84 the channel is narrower than
common hook-up wire and the wire will not lie in it. At the 2.54 pitch, 1.2 leaves
**1.34 mm of rib** between one channel and the next, comfortably over two
perimeters.

Matching the pin instead is one number away, and it is the width at which the
channels impose nothing the pin holes already do:

| Preset | The pin's hole | Rib at that width | Rib at the 1.2 default |
| --- | --- | --- | --- |
| 2.54mm standard | 0.84 | 1.70 | 1.34 |
| 2.00mm compact | 0.70 | 1.30 | 0.80 |
| 1.27mm micro | 0.60 | 0.67 — under two perimeters | 0.07 — narrow it to 0.45 |

**Change `pin_pitch` and the width does not follow it**, because it is a number
you set rather than one the model derives. The console reports the gap instead of
quietly closing it: it names both widths, both ribs, and the number to type to
match the pin.

**The plastic surround does not change any of this.** `dupont_housing` widens the
way *in* for the connector, which arrives from below; a wire channel is the way
*out* for a wire coming off a pin, which does not care how bulky the housing on
the other side of the plate is. The channel stays the width you set it to,
whatever the opening becomes.

#### Setting the width

It is **one** setting, not the five it used to be — a tick plus `slot_w`,
`slot_neck`, `wire_w` and `slot_depth`, each of which could quietly break the
channel or merge it into its neighbour.

**The useful direction is usually down.** The channel carries a wire, and a
jumper's insulation is well under a millimetre, so narrowing it buys back rib —
which is the whole problem at a fine pitch:

| Preset | The pin's width | Rib | Max before rib < 0.8 | Narrow to 0.45 → rib |
| --- | --- | --- | --- | --- |
| 2.54mm standard | 0.84 | 1.70 | 1.74 | 2.09 |
| 2.00mm compact | 0.70 | 1.30 | 1.20 | 1.55 |
| 1.27mm micro | 0.60 | **0.67 — too thin** | 0.47 | **0.82 — works** |

At the micro preset wire channels were impossible at any setting; even the pin's
own 0.60 leaves only 0.67 mm of plate. `wire_channel_w = 0.45` leaves 0.82 and
renders. **This is the setting that makes wire channels possible at 1.27 at
all** — and 0 is how you decide not to have them.

#### Widening, and where the channels merge

The whole slider is live: there is **no upper clamp**, because capping it at
`pitch − 0.8` left the top third of the travel doing nothing.

Past the pitch the channels **merge** into one continuous slot down each row,
the way `pin_slot` merges the holes and `pocket_wall = 0` merges the pockets.
That is a real part — a full-length wire exit — not an error to prevent. At
2.54 pitch:

| `wire_channel_w` | What you get | Rib |
| --- | --- | --- |
| 0 | **no channels at all** — plain holes | the whole 2.54 |
| over 0 to 0.4 | raised to 0.4 — a slot narrower than the nozzle is not a slot | 2.14 |
| 0.4 → 1.74 | separate channels, printable ribs (**1.2 is the default**) | 0.80 → 2.14 |
| 1.74 → 2.54 | separate channels, **thin ribs — warned** | 0.00 → 0.80 |
| 2.54 and over | **merged**, one slot per row | none |

The middle band warns rather than clamps, as `pocket_wall`'s too-thin dividers do:
it prints, it is just fragile. The merged band prints a note, since it gives up
the last thing locating the header along the row.

**There is no rib `assert` on the channel any more.** It used to reject the
*derived* width — the one you got at `0` — because nobody had asked for it. Every
width now comes from the panel, so the model reports the consequence instead of
refusing. **What that costs:** at `pin_pitch = 1.27` the shipped 1.2 renders with
a warning, 0.07 mm ribs, where the derived 0.60 was rejected outright.

Sectioning the plate at 2.54: 0.1 / 0.6 / 1.2 give channels of exactly **0.40 /
0.60 / 1.20 mm**, 19 per row; at **2.54 the section collapses to one of
48.26 mm**, exactly `span + channel_w`, and at 3.0 to 48.72. Manifold at every
step, including the butting point.

Direction and length are not settings, because neither has a second sensible
value. Channels run toward the middle of the box — outboard is the side wall,
with nowhere to leave the wire — and far enough to break clear through the
plinth's side, since a channel stopping inside it is a pocket, not a way out.

- **It exits sideways, not over the top.** The board sits only `pcb_standoff`
  above the plinth, 1.2 mm, so a wire climbing over would lift it. Leaving at
  plate level and dropping into the relieved floor avoids that.
- **It reaches below the hole by one hole width.** Without that its mouth into
  the trough is a sliver no wire fits through. One width down for one across, so
  the channel is square where it meets the trough.

The pins do **not** rely on the holes being closed. Both rows' channels point
inboard, so a board drifting one way frees one row into its channels while the
*other* row presses against the far side of its holes and stops. Either
direction, the board is held to `(hole - post)/2` = 0.10 mm — the same figure a
closed hole gives, and far tighter than the 1.2 mm of clearance to the side
walls.

At the **1.27 micro preset**, `wire_channel_w = 0.45` leaves 0.82 mm of rib and is
sound; the 1.2 default leaves 0.07 and warns. `pin_slot` does not rescue it: the
channels run *across* the plate, so they need the pitch whether the pins sit in
holes or in one long channel.

Set `wire_channel_w = 0` if you do not want them at all.

### Room for the antenna

A devkit mounts its radio module hard against the far end of the board, antenna at
the module's tip, often overhanging the board's edge. Pressing a wall against it
is the one thing a case can do that actually degrades the radio, so `antenna_gap`
reserves clear air between the board's far edge and the far wall.

The wall in front of it is left at full thickness — this is mechanical room, not
an RF window. **Measure your own board**; 6mm is a starting point, not a spec.

### The board is flush at the USB end

The board sits hard against the inside of the USB end wall, so its socket lines
up with the opening rather than being centred and missing it. The header is
soldered to the board, so it follows: everything is positioned from the board's
USB edge outward.

**With `usb_opening` off, the board steps back by `usb_overhang`.** The socket
overhangs the board's edge, so flush against the wall it protrudes 1.0 mm *into*
that wall — fine when there is a hole for it, impossible when there is not. So
the board moves back by the overhang, the socket's face lands on the wall's inner
face, and the whole connector is inside the box.

| | Length | Antenna bay |
| --- | --- | --- |
| `usb_opening` on | 60.92 | 6 |
| `usb_opening` off | 61.92 | 6 |

The case grows by the same 1 mm rather than the antenna bay paying for it —
`antenna_gap` is clear air you measured for a reason.

**The socket still counts toward the cavity when the opening is off.** Switching
it off removes the hole in the *wall*, not the socket from the *board*, and the
lid still has to clear it. This used to zero the shell height along with the
opening, so the cavity forgot the connector entirely:

| `usb_type` | Cavity, opening off — before | Needed | |
| --- | --- | --- | --- |
| `micro` | 4.1 | 4.1 | fine by luck — the shell equals `component_h` |
| `c` | 4.1 | 4.8 | lid closed onto the socket by 0.7 |
| `mini` | 4.1 | 5.6 | by 1.5 |
| `a` | 4.1 | 7.3 | **by 3.2** |

All four now clear it, and every one of them rendered `NoError` before.

### Case size

The board sets the length, and the header sets the board:

```
length = 2 * wall + board_length + antenna_gap
width  = max(row_spacing + 2 * side_margin,
             board_width + 2 * wall)
```

where `board_length` is `board_l`, or `(pin_count - 1) * pitch +
2 * board_end_margin` when `board_l` is 0, and `board_width` is `board_w`, or
`row_spacing + 2 * board_side_margin` when `board_w` is 0. Set
`length_override` / `width_override` to a non-zero value to pin them.

That `max` is what makes `board_side_margin` and `board_w` work at all: the width
used to come from the header alone, so growing the board past the case was an
error rather than a bigger case.

**It is also what makes `side_margin` look broken when it is not.** The two terms
cross at `side_margin` **3.6** with the defaults, and below that the board sets
the width and moving `side_margin` changes nothing:

| `side_margin` | Case width | Gap each side | What set it |
| --- | --- | --- | --- |
| 3.0 | 30.06 | 0 | the board — `side_margin` is doing nothing |
| 3.5 | 30.06 | 0 | the board — still nothing |
| 3.6 | 30.06 | 0 | they tie |
| 4.0 | 30.86 | 0.4 | `side_margin`, 1:1 from here up |
| 5.0 | 32.86 | 1.4 | `side_margin` |
| 5.8 (default) | 34.46 | 2.2 | `side_margin` |

So if it appears dead, it is losing the `max`, not failing. Raising `wall` or
`board_side_margin` raises the board's demand and moves that crossover up. The
console prints the width it settled on.

Two more things about it, both easy to misread:

- **It measures to the OUTER face, so it carries the wall.** Thicken `wall` and
  the case does not grow; the interior shrinks. At 5.8 the outside stays 34.46
  while the interior goes 31.26 at a 1.6 wall and 29.66 at 2.4.
- **Screw bosses add to it instead of fitting inside it.** A corner boss needs
  width the header does not, so `closure = "screw"` puts a full `boss_d` on
  *each* side on top of what `side_margin` asked for. Under the stock `friction`
  closure the row centre sits at `side_margin` exactly:

  | `closure` | Case width | Row centre from the face |
  | --- | --- | --- |
  | `friction` (default) | 34.46 | 5.8 — `side_margin` |
  | `screw` | 43.46 | 10.3 — `side_margin + boss_d` |

> There is no `end_margin` any more. It set the distance from the end pin to the
> outer face, which the flush board now decides at the USB end and `antenna_gap`
> decides at the far end. Use `board_end_margin` to move the header on the board.

### USB opening

`usb_type` picks the connector. The openings are **flush mount**: sized to the
socket's own metal shell plus a 0.6 mm print fit, so the socket meets the wall
rather than a big hole being left for the plug to pass through.

| `usb_type` | Receptacle shell | Opening | Case height |
| --- | --- | --- | --- |
| `micro` (default) | 7.50 × 2.50 | 8.10 × 3.10 | 15.1 |
| `c` | 8.95 × 3.20 | 9.55 × 3.80 | 15.8 |
| `mini` | 7.70 × 4.00 | 8.30 × 4.60 | 16.6 |
| `a` | 13.00 × 5.70 | 13.60 × 6.30 | 18.3 |
| `custom` | — | `usb_w` × `usb_h` | 18.0 at 12 × 6 |

Sockets vary far less between boards than cable overmoulds do, which is what makes
flush mount worth having — but measure yours, and use `custom` if it disagrees,
where `usb_w`/`usb_h` are the finished opening and include your own fit.

**The opening is positioned automatically, not by `opening_z`.** A flush hole has
to line up, and the socket stands on the board's *top* face, so that face is the
only thing that can decide where the opening goes:

```
usb_z = board_under + board_t - usb_fit/2   = 0.0 + 1.6 - 0.3 = 1.3

board_under = pcb_standoff - board_drop, i.e. 0 while the channel swallows
the spacer.  With no channel it is pcb_standoff, and usb_z is 2.5.
```

Measured on the mesh: the wall is solid to **z 10.30** and open from there to the
rim at 13.10, the lid sitting low enough that the opening reaches the top edge. A
2.5 mm micro shell on the board's top face (10.60) occupies 10.60–13.10 —
**0.30 mm clear beneath it.** At the old fixed `opening_z = 0.5` that same 3.1 mm
opening would have caught 0.8 mm of the shell and missed the rest. `opening_z`
still places the *far end* opening, which has no socket to meet.

**The opening is the connector's shape, not a rectangle.** On a flush mount every
corner the real shell curves away from is a gap left behind.

| `usb_type` | Outline | Width, bottom to top |
| --- | --- | --- |
| `micro` | Trapezoid, wider at the top | 7.20 → 8.10 |
| `mini` | Trapezoid, wider at the top | 7.10 → 8.30 |
| `c` | Obround, radius = half the height | 9.55 at mid-height, tapering to the caps |
| `a` | Rectangle — genuinely is one | 13.60 throughout |

The micro/mini taper is what stops a plug going in upside down, so it is the part
of the outline most worth having. It is approximate — a shell's draft varies by
manufacturer far more than its overall size does — and bounding size is what the
asserts and the cavity height use.

It changes the overhang too: the opening's top edge is the one flat bridge in the
end wall, and an obround replaces it with an arch. USB-C measures 91.5 mm² at 45°
but 87.5 at 60°, where the flat-topped trapezoid stays at 89.4 across all three.

### Getting the socket in

`usb_overhang` is how far the socket's shell stands proud of the board's edge —
about 1 mm on most devkits, sometimes 0. **Measure it.** Two things depend on it,
and both matter more than they look.

**It is the plug's reach.** The socket's face ends up `wall − usb_overhang` from
the outside — **0.6 mm** at the defaults, not the full 1.6 — which is the
difference between a lead seating and a lead fouling the case.

**And it is why the opening is notched to the wall's top edge.** A nose that
overhangs has to end up *inside* the wall, and it cannot get there going straight
down: the nose path (x 0.6–1.6) measured solid from z 12.61 to 15.49. The notch is
the slot it slides down; with it, the only solid left in that path is *below* the
socket, where the socket never goes.

**The lid closes it.** A tab on the lid's underside, in the wall's own thickness,
drops into the notch — the rib cannot, because it sits *inside* the wall and the
notch *is* the wall. On the assembled model the end wall reads solid from z 12.80
up, with only the socket opening below it. The tab starts above the *opening's*
top rather than the notch's: for the obround the notch begins at mid-height, and a
tab following it down there would land on the socket.

Set `usb_overhang = 0` for a flush-mounted socket and the notch and the tab both
go away. An `assert` catches an overhang greater than the wall, which would put
the socket outside the case.

### The board drops when `pin_slot` is on

The board is carried on the header's plastic strip, and the strip lands on the
plinth tops. Switch `pin_slot` on and there may not *be* a plinth top under it:
if the channel is wider than the strip, the strip drops in and the whole board
goes with it — pins further into the pockets, board further from the lid, and
**the USB socket moves**.

The test is the channel against `strip_w`, the spacer's width:

| | USB `z` | Pin in pocket | Case height |
| --- | --- | --- | --- |
| no channel at all — `dupont_housing` **and** `pin_slot` off | 2.5 | 6.8 | 15.1 |
| `pin_slot_w = 0` (2.70 mm channel, under `strip_w`) | 2.5 | 6.8 | 15.1 — spacer bridges it |
| `pin_slot_w = 3` — **the default** | 1.3 | **8.0** | **15.1** |
| `pin_slot_w = 4` | 1.3 | **8.0** | **15.1** |
| `pin_slot_w = 4`, `pin_slot_depth = 1` | 1.5 | 7.8 | 15.1 |
| `pin_slot_w = 4`, `pin_slot_depth = 12` | 1.3 | 8.0 | 15.1 — capped |

The first row needs **both** off: `dupont_housing` forces `pin_slot` on, so
turning `pin_slot` off alone changes nothing while the surround is ticked.

**The test is `strip_w`, not the pitch.** The board rests on the plastic spacers
the pins pass through, about **3 mm** square on a devkit — wider than the 2.54
pitch this used to assume. A channel narrower than a spacer is bridged by it; one
that wide or wider swallows it:

| `pin_slot_w` | vs `strip_w` 3.0 | USB `z` | Case |
| --- | --- | --- | --- |
| 0 (2.70 mm channel) | bridged | 2.5 | 15.1 |
| 2.9 | bridged | 2.5 | 15.1 |
| **3.0 (default)** | **swallowed** | **1.3** | **15.1** |
| 4.0 | swallowed | 1.3 | 15.1 |

Measure your own spacers and set `strip_w` to match: at 3.5 the default channel
bridges again and the board does not move. The old assumption called a 2.6 mm
channel a drop when a 3 mm spacer bridges it.

The drop is capped at `pcb_standoff`, the spacer's *height*, so it is 1.2 mm and
not the full 3 mm of `pin_slot_depth`. Once the spacer has sunk, the board's underside rests on the plinth tops either
side of the channel — 26.86 mm of board against a 3 mm slot — so that is as far
as it goes. Raise `pcb_standoff` to your header's real spacer height and the drop
follows it.

The drop is capped by the **board**, not the channel: the strip sinks until the
board's own underside reaches the plinth top, so the cap is the strip's height,
`pcb_standoff`. A 12 mm channel drops exactly as far as a 3 mm one. Without that
cap a 3 mm channel put the board's top face *below* the floor and asked for a USB
opening at a negative height.

**`dupont_housing` follows exactly the same rule.** It forces `pin_slot` on, so
the board drops just as it would with the tick off and the channel set by hand:

| | Case height | USB `z` | Pin in trough |
| --- | --- | --- | --- |
| `pin_slot` on, 3 mm channel | 15.1 | 1.3 | 8.0 |
| `dupont_housing` on | 15.1 | 1.3 | 8.0 |

An earlier version suppressed the drop for the surround, reasoning that the
housings rise to the floor's top face and the strip lands on *them*. **A housed
Dupont is pushed up from below and held by friction on its pin, over a trough
open at the underside — it is not standing on anything.** It follows the board
down and cannot hold it up. A connector only pushes back on a sealed base, where
it bottoms out on the slab, and that has its own warning.

### Height

`cavity_h = 0` derives the interior height, taking the larger of what the board
needs and what the lid's rib needs to clear the wall openings:

```
cavity = max(board_top + max(component_h, usb_shell_h),   2.8 + 2.5       = 5.3  <- wins
             board_top + rib_h + 0.4)                     2.8 + 2.1 + 0.4 = 5.3
```

**The components set the height.** That is the point of notching the rib, and it
took three goes to get there:

| | Cavity | Case | Air over the components | Set by |
| --- | --- | --- | --- | --- |
| Groove in the wall, depth 4.0 | 10.0 | 19.0 | 4.1 | the joint |
| Rib inside the wall, `rib_h` 2.5 | 8.5 | 17.5 | 2.6 | the joint |
| Rib notched around the socket | 5.9 | 14.9 | 0.6 | the components |
| **Plus `rib_h` 2.1, socket in the stack** | **4.1** | **15.1** | **0** | **the components** |

**The socket counts as a component.** The cavity takes the larger of
`component_h`, which you measured, and `usb_shell_h`, which `usb_type` implies, so
a tall connector cannot be forgotten: USB-C's 3.2 mm shell against a
`component_h` of 2.5 gives a 6.0 cavity, not 5.3, and the lid does not close onto
the socket:

| `usb_type` | Shell | Cavity | Case |
| --- | --- | --- | --- |
| `micro` | 2.50 | 4.1 | 15.1 |
| `c` | 3.20 | 4.8 | 15.8 |
| `mini` | 4.00 | 5.6 | 16.6 |
| `a` | 5.70 | 7.3 | 18.3 |

The rib hangs around the perimeter and only overlaps the board at the USB end.
Cut it away over the socket's width and the tallest thing it has to miss is the
board's own top face — `board_top + rib_h` instead of `opening_top + rib_h`,
2.6 mm lower. The far-end opening is notched the same way.

So `rib_h` is free up to `component_h − 0.4` — **2.1** at the defaults, where it
now sits, so the joint costs no height at all:

| `rib_h` | 1.5 | 2.0 | **2.1** | 3.0 | 4.0 |
| --- | --- | --- | --- | --- | --- |
| Case height | 15.1 | 15.1 | **15.1** | 16.0 | 17.0 |

`component_h` is what moves the lid now: set it to your tallest part and the lid
comes down to meet it, with the console naming whichever term won.

**The pocket is the biggest single lever.** The floor is `pocket + hole_plate_t`
= 9.0 mm of the 15.1 mm total, half the case.

Set `cavity_h` to a number to pin it; an `assert` catches a value so low that an
opening runs up below the rib.

### Closure

The lid's plate lands on the top of the tray wall, and a **rib underneath it
drops inside the wall** to locate it. On its own that is a press fit: it aligns
the lid and grips by friction, but nothing holds it down.

> **There is no groove in the tray.** A slot milled into the wall top forced a
> thick wall — 1.2 mm of slot plus a 1.0 mm lip either side is 3.2 mm before you
> have a case at all — and **the socket sits against the inside of that wall, so
> every millimetre of it is a millimetre off the USB plug's insertion depth.** At
> 3.2 mm most micro leads never bottom out. Hanging the rib inside the wall asks
> nothing of the wall's thickness, so it dropped to **1.6 mm** and the plug got
> that reach back. From outside the joint looks the same.

**Ball latches** hold it down. Half-round bumps on the rib's *outer* face click
into dimples in the wall's inner face — outer, because there is no slot wall on
the inside to bite any more. The dimple still opens into the cavity, so nothing
shows outside.

`latch_grip` is the number that has to survive your printer. At 0.35 mm it is
0.87 of a 0.4 mm extrusion width — comfortably above dimensional noise. Below
about 0.25 mm it vanishes into tolerance and you get either no click or a
seized lid, varying print to print.

What the thin wall has to carry is the dimple. Measured, it bites **0.448 mm**
into the inner face and leaves **1.155 mm** of wall behind it — nearly three
perimeters. A warning fires below `wall` 1.25, where that drops under two.

| Value | What you get |
| --- | --- |
| `friction` | The press fit and its latches alone. Default. |
| `screw` | Adds four corner bosses for M2 self-tappers, `boss_d` to each side. |

There is no cantilever-snap option: on a lid that separates vertically a hook's
retention face is always downward-facing, and steepening it enough to print
cleanly makes it too weak to hold. A ball detent retains by interference instead.

### Lid

Vents sit in a patch over the radio module — the only part of a devkit that gets
meaningfully warm — rather than spread across the plate, which keeps the rest of
the lid solid and leaves room for the label. The patch defaults to **20 × 20 mm**,
positioned with `vent_from_end`, `vent_zone_l` and `vent_zone_w`. `vent_from_end`
is measured from the board's far edge, so the patch stays over the module whatever
the antenna bay is.

Vents are always cut from **artwork in an SVG**, named by `vent_file`. Two ship
with the model:

| File | What it is |
| --- | --- |
| [`slots.svg`](slots.svg) | Five plain bars across the patch. The default. |
| [`wifi.svg`](wifi.svg) | The wifi symbol |

`vent_rotate` turns the artwork on the lid, counter-clockwise as you look down at
the closed case. **Zero is not "as drawn"** — artwork is laid down a quarter turn
clockwise from how it sits in the file, which stands `slots.svg` bars up across
the case and puts `wifi.svg` dot-beside-the-label, so 0 is the orientation you
want. The turn is applied before scaling, so `vent_zone_l` always measures across
the finished orientation.

`vent_fit` either keeps the artwork's proportions (default) or stretches it to
fill the patch. With `aspect`, `vent_zone_w` is unused: the artwork is scaled to
`vent_zone_l` and its own proportions decide the height.

**Use SVG.** It imports as a true outline. A PNG can only be read as a heightmap
and thresholded at `vent_level`, which lands every edge on the pixel grid —
measured on a plain disc, the PNG route wobbled **0.75 mm on a 10 mm radius**
and used six times the triangles, where the SVG was exact to 0.000 mm.

Two things to know if you are drawing your own:

- **Fill, not stroke.** OpenSCAD imports filled areas and ignores stroke, so a
  stroked path comes in empty. It ignores fill *colour* too, which is a trap with
  screen icon sets: a light shape layered over a dark one has no colour to
  separate them once imported, so the two union and you get the outer silhouette
  with the detail gone. Detail only survives as a real hole in the path.
- **Keep the viewBox origin at 0 0.** OpenSCAD's `import(center = true)`
  mis-centres a negative viewBox origin — the first cut of `wifi.svg` landed
  off-centre until its viewBox started at the origin.

> ### A missing SVG fails quietly
>
> If `vent_file` cannot be found, OpenSCAD prints `ERROR: Can't open file` from
> `import()` and then **carries on and renders a lid with no vents at all**,
> reporting `Status: NoError` and exporting a valid STL. OpenSCAD cannot test for
> a file's existence, so no `assert` can catch it. The console line names the file
> the lid used; an unvented lid is the symptom.
>
> This is also why the Thingiverse and Printables customizers cannot render the
> lid. The tray, template and coupon are unaffected, as is the lid with
> `vents = false`.

## Every parameter

Generated from the `.scad` itself, so it cannot drift, and grouped as the
Customizer groups them. **Range** is the slider's own limits; where a value inside
them cannot be built, the model stops with a message naming the fix.

### Part

| Parameter | Default | Range | What it does |
| --- | --- | --- | --- |
| `part` | `"tray"` | 6 choices | Which part to render |
| `layout_gap` | `5` | 0 – 40 | Gap between parts in the print layout (mm) |

### Pin header

| Parameter | Default | Range | What it does |
| --- | --- | --- | --- |
| `pin_count` | `19` | 1 – 60 | Pins per row. Two rows, one down each long side. |
| `row_spacing` | `22.86` | 5 – 60 | Centre-to-centre between the two pin rows, across the width. 25.4 is the other common one. (mm) |
| `pin_x_offset` | `0` | -20 – 20 | Shift the whole header along the length. (mm) |

### Pin pitch / Dupont preset

| Parameter | Default | Range | What it does |
| --- | --- | --- | --- |
| `pin_pitch` | `2.54` | 3 choices | Pin pitch: centre to centre along the header. Sets the Dupont post size too. |
| `dupont_housing` | `true` | true / false | Size the openings for the connector's plastic surround, not the bare pin. |
| `hole_clearance` | `0.2` | 0 – 1.5 | Added to the post (or the surround) to get the hole. Raise if pins bind. (mm) |
| `pin_slot` | `true` | true / false | Replace the row of holes with one continuous channel down each pin row. |
| `pin_slot_w` | `3` | 0 – 10 | Pin channel width. 0 = as wide as a hole, which keeps the pins gripped. (mm) |
| `pin_slot_depth` | `3.0` | 0.5 – 12 | How far the pin channel cuts down from the floor's top face. (mm) |
| `wire_channel_w` | `1.2` | 0 – 3 | Wire channel width, sized for the wire. 0 is no channel at all. (mm) |

### Terminal recess

| Parameter | Default | Range | What it does |
| --- | --- | --- | --- |
| `seal_bottom` | `false` | true / false | Close the underside with a solid slab, so the base has no holes in it. |
| `terminal_recess` | `true` | true / false | Sink the connectors into troughs in the floor so they finish flush. |
| `terminal_len` | `6.0` | 1 – 25 | Trough depth: how much connector is buried. The rest shows below the case. (mm) |
| `hole_plate_t` | `1.0` | 0.6 – 4 | Material left above the trough, which the pin holes run through. (mm) |
| `pocket_wall` | `0.8` | 0 – 3 | Wall between one trough pocket and the next. This is what sizes them. (mm) |
| `floor_relief` | `true` | true / false | Thin the floor down the middle, leaving a plinth along each pin row. |
| `plinth_wall` | `1.2` | 0.4 – 5 | Material left each side of a trough. (mm) |

### Board

| Parameter | Default | Range | What it does |
| --- | --- | --- | --- |
| `board_l` | `0` | 0 – 200 | PCB length. 0 = derive from the header. (mm) |
| `board_w` | `0` | 0 – 200 | PCB width. 0 = derive from the header. (mm) |
| `board_end_margin` | `3.0` | 0 – 20 | Added each side of the header to get the auto PCB length (mm) |
| `board_side_margin` | `2` | 0 – 20 | Pin row centre to the board's long edge. Sets the auto PCB width. (mm) |
| `pcb_standoff` | `1.2` | 0 – 10 | The header spacer's height: a measurement of your header, not a lever. (mm) |
| `strip_w` | `3.0` | 0.5 – 12 | The header spacer's width across the row. MEASURE YOURS. (mm) |
| `pin_length` | `9.0` | 1 – 20 | Measured off the PCB: its underside down to the pin tip, spacer included. (mm) |
| `board_t` | `1.6` | 0.4 – 5 | PCB thickness. Only used to work out how tall the cavity has to be. (mm) |
| `component_h` | `2.5` | 1 – 40 | Tallest thing standing on top of the board, from its upper face. (mm) |

### Case size

| Parameter | Default | Range | What it does |
| --- | --- | --- | --- |
| `length_override` | `0` | 0 – 250 | Outer length. 0 = derive from the header. (mm) |
| `width_override` | `0` | 0 – 250 | Outer width. 0 = derive from the header. (mm) |
| `antenna_gap` | `6.0` | 0 – 30 | Clear air past the board's far edge, for the module's antenna. (mm) |
| `side_margin` | `5.8` | 2 – 30 | Pin row centre to the outer side face. One of two demands on the width. (mm) |
| `wall` | `1.6` | 1 – 6 | Wall thickness, and the reach a USB plug has to find past it. (mm) |
| `floor_solid` | `2.0` | 0.8 – 8 | Floor thickness away from the plinths, or the whole floor with no recess. (mm) |
| `lid_t` | `2.0` | 0.8 – 8 | Lid plate thickness (mm) |
| `cavity_h` | `0` | 0 – 60 | Interior height above the floor. 0 = derive it from what has to fit. (mm) |
| `corner_r` | `3.0` | 1 – 12 | Outer corner rounding (mm) |

### Closure

| Parameter | Default | Range | What it does |
| --- | --- | --- | --- |
| `closure` | `"friction"` | 2 choices | How the lid is held on |
| `rib_w` | `1.2` | 0.4 – 3 | Thickness of the rib under the lid that drops inside the wall. (mm) |
| `rib_h` | `2.1` | 0.5 – 6 | How far that rib hangs into the cavity. THIS SETS THE CASE HEIGHT. (mm) |
| `joint_clearance` | `0.15` | 0 – 0.6 | Clearance all round the joint. Raise if the lid is tight. (mm) |
| `screw_d` | `2.2` | 1 – 6 | Screw clearance hole in the lid, e.g. 2.2 for M2 (mm) |
| `screw_pilot_d` | `1.6` | 0.8 – 5 | Pilot hole in the boss, e.g. 1.6 for an M2 self-tapper (mm) |
| `boss_d` | `4.5` | 2 – 12 | Screw boss outer diameter (mm) |
| `latches` | `true` | true / false | Ball detents on the lid's rib, clicking into dimples in the wall. |
| `latch_count` | `2` | 0 – 6 | How many down each long side |
| `latch_grip` | `0.35` | 0.1 – 1 | How far the ball squeezes past the wall. This has to survive your printer. (mm) |
| `latch_fit` | `0.10` | 0 – 0.4 | Slack in the dimple so the ball seats. Comes off the lip, so keep it small. (mm) |

### Openings

| Parameter | Default | Range | What it does |
| --- | --- | --- | --- |
| `usb_opening` | `true` | true / false | Opening in the near end wall, for the USB socket |
| `usb_type` | `"micro"` | 5 choices | Which USB connector your board has. Sets the opening size and shape. |
| `usb_overhang` | `1.0` | 0 – 4 | How far the socket overhangs the board's edge. This is the plug's reach. (mm) |
| `usb_w` | `12` | 1 – 60 | Custom opening width, taken as the finished hole. Include your own fit. (mm) |
| `usb_h` | `6` | 1 – 40 | Custom opening height, taken as the finished hole. (mm) |
| `end_opening` | `false` | true / false | Opening in the far end wall |
| `end_w` | `8` | 1 – 60 | Far end opening width (mm) |
| `end_h` | `4` | 1 – 40 | Far end opening height. (mm) |
| `opening_z` | `0.5` | 0 – 30 | Height of the far end opening above the floor's top face. (mm) |

### Lid

| Parameter | Default | Range | What it does |
| --- | --- | --- | --- |
| `label` | `""` | — | Text engraved into the lid. Blank for none. |
| `label_size` | `6` | 2 – 20 | Label size (mm) |
| `label_depth` | `0.6` | 0.2 – 2 | How deep the label is engraved (mm) |
| `label_x` | `0` | 0 – 250 | Where the label sits along the length. 0 = auto, centred in the space left. (mm) |
| `label_rotate` | `0` | -180 – 180 | Turn the label. 0 is as you typed it. (degrees) |
| `vents` | `true` | true / false | Cut vent artwork through the lid, over the radio module. |
| `vent_from_end` | `15` | 0 – 80 | Centre of the vent patch, measured from the board's far edge. (mm) |
| `vent_zone_l` | `20` | 2 – 80 | Length of the vent patch, along the case (mm) |
| `vent_zone_w` | `20` | 2 – 60 | Width of the vent patch, across the case. (mm) |

### Vent artwork

| Parameter | Default | Range | What it does |
| --- | --- | --- | --- |
| `vent_fit` | `"aspect"` | 2 choices | How the artwork is scaled into the vent patch. |
| `vent_rotate` | `0` | -180 – 180 | Turn the vent artwork before it is cut. (degrees) |
| `vent_file` | `"slots.svg"` | — | Artwork file for the lid vents. It must sit beside this .scad. |
| `vent_format` | `"svg"` | 2 choices | Artwork format. SVG is a true outline; PNG is traced and wobbles. |
| `vent_level` | `50` | 0 – 100 | PNG only: brightness cut-off. Pixels brighter than this become openings. |
| `vent_invert` | `false` | true / false | PNG only: cut the dark parts instead of the light ones |

### Fit template

| Parameter | Default | Range | What it does |
| --- | --- | --- | --- |
| `template_t` | `1.2` | 0.4 – 4 | Floor thickness of the fit template. (mm) |
| `template_rim` | `3.0` | 0 – 15 | How high the fit template's wall stands. (mm) |

## Printing

**No supports needed.** Measured off the exported meshes, not assumed:

| Part | Surface below 45° | below 55° | below 60° |
| --- | --- | --- | --- |
| Tray | 38.9 mm² | 39.4 mm² | 40.0 mm² |
| Lid | 0.71 mm² | 1.14 mm² | 1.65 mm² |
| Template | 0.00 mm² | 0.00 mm² | 0.00 mm² |
| Coupon | 0.00 mm² | 0.00 mm² | 0.00 mm² |

The tray's 38.9 mm² is almost all the top edge of the USB opening — a 12 mm bridge
across the 3.2 mm wall, 38.4 mm², which every FDM printer spans without help. The
remaining 0.5 mm² is the four latch dimples.

The lid's 0.71 mm² is the four latch balls. A half-round bump has a small flat
patch at its lowest point: against a 45°-chamfered bead of the same size, the
bead is 0.00 mm² and the ball 0.58 mm² per pair. That is the price of a round
ball, and it bridges in a couple of layers.

Otherwise the lid has nothing to bridge. `label` defaults to blank, and the
engraving is the only overhang on it: set one and you get the ceiling of the
lettering, 0.6 mm above the bed — about 32 mm² for `"ESP"` — bridged over a
glyph's width in the first two layers. The vent openings are cut clean through
and never overhang, whatever artwork you use.

Three features exist specifically to keep this true:

- **The troughs are square, and their ceilings bridge.** This is the one place the
  tray has real flat downward area — 255 mm², two strips 3 mm wide running the
  length of the header. It is a *bridge*, not an overhang: the trough is anchored
  on both walls, so the slicer spans the 3 mm direction, which needs no support at
  a 0.4 mm nozzle. It is also why there are two narrow troughs rather than one
  full-width recess — 3 mm bridges, a 28 mm floor would not.

  A 65° ridge used to roof them to avoid even that. It was never a span, and
  what the ridge actually did was taper the trough to nothing at the plate, so a
  connector could not reach the pin.
- **The holes are plain bores**, vertical top to bottom, so they cannot overhang
  at all. Removing the old upward-facing funnel left the downward-facing area
  unchanged at 38.9 / 38.9 / 38.6 mm² for 45 / 55 / 60° — which is how you can
  tell the chamfer carried no printability weight.
- **The floor relief is cut downward out of the cavity**, so every face it makes
  is vertical or upward-facing, and it spares a pillar under each screw boss so
  nothing stands on air. Measured across 19 configurations — plinths merging,
  rests removed, oversized bosses, no antenna bay — the tray never rises above
  28.8 mm².

A label is engraved into the face that lies on the bed, so it appears as a shallow
recess in the first layers. `label_rotate` turns it, counter-clockwise as you look
down at the closed case; −90 stands it on its side reading down the case. Unlike
the vents there is no quarter turn built in — 0 is as you typed it.

Turning it costs room: upright the label has the length of the case to fill, on
its side only the width. The model warns when it looks too big:

```
WARNING: the label looks too big for the lid — roughly 6 x 51 mm against an
interior of 57.72 x 31.26, so it will run off the edge.
```

That figure is estimated, not measured: OpenSCAD's `textmetrics()` is an
experimental builtin, off by default, that returns `undef`. The estimate agreed
with all five measured cases (76.5 mm predicted against 76.57 on the worst), but
it is a smoke alarm, not a specification.

## License

**CC BY 4.0** — Copyright (c) 2026 markus1234. See [LICENSE](LICENSE).

You may share, adapt, remix and sell this design, including commercially,
provided you credit markus1234, link to the license, and say what you changed.

This covers **the model** — [`esp-enclosure.scad`](esp-enclosure.scad),
[`wifi.svg`](wifi.svg) and this documentation — which is an original design,
written from scratch. It does **not** cover `esphome.svg`, which came from
somewhere else and keeps its own license. See below.

## Third-party assets

### `esphome.svg`

The ESPHome logo, from [dashboard-icons](https://github.com/homarr-labs/dashboard-icons)
by Homarr Labs, obtained via [dashboardicons.com](https://dashboardicons.com/icons/esphome).

- **License:** Apache License 2.0 — Copyright (c) 2024 Bjorn Lammers, Meier
  Lukas, Thomas Camlong and Homarr Labs. The full text ships with this
  repository as
  [licenses/dashboard-icons-Apache-2.0.txt](licenses/dashboard-icons-Apache-2.0.txt).
  It is kept out of the repository root deliberately: GitHub scans root-level
  `LICENSE*` files to label the repo, and a second one there made it report the
  whole project as Apache-2.0.
- **Modified:** yes. The original draws the mark as two overlapping paths
  distinguished only by fill colour — a house shape with a lighter waveform on
  top of it. OpenSCAD's SVG import ignores fill, so the two paths union and the
  waveform vanishes, leaving a plain silhouette. The file here was flattened to
  a single path with the waveform as a true hole, so the mark survives import
  as geometry.
- **Not under CC BY 4.0.** Apache 2.0 and CC BY 4.0 are different licenses, and
  this file keeps its own.

**Trademark.** Apache 2.0 section 6 grants no rights in trade names or
trademarks, and a license to the artwork is not a license to the mark it
depicts. ESPHome and its logo belong to their owners. This project is not
affiliated with, sponsored by or endorsed by ESPHome or the Open Home
Foundation, and including the logo is not a claim otherwise.

Nothing renders the logo unless you ask for it: `vent_style` defaults to
`slots`, and `vent_file` to `wifi.svg`. If you would rather the file were not
in your copy at all, delete `esphome.svg` — the model does not reference it.

> Not legal advice. If you redistribute this, check the terms yourself.
