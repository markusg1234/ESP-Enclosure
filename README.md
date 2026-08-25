# ESP-Enclosure

A parametric ESP devkit enclosure for OpenSCAD, with the header broken out
through the floor.

The board sits hard against the inside of the USB end wall so its socket lines
up with the opening, carried and located by its own header pins. Those pins drop
through a thin hole plate into a pocket under each one, and Dupont connectors
push up into those pockets from below — so the connectors finish **flush with the floor**
instead of hanging out of the case, and the wires leave straight down through
the open underside. Past the far edge of the board is a clear bay for the radio
module's onboard antenna.

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

Print the `tray` and the `lid` — but print the two check parts first. Together
they are 3.9 cm³ against the tray's 8.6, and they cover the two ways a full
case goes wrong: the `template` says whether your board fits, the `coupon` says
whether your pins grip.

### Print the template first

Set `part = "template"`. It is a shallow stand-in for the tray — same footprint,
same interior outline, same pin holes in the same places, same screw bosses —
but 4.2mm tall instead of 12.9, and 3.3 cm³ of plastic against the tray's 8.6.

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

| Parameter | Default | What it does |
| --- | --- | --- |
| `template_t` | 1.2 | Floor thickness. Two or three layers is plenty. |
| `template_rim` | 3.0 | Wall height. Enough to catch the board's edges. |

### Print the coupon too

Set `part = "coupon"`. A few minutes and five layers, and it reproduces the real
hole plate at its real thickness — **everything cut at the size the model is
currently set to.** It is not a clearance sweep: there are no trial sizes and
nothing to label, because every hole is the hole your case will have.

```
   PIN ROW    [] [] [] [] []      5 holes on the PITCH
   DUPONT     [===========]       5 on the pitch, merged into one slot
```

**13.60 × 10.86 × 1.0 mm** — deliberately tiny, so you can put it straight over
five of your header's pins without the body fouling the neighbours.

**It is there to check the pitch.** You pick a preset, print this, and push
your module's pins through the row. If they go in, the
pitch you set is the pitch your header actually is. That is why the engraved
number is the **pitch** — 2.54, 2.00, 1.27 — and not the hole size: the hole
size is not what you are trying to find out.

**Its length is set by the pins either side of the run**, not by the rows. Those
two neighbours get **0.50 mm** of real clearance — a printer moves an edge a
tenth either way between elephant's foot, extrusion width and shrinkage, so a
coupon sized to *just touch* fouls in practice. Sizing it from the Dupont row
instead gave 0.01 mm, which is not clearance at all.

| | Measured |
| --- | --- |
| Pin holes | 5 × **1.000 mm**, centre-to-centre **2.54 exactly**, 1.22 mm to each end |
| Neighbouring pins | clear by **0.50 mm** each side |
| Dupont slot | one opening, **12.000 mm**, 0.80 mm rim each end |
| Depth | stacked at the floor: 0.80 rim / slot / 1.60 / pin holes / label / rim |

The Dupont slot's ends carry less material than the pin row's (0.80 against
1.22) and that is deliberate — the Dupont row is tested with the coupon **off**
the board, held in the hand while connectors are pushed in. Only the pin row is
placed over a live header, so only its end material and side clearance have to
be right.

**The Dupont row is a slot, and that is correct.** Five surround openings on the
pitch is 2.86 on 2.54, so they overlap by 0.32 and run together — exactly as
they do in the tray, where `dupont_housing` merges the row for the same reason.
It is *cut* as one slot rather than five touching cubes, because cutting them
individually at a spacing equal to their own size butts one cut onto the next,
which is how this model makes non-manifold edges and a negative genus. Only when
the opening is narrower than the pitch do five separate holes appear.

The pin row is sized from the **bare post**, not from `hole`, so it still reports
what a bare pin meets. Sized from `hole` it would cut 2.86 mm openings with the
surround on and call that a pin fit, with 1.11 mm of air around a 0.64 mm pin.

The Dupont row only appears with `dupont_housing` on, because only then does the
tray have a surround-sized opening to reproduce.

If it does not fit the way you want, change `hole_clearance` and reprint — it is
five layers.

The coupon and the template cut their holes with the same `plate_hole` module
the tray does, so neither can drift from what the case will actually give you.

**The holes are plain square bores** — `hole` across at the top, at the bottom
and everywhere between. There is no lead-in chamfer and nothing to set for one.

That is what makes the coupon trustworthy, and it replaced a rule rather than
adding one. A funnel is cut downward from the top face, so a funnel deeper than
the plate broke out of the underside and the hole's narrowest point stopped
being the size you asked for — and the coupon, being the plate at its thinnest,
failed that first, exactly backwards for the part whose job is reporting the
real fit. It needed a cap at half the plate thickness to stay honest. Before
that there was a `lead_angle` defaulting to 65°, which cut 1.07 mm into a
1.00 mm coupon and reported holes 0.1 mm oversize, two whole steps of the
coupon's own scale. A straight bore cannot do any of it.

Losing the funnel costs less than it sounds like, because **the hole is a
clearance hole by construction** — whatever has to pass through it plus
`hole_clearance`, so it is already wider than that thing before anything is
chamfered. Against the bare post, which is the default:

| Preset | Post | Hole | Gap per side | |
| --- | --- | --- | --- | --- |
| 2.54mm standard | 0.64 | 1.00 | 0.18 | hole 56% wider than the pin |
| 2.00mm compact | 0.50 | 0.86 | 0.18 | 72% wider |
| 1.27mm micro | 0.40 | 0.76 | 0.18 | 90% wider |

A pin was never being pressed into an interference fit that a funnel had to open
up. The funnel only helped a pin *find* a hole it already fitted, and what does
the finding is the pitch, which the header and the plate share.

The exception is `hole_clearance = 0`, which the slider allows: the hole is then
exactly the post, printing shrinks it slightly, and there is no chamfer left to
disguise it. Below 0.1 you get a console warning pointing you at this coupon.

Tick [`dupont_housing`](#the-plastic-surround) and the same 0.18 mm each side is
measured off the connector's **plastic surround** instead, which is most of a
pitch to begin with — so the proportions above stop applying, and the coupon
starts reporting the fit of a housed connector rather than a bare pin.

### Check your pin length

This is the one thing most likely to catch you out. For a connector to grip, the
pin has to clear the standoff *and* the hole plate and still have 2–4mm left
over. The model works this out and prints it to the console:

```
ECHO: "Case 60.92 x 34.46 x 14.3 mm | header 19 x2 @ 2.54 | 1 mm holes,
1.54 mm of plate between them | 1 mm wire channels, 1.54 mm rib (from the pin)
| 3.8 mm of pin inside the trough | board gap 1.2 mm each side / 6 mm at the
far end | USB micro 8.1 x 3.1 at 2.5 above the floor | antenna bay 6 mm |
vents from slots.svg"
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

### Pin header

| Parameter | Default | What it does |
| --- | --- | --- |
| `pin_count` | 19 | Pins per row. Two rows, one down each long side. |
| `row_spacing` | 22.86 | Centre-to-centre between the rows. 25.4 is the other common one. |
| `pin_x_offset` | 0 | Slide the header along the length. |

### Board

| Parameter | Default | What it does |
| --- | --- | --- |
| `board_l` / `board_w` | 0 | PCB size. 0 = derive from the header. |
| `board_end_margin` | 3.0 | Header end pin to the board's edge. Sets where the header sits. |
| `board_side_margin` | 3 | Row centre to the board's long edge. Sets the auto `board_w`. |
| `pcb_standoff` | 1.2 | How far the board sits above the floor — the spacer's **height**. |
| `strip_w` | 3.0 | The spacer's **width** across the row. Decides whether the pin channel drops the board. **Measure yours.** |
| `board_t` | 1.6 | PCB thickness. Only feeds the cavity height. |
| `component_h` | 2.5 | Tallest thing on TOP of the board — the radio can. Rarely binds; see Height. |

> **There is no `board_clearance`.** It measured the board's edge to the
> interior wall — the same span as `side_margin` minus `board_side_margin` minus
> `wall`. Three parameters for two distances, and only ever one of them live:
> below `side_margin` 4.6 the board chain set the width and `side_margin` did
> nothing; above it, the reverse. `side_margin` survived because it is the
> distance the troughs and pin holes are actually checked against, and because
> keeping it leaves the default case the size it has always been.

The gap between board and wall is now **derived, not requested**. You place the
wall with `side_margin` and the board's edge with `board_side_margin`, and the
gap is what is left over:

```
gap each side = side_margin - board_side_margin - wall
              = 5.8 - 3 - 1.6 = 1.2 at the defaults
```

The console prints it, and warns if it falls below 0.2 mm — half an extrusion
width, under which the board has to be forced rather than dropped in. Raising
`board_side_margin` past `side_margin - wall` (4.2 at the defaults) makes the
board itself set the width, and then the gap is zero and you get that warning;
raise `side_margin` to match. Along the length the room comes from `antenna_gap`
alone, so `antenna_gap = 0` is a press fit lengthwise and warns too. The USB end
is flush by design and has no gap on purpose — clearance there would push the
socket off its opening.

> **There are no rest pads.** The tray used to stand four blocks in the board's
> corners, sized by `ledge_d` and `ledge_w`, to stop it rocking. They are gone,
> and so are both parameters. The header pins carry and locate the board and the
> pockets grip the pins, which is what the pads were riding on anyway — the
> README already said "the header pins carry and locate the board, so the rests
> only have to stop it rocking." Removing them took **211 mm³** of plastic out of
> the tray and changed nothing else: same genus, same downward-facing area.

**`pcb_standoff` is the header's plastic strip**, and that is exactly why the
pads are not needed: the board already sits on the strip its pins are moulded
into, and the strip sits on the plinth tops. The case does not set this and does
not need to — measure the strip on your own header. A standard 2.54 mm one is
about 2.5 mm.

It is not free, though. Every millimetre comes straight off the grip, because
`pin_length − pcb_standoff − hole_plate_t` is all a crimp terminal gets:

| `pcb_standoff` | Pin in the pocket | Case height |
| --- | --- | --- |
| 0 | 5.0 | 13.1 |
| 1.2 (default) | 3.8 | 14.3 |
| 2.5 (a real strip) | 2.5 | 15.6 |
| 3.0 | 2.0 | 16.1 |

It moves the case height 1:1 as well, because the USB opening is flush-mounted
and therefore positioned from the board — lift the board and the socket, the
opening and the lid all go with it. (That was not true when the opening was a
generous rectangle down at a fixed `opening_z`; it is now.)

So a thicker strip costs you twice: grip *and* height. At a real 2.5 mm strip you
are at 2.5 mm of grip, the bottom of the 2–4 mm a crimp wants — a `pin_length`
problem more than a case one.

### Dupont preset / pin pitch

**`dupont_preset` is the pin pitch.** There is no separate `pin_pitch` setting:
the three Dupont families each carry their own pitch, so picking the family
picks it. It sets the post size with it, and `hole_clearance` is added on top.

| Preset | Pitch | Post | Hole at default clearance |
| --- | --- | --- | --- |
| 2.54mm standard | 2.54 | 0.64 | 1.00 |
| 2.00mm compact | 2.00 | 0.50 | 0.86 |
| 1.27mm micro | 1.27 | 0.40 | 0.76 |

> **There is no `Custom` any more**, and no `pin_pitch` or `custom_post` to feed
> it. All three only did anything at *one* of the four dropdown values and sat
> inert at the other three — a pitch slider that moves nothing is the broken
> slider this model keeps removing. It bit hardest on the fit coupon, which
> exists to check the pitch: you would reach for `pin_pitch`, nothing would
> move, and the coupon looked broken when it was not. An `assert` now catches
> any `dupont_preset` that is not one of the three.

Look at the last two columns together. The plate left standing *between* one
hole and the next is pitch − hole: 1.54 mm at 2.54 pitch, 1.14 mm at 2.00, and
**0.51 mm at 1.27** — thinner than a single 0.4 mm extrusion. The micro preset
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
| 2.54mm standard | 2.54 | 2.50 | 2.86 |
| 2.00mm compact | 2.00 | 1.96 | 2.32 |
| 1.27mm micro | 1.27 | 1.23 | 1.59 |

#### It merges the row, and that is not a choice

Read the last two columns together again. The opening is **wider than the
pitch** — 2.86 against 2.54 — so the plate between one hole and the next is
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
quiet. Nothing is renamed and nothing is lost — untick it and both are live
again exactly as they were.

**`wire_channels` is not on that list, and that is the point.** A wire channel
is sized to the **pin**, never to the surround: what travels along it is a wire
coming off a pin, while the connector arrives from below and goes *up* through
the plate. So it stays 1.00 mm at the 2.54 preset with 1.54 mm of rib between
channels — identical with the tick on or off — and it is a live setting either
way. Sizing it to the surround instead would have asked for 2.86 mm on a
2.54 pitch, merged every channel into one slot down the row, and taken the
whole inboard plinth wall with it.

#### `terminal_len` decides how much housing shows

The tick sizes the trough **across** but not **down**. `terminal_len` is the
trough's depth, so it is the control for how much of the connector is buried and
how much shows below the case — and **there is no warning about it**, because
leaving some proud is a legitimate thing to want. A housing sticking out is
easier to grip and unplug, and it costs no case height.

Every millimetre you bury is a millimetre of case, and that is the whole trade:

| `terminal_len` | Case height | A ~15 mm housing then shows |
| --- | --- | --- |
| 3 | 12.1 | 12.0 |
| **6 (default)** | **13.1** | **9.0** |
| 10 | 17.1 | 5.0 |
| 15 | 22.1 | 0.0 — flush underneath |

Pick the row you want. How long your housings actually are is a measurement only
you have, so the model does not guess at it or tell you off for it.

**The tick itself costs no height at all.** At the same `terminal_len` the case
is the same either way — the surround only widens cuts that already existed.

### Pin channel

`pin_slot` replaces the whole row of square holes with **one continuous
channel** running the length of the header. The pins still drop through it into
the trough and the terminals still push up from below; what goes away is the rib
between one hole and the next.

| Parameter | Default | What it does |
| --- | --- | --- |
| `pin_slot` | **true** | On by default. Off = a hole per pin, exactly as before. |
| `pin_slot_w` | 3 | Channel width. 0 = as wide as a hole, which keeps the fit. |
| `pin_slot_depth` | 3.0 | How far it cuts down from the floor's top face. |

`pin_slot_w` defaults to **3** — a clearance channel, wider than the 2.54 pitch,
so the header's strip drops into it and [the board goes down with it](#the-board-drops-when-pin_slot-is-on)
by 1.2 mm.

Set it to **0** instead and the channel is exactly as wide as a hole: the pins
stay gripped across the row as separate holes did, the coupon's reading stays
meaningful, and the board does not move, because the drop only happens once the
channel is wider than the strip.

`dupont_housing` forces `pin_slot` on for the same reason at any pitch: a
plastic surround leaves no rib between one hole and the next either. It also
holds `pin_slot_w` at or above the opening, since a channel narrower than the
surround is not one the surround goes through.

```
  PLAN, pin_slot = false        PLAN, pin_slot = true
  +----------------------+      +----------------------+
  |  []  []  []  []  []  |      |  +----------------+  |
  |                      |      |  |                |  |   one channel,
  |  []  []  []  []  []  |      |  +----------------+  |   pin_slot_w wide
  +----------------------+      +----------------------+
     0.51mm of plate                no ribs to lose
     between holes at
     1.27 pitch

  SECTION across the row, defaults (4 mm channel, 3 mm deep)

        |<------- 4.00 -------->|        channel, cut down from the floor top
    ####|                       |####
    ####+-----+           +-----+####    <- 1.07 solid each side: floor, not
    ######### |           | #########       a way through, and facing UP
    ###########\  1.87   /###########    <- the opening that reaches the trough
    ##########  \       /  ##########
    ##########  [ trough  ]  #########
```

Two things follow from the defaults, and the console prints both with your own
numbers rather than leaving you to work them out:

- **4 mm is clearance, not a fit.** At `pin_slot_w = 4` a 0.64 mm pin has three
  millimetres of air around it. The pins are located in neither direction, so
  the board is held by its pins and the walls alone, and **the coupon no longer
  describes the part** — it still measures a hole. Set `pin_slot_w = 0` to make
  the channel exactly as wide as a hole was; then the grip across the row is
  unchanged and the coupon means what it always did.
- **A channel wider than the pocket is a wide slot over a narrower hole.** At
  4 mm over a 1.74 mm pocket, the 1.13 mm each side is the top of solid plinth —
  it prints fine, facing up rather than down, but it is floor, not passage.
  Lowering `pin_slot_w` to the pocket size matches them up.

`pin_slot_depth` only has to get through the hole plate — 1.0 mm at the defaults.
Below that the channel stops inside the plate and opens into nothing, so it is
clamped up rather than rejected. Past the plate the trough is square and full
width all the way down, so extra depth just removes more plinth.

That used to be considerably worse. With the ridged roof, opening the full width
took *both* a deeper channel and a wider trough, and widening the trough alone
did nothing: a wider trough was a proportionally taller one, so a channel cut the
same distance down landed at the same fraction along the slope. A 3.0 and a 4.2
trough both gave a 1.865 mm opening at `pin_slot_depth = 3`. Square pockets
removed that entire interaction.

Separately, a 4 mm channel down a 5.4 mm plinth leaves only 0.70 mm of wall each
side, under two 0.4 mm perimeters — lower `pin_slot_w`, or raise `plinth_wall`,
since the plinth is now `pocket + 2 * plinth_wall`.

The template follows the tray: switch the channel on and the template gets one
too. It has to — at the pitch that makes the channel worth having, a template
full of separate holes is exactly as unprintable as the tray would have been.
The coupon does not follow either, because its job is to report a hole size, and
its pin row deliberately stays a row of holes on the pitch — that is the thing
you push a header into.

`wire_channels` is unchanged and still needs a rib between one channel and the
next, so at 1.27 pitch it has to be off — `pin_slot` does not rescue it, since
those channels run *across* the plate rather than along it.

### Terminal recess

| Parameter | Default | What it does |
| --- | --- | --- |
| `seal_bottom` | false | Cap the troughs so the base has no holes. Nothing else changes. |
| `terminal_recess` | true | Sink the connectors into the floor. Off = plain through-holes. |
| `terminal_len` | 6.0 | Trough depth — how much of the connector is buried. The rest shows below the case. |
| `pocket_wall` | 0.8 | Wall between pockets. Sizes them: `pitch - pocket_wall`, square. Held at 0 by `dupont_housing`. |
| `hole_plate_t` | 1.0 | Material above the pocket. Thinner leaves more pin to grip. |
| `pin_length` | 6.0 | How far the **header pin** protrudes below the PCB. **Measure this.** |
| `floor_relief` | true | Thin the floor everywhere the pockets do not run. |
| `plinth_wall` | 1.2 | Material each side of a pocket, which sets the plinth width. |

**The pocket takes whichever of two demands is larger.** The "terminal" is the
Dupont crimp terminal — the metal socket that crimps to a wire and pushes onto a
pin — and burying it is the whole reason the pocket exists. But the pin's own
tail has to fit in there too, or it comes out of the underside and the case rocks
on it:

```
pocket = max(terminal_len,  pin_length − pcb_standoff − hole_plate_t)
       = max(6.0,           6.0 − 1.2 − 1.0 = 3.8)          =  6.0
floor  = pocket + hole_plate_t                              =  7.0
```

They are not two names for one thing — a longer pin does not make a connector
bigger — but they both land on this one dimension, so it takes the larger. That
is what makes `pin_length` change the case at all:

| `pin_length` | 3 | 6 | 8.2 | 9 | 12 | 16 |
| --- | --- | --- | --- | --- | --- | --- |
| Pocket | 6.0 | 6.0 | 6.0 | 6.8 | 9.8 | 13.8 |
| Case height | 14.3 | 14.3 | 14.3 | 15.1 | 18.1 | 22.1 |

It only ever *grows* the case. Cutting the pins short does not shrink it, because
the connector still needs its room — lower `terminal_len` as well. **Soldering
straight to the board?** Set `terminal_recess = false`: no connector to bury and
no tail to swallow, so the floor drops to `floor_solid` and the case loses 5 mm.

`pin_length` is also checked at both ends. Below `pcb_standoff + plate_t` it is an
error — the pin never leaves the plate, so a terminal has nothing to grip. With
the recess *off*, where the pocket cannot grow to help, a long tail still gets a
warning: `pin_length = 6` there stands 2.8 mm proud of the underside.

**There is one square pocket per pin, not a slot.** Each runs straight from the
case underside up to the hole plate, the same size in both directions:

```
  UNDERSIDE, along a row              PLAN, one pocket

   ___     ___     ___     ___         |<-1.74->|
  |   |   |   |   |   |   |   |         ________
  |___|   |___|   |___|   |___|        |        |  1.74   square: the pitch
      0.8     0.8     0.8              |        |         sizes both sides
   1.74    1.74    1.74                |________|
  |<------ 2.54 pitch ------>|
```

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
| 3.0 | 1.00 | Clamped to the hole, divider 1.54 |

There is no `trough_w`. It used to set the pocket across the row while
`pocket_wall` set it along, which made the pockets rectangles — and across the
row a pocket has no reason to be anything other than what the pitch allows along
it. One number, one shape.

The one thing it will not let you do is go below the hole above it — a pocket
narrower than its own hole would choke the pin it exists to receive. At the 1.27
micro preset, and at any `pocket_wall` past about 1.5, that clamp bites: the
divider comes out thicker than you asked and the console says so rather than
silently obeying.

And **at 2.54 pitch, separate pockets and full-width crimp terminals are mutually
exclusive.** A Dupont crimp terminal is roughly 2.4 mm across; a pocket with
printable dividers is 1.74. `pocket_wall = 0` is there for exactly that case —
and [`dupont_housing`](#the-plastic-surround) is the same trade made for you,
one step further out, for a terminal still wearing its plastic.

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

The troughs are the only thing that opens through the bottom of the case — the
pin holes stop at the trough, and the relieved floor is already solid.
`seal_bottom = true` puts a slab of `floor_solid` under them, so the base has no
holes in it at all.

**Nothing else changes.** The pin holes, the troughs, the plinths, the wire
channels all stay exactly as they are. The pockets simply become
blind pockets — which is where the pin tails then sit, so a sealed base also
takes away any question of the tails fouling anything. The case grows by the
thickness of the slab.

```
        open (default)                sealed
   ####|####|####  hole plate    ####|####|####
   ##[  trough  ]##              ##[  trough  ]##  <- pin tails sit here
   ##|          |##              ##|          |##
   --+          +--  OPEN        ################  <- floor_solid slab
      underside                     closed

   height 14.30 mm               height 16.30 mm
```

| | Default | Sealed |
| --- | --- | --- |
| Case height | 14.30 mm | 16.30 mm (+`floor_solid`) |
| Underside over a trough | open | **solid 2.00 mm** |
| Pin into the trough | 3.8 mm | 3.8 mm — unchanged |
| Rests | 2.3 / 2.3 mm | unchanged |
| Genus | 39 | 37 |

Genus 37 is the arithmetic working out: each trough becomes one blind pocket
reached by 19 hole-and-channel openings, which is 18 handles apiece, plus the
USB opening. Turn the USB opening off and it is exactly 36.

You cannot fit a crimp terminal into a sealed trough, so the model stops
reporting terminal grip when the base is closed. It warns instead if the pins
are longer than the pocket is deep:

```
WARNING: the pins reach 9.8 mm into a sealed trough only 6 mm deep, so they
will bottom out and lift the board 3.8 mm. Raise terminal_len, or trim the
pins and lower pin_length.
```

### Only the connectors get a thick floor

That floor is 7.0mm at the defaults — the trough's **depth** plus the hole
plate, `max(terminal_len, pin tail) + hole_plate_t` = 6.0 + 1.0, and nothing
else. (Not `pocket`, which is the trough's *width*, 1.74.) But only the two
strips carrying the troughs need to be that thick. So with
`floor_relief` on, the rest drops to `floor_solid` and each pin row keeps a
**raised plinth**, `pocket + 2 * plinth_wall` wide, just enough for the
connector.

```
        relief off                  relief on (default)
  |=========|  <- PCB           |=========|  <- PCB, same height
  |         |  cavity           |         |  cavity
  |#########|                   |##|   |##|  <- plinths, 5.4mm wide
  |#########|  7.0mm floor      |__|___|__|  <- 2.0mm floor
```

The plinth tops sit exactly where the old floor top was, so the PCB seat, the
rests and the lid are all unaffected — it is purely plastic removed.

The plinths are clipped to the interior, so when a row sits close enough to a
side wall its plinth merges into that wall rather than leaving an unprintably
narrow gap beside it. **That does not happen at the defaults** — there the
relief comes out as three separate regions, measured across the width at
`z = 5`:

| Region | Span in Y | Width |
| --- | --- | --- |
| Outboard of row A | 1.60 → 3.73 | 2.13 |
| The bay between the rows | 7.87 → 26.59 | **18.72** |
| Outboard of row B | 30.73 → 32.86 | 2.13 |

with the two plinths standing 4.14 mm wide (`pocket + 2 × plinth_wall`) between
them. The central bay is where most of the plastic goes, but the outboard
strips are real relief too. Move a row out toward a wall — a smaller
`side_margin` — and its outboard strip is what closes up first.

### Wire channels

Every pin hole has a channel beside it, so you can take a wire off a pin and
bring it **into the box** rather than down through the underside — for wiring a
sensor or a display to a GPIO inside the case.

| Parameter | Default | What it does |
| --- | --- | --- |
| `wire_channels` | true | On or off. |
| `wire_channel_w` | 0 | Channel width. 0 = the pin's own hole, which is what it has always been. |

**The channel is exactly as wide as the PIN hole**, and that is not adjustable.
The Dupont preset already decided that number, so the channel just continues the
hole sideways at the same width:

| Preset | Hole | Channel | Rib between them |
| --- | --- | --- | --- |
| 2.54mm standard | 1.00 | 1.00 | 1.54 |
| 2.00mm compact | 0.86 | 0.86 | 1.14 |
| 1.27mm micro | 0.76 | 0.76 | 0.51 — too thin; narrow it with `wire_channel_w` |

```
  PLAN                                    SECTION
                                              ______  PCB
  +----------------------+                    1.2mm
  |   ||   ||   ||   ||  |   <- one       ####|####|####  plinth
  |   ||   ||   ||   ||  |      width,    ####|    |###\_ breaks out
  |   ||   ||   ||   ||  |      hole to   ####|    |####
  |  (__)(__)(__)(__)(_) |      plinth    ##[ trough ]##
  +----------------------+      face      ##############  floor
      1.54mm rib between
```

**The plastic surround does not change any of this.** `dupont_housing` widens
the way *in* for the connector, which arrives from below and goes up through the
plate; a wire channel is the way *out* for a wire coming off a pin, and a wire
does not care how bulky the housing on the other side of the plate is. So the
channel stays sized to the post plus `hole_clearance` — the numbers in the table
above hold with the tick on or off, and the two features are independent.
Verified: with the surround on, the plate sections into 19 gaps of exactly
1.000 mm per row, not the 2.86 mm the opening became.

That equality is the reason it is the **default** rather than a number you have
to pick. The rib between two channels is the same `pitch - hole` as the rib
between two holes whenever the holes are the pin's too, so at `wire_channel_w = 0`
the channels impose **no printability constraint the holes did not already
impose** — anything that fits the holes fits the channels.

#### Setting the width

`wire_channel_w` overrides it. It is **one** setting, not the four it used to be
(`slot_w`, `slot_neck`, `wire_w`, `slot_depth`) describing a keyhole with a neck,
a wider section and its own length, each of which could be set to something that
quietly broke the channel or merged it into its neighbour.

**The useful direction is usually down.** The channel carries a wire, and a
jumper's insulation is well under a millimetre, so narrowing it buys back rib —
which is the whole problem at a fine pitch:

| Preset | Derived (0) | Rib | Max before rib < 0.8 | Narrow to 0.45 → rib |
| --- | --- | --- | --- | --- |
| 2.54mm standard | 1.00 | 1.54 | 1.74 | 2.09 |
| 2.00mm compact | 0.86 | 1.14 | 1.20 | 1.55 |
| 1.27mm micro | 0.76 | **0.51 — rejected** | 0.47 | **0.82 — works** |

At the micro preset wire channels were impossible at any setting; the derived
0.76 leaves 0.51 mm of plate and the rib check rejects it. `wire_channel_w =
0.45` leaves 0.82 and renders. **This is the setting that makes wire channels
possible at 1.27 at all.**

#### Widening, and where the channels merge

The whole slider is live — there is **no upper clamp**, and that is deliberate.
Capping it at `pitch − 0.8` left the top third of the travel doing nothing,
which is the same broken slider as one that asserts, only quieter.

Past the pitch the channels **merge** into one continuous slot down each row,
the way `pin_slot` merges the holes and `pocket_wall = 0` merges the pockets.
That is a real part — a full-length wire exit — not an error to prevent. At
2.54 pitch:

| `wire_channel_w` | What you get | Rib |
| --- | --- | --- |
| under 0.4 | raised to 0.4 — a slot narrower than the nozzle is not a slot | 2.14 |
| 0.4 → 1.74 | separate channels, printable ribs | 0.80 → 2.14 |
| 1.74 → 2.54 | separate channels, **thin ribs — warned** | 0.00 → 0.80 |
| 2.54 and over | **merged**, one slot per row | none |

The middle band warns rather than clamps, exactly as `pocket_wall`'s own
too-thin dividers do: it prints, it is just fragile, and how fragile depends on
a nozzle the model cannot know. The merged band prints a note — it gives up the
last thing locating the header along the row, so the board's fit against the
walls is what holds it.

The rib `assert` now guards only the **derived** width. With an explicit
`wire_channel_w` you have stated an intention and the model reports the
consequence instead of refusing; at 0 there is no intention to honour, just a
default that does not fit, so it still stops and names the lever.

Measured by sectioning the plate at 2.54: asking 0.1 / 0.6 / 1.2 gives channels
of exactly **0.40 / 0.60 / 1.20 mm**, 19 per row. At **2.54 the section
collapses from 19 gaps to one of 48.26 mm** — exactly `span + channel_w` — and
at 3.0 to one of 48.72. Manifold at every step, including the butting point.

Direction and length are not settings either, because neither has a second
sensible value. Channels always run toward the middle of the box — outboard
there is only the side wall a couple of millimetres away, with nowhere to leave
the wire; inboard opens onto the relieved floor. And they always run far enough
to break clear through the plinth's side, because a channel stopping inside the
plinth is a pocket, not a way out.

- **It exits sideways, not over the top.** The board sits only `pcb_standoff`
  above the plinth — 1.2 mm — so a wire climbing over the plinth would lift the
  board. Leaving at plate level and dropping into the relieved floor avoids that.
- **It reaches below the hole by one hole width.** Without that, its mouth into
  the trough would be a sliver no wire fits through. One width down for one
  width across, so the channel is square in section where it meets the trough.

> **A 1.00 mm channel is narrower than common hook-up wire.** 26 AWG with
> insulation is about 1.2 mm, so it will not lie in the channel at the 2.54
> preset — it has to be a thinner gauge, or stripped wire, or you raise
> `hole_clearance`, which widens hole and channel together at the cost of a
> looser pin. This is the real trade for having one number instead of two: the
> old `wire_w` default of 1.4 was sized for the wire, not for the pin.

The pins do **not** rely on the holes being closed. Both rows' channels point
inboard, so a board drifting one way frees one row into its channels while the
*other* row presses against the far side of its holes and stops. Either
direction, the board is held to `(hole - post)/2` = 0.18 mm — the same figure a
closed hole gives, and far tighter than the 1.2 mm of clearance to the side
walls.

At the **1.27 micro preset** the rib is 0.51 mm, under one 0.4 mm extrusion, so
an `assert` stops you — set `wire_channels = false`. `pin_slot` does not rescue
it: the channels run *across* the plate, so they need the pitch whether the pins
sit in holes or in one long channel.

Set `wire_channels = false` if you do not want them — that leaves about
0.36 cm³ more plastic in the tray (16.45 → 16.81 cm³, measured off the two
meshes).

### Room for the antenna

A devkit mounts its radio module hard against the far end of the board, and the
antenna sits at the module's tip — often overhanging the board's edge. Pressing
a wall against it is the one thing a case can do that actually degrades the
radio, so `antenna_gap` reserves clear air past the board's far edge:

```
  |<-w->|<-------- board -------->|<- gap ->|<-w->|
  +-----+-------------------------+---------+-----+
  |wall | flush to the USB wall   | antenna |wall |
  +-----+-------------------------+---------+-----+
```

The wall in front of it is left at full thickness — this is mechanical room, not
an RF window. **Measure your own board**; 6mm is a starting point, not a spec.

### The board is flush at the USB end

The board sits hard against the inside of the USB end wall, so its socket lines
up with the opening rather than being centred and missing it. The header is
soldered to the board, so it follows: everything is positioned from the board's
USB edge outward.

**With `usb_opening` off, the board steps back by `usb_overhang`.** The socket
overhangs the board's edge, so flush against the wall it is protruding
`usb_overhang` — 1.0 mm — *into* that wall. That is exactly what you want when
there is a hole for it to protrude into, and impossible when there is not: the
socket would be inside solid plastic. So the board moves back by the overhang,
the socket's face lands on the wall's inner face, and the whole connector is
inside the box.

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

That `max` is what makes `board_side_margin` and `board_w` work at all. The
width used to come from the header alone and never looked at the board, so
growing the board past the case was an error rather than a bigger case —
`board_side_margin` failed above 2.2 of its 0 → 20 range, and `board_w` above
~27.3.

**It is also what makes `side_margin` look broken when it is not.** The two
terms cross at `side_margin` **4.6** with the defaults, and below that the
board sets the width and moving `side_margin` changes nothing whatever:

| `side_margin` | Case width | What set it |
| --- | --- | --- |
| 3.0 | 32.06 | the board — `side_margin` is doing nothing |
| 4.5 | 32.06 | the board — still nothing |
| 4.6 | 32.06 | they tie |
| 5.0 | 32.86 | `side_margin`, 1:1 from here up |
| 5.8 (default) | 34.46 | `side_margin` |

So if it appears dead, it is losing the `max`, not failing. Raising `wall` or
`board_side_margin` raises the board's demand and moves that crossover up. The
console prints the width it settled on.

Two more things about it, both easy to misread:

- **It measures to the OUTER face, so it carries the wall.** Thicken `wall` and
  the case does not grow; the interior shrinks. At 5.8 the outside stays 34.46
  while the interior goes 31.26 at a 1.6 wall and 29.66 at 2.4.
- **Screw bosses add to it instead of fitting inside it.** A corner boss needs
  room across the width that the header does not, so `closure = "screw"` puts a
  full `boss_d` on *each* side on top of whatever `side_margin` asked for. The
  stock closure is `friction`, where that does not apply and the row centre sits
  at `side_margin` exactly:

  | `closure` | Case width | Row centre from the face |
  | --- | --- | --- |
  | `friction` (default) | 34.46 | 5.8 — `side_margin` |
  | `screw` | 43.46 | 10.3 — `side_margin + boss_d` |

| Parameter | Default | What it does |
| --- | --- | --- |
| `antenna_gap` | 6.0 | Clear air past the board's far edge. **Measure yours.** |
| `side_margin` | 5.8 | Row centre to the outer side face, so it carries the wall. One of two demands on the width — see below. |
| `wall` | 1.6 | Wall thickness. |
| `floor_solid` | 2.0 | Floor away from the plinths, or the whole floor with the recess off. |
| `cavity_h` | 0 | Interior height above the floor. 0 = derive it. |
| `corner_r` | 3.0 | Outer corner rounding. |

> There is no `end_margin` any more. It set the distance from the end pin to the
> outer face, which the flush board now decides at the USB end and `antenna_gap`
> decides at the far end. Use `board_end_margin` to move the header on the board.

### USB opening

`usb_type` picks the connector. The openings are **flush mount**: sized to the
socket's own metal shell plus a 0.6 mm print fit, so the socket meets the wall
rather than a big hole being left for the plug to pass through.

| `usb_type` | Receptacle shell | Opening | Case height |
| --- | --- | --- | --- |
| `micro` (default) | 7.50 × 2.50 | 8.10 × 3.10 | 14.3 |
| `c` | 8.95 × 3.20 | 9.55 × 3.80 | 15.0 |
| `mini` | 7.70 × 4.00 | 8.30 × 4.60 | 15.8 |
| `a` | 13.00 × 5.70 | 13.60 × 6.30 | 17.5 |
| `custom` | — | `usb_w` × `usb_h` | 17.2 at 12 × 6 |

Sockets vary far less between boards than cable overmoulds do, which is what
makes flush mount worth having — but measure yours, and use `custom` if it
disagrees. With `custom`, `usb_w`/`usb_h` are the finished opening, so include
your own fit.

**The opening is positioned automatically, not by `opening_z`.** A generous hole
never had to line up with anything; a flush one does. The socket stands on the
board's *top* face, so that face is the only thing that can decide where the
opening goes:

```
usb_z = pcb_standoff + board_t - usb_fit/2   = 1.2 + 1.6 - 0.3 = 2.5
```

Measured on the mesh: the opening cuts 8.100 × 3.105 mm at z 9.50–12.60, and a
2.5 mm micro shell sitting on the board occupies 9.80–12.30 — **0.30 mm clear on
every side.** At the old fixed `opening_z = 0.5` that same 3.1 mm opening would
have caught 0.8 mm of the 2.5 mm shell and missed the rest. `opening_z` still
places the *far end* opening, which has no socket to meet.

**The opening is the connector's shape, not a rectangle.** On a loose hole the
outline never mattered; on a flush one, every corner the real shell curves away
from is a gap left behind.

| `usb_type` | Outline | Width, bottom to top |
| --- | --- | --- |
| `micro` | Trapezoid, wider at the top | 7.20 → 8.10 |
| `mini` | Trapezoid, wider at the top | 7.10 → 8.30 |
| `c` | Obround, radius = half the height | 9.55 at mid-height, tapering to the caps |
| `a` | Rectangle — genuinely is one | 13.60 throughout |

The micro/mini taper is the feature that stops a plug going in upside down, so
it is the part of the outline most worth having. It is approximate: a shell's
draft varies by manufacturer far more than its overall size does. Bounding size
is what the asserts and the cavity height use, and that is unchanged.

It changes the overhang, too. The opening's top edge is the one flat bridge in
the end wall, and an obround replaces it with an arch — USB-C measures 91.5 mm²
at 45° but only 87.5 mm² at 60°, where the flat-topped trapezoid stays at 89.4
across all three.

### Getting the socket in

`usb_overhang` is how far the socket's shell stands proud of the board's edge —
about 1 mm on most devkits, sometimes 0. **Measure it.** Two things depend on it,
and both matter more than they look.

**It is the plug's reach.** The board sits hard against the inside of the end
wall, so the socket's face ends up `wall − usb_overhang` from the outside:
**0.6 mm** at the defaults, not the full 1.6. That is the difference between a
lead seating and a lead fouling the case.

**And it is why the opening is notched to the wall's top edge.** A nose that
overhangs has to end up *inside* the wall — but it cannot get there going
straight down, because there is 2.89 mm of solid wall above the opening and the
board drops vertically. Measured, the nose path (x 0.6–1.6) was blocked from
z 12.61 to 15.49. The notch is the slot it slides down; with it, the only solid
left in that path is *below* the socket, where the socket never goes.

```
  END WALL, outside          ASSEMBLED, in section

   ______________            lid plate
  |    ______    |           ========================
  |   |      |   |  <- notch  |  tab fills the notch |
  |   +------+   |            +----------+
  |   |  USB |   |  <- socket |  socket  |
  |   +------+   |            +----------+
  |______________|
```

**The lid closes it.** A tab on the lid's underside, in the wall's own thickness,
drops into the notch — the rib alone cannot do it, because the rib sits *inside*
the wall and the notch *is* the wall. Measured on the assembled model, the end
wall reads solid from z 12.80 to the top, with only the socket opening below it
open. The tab starts above the *opening's* top rather than the notch's, because
for the obround the notch begins at mid-height and a tab following it down there
would land on the socket.

Set `usb_overhang = 0` for a flush-mounted socket and the notch and the tab both
go away. An `assert` catches an overhang greater than the wall, which would put
the socket outside the case.

### The board drops when `pin_slot` is on

The board is carried on the header's plastic strip, and the strip lands on the
plinth tops. Switch `pin_slot` on and there may not *be* a plinth top under it:
the channel runs down the middle of the row, and if it is wider than the strip
the strip drops into it. The whole board goes down with it — pins further into
the pockets, board further from the lid, and **the USB socket moves**.

The strip is one pitch wide, so the test is `slot_cut_w > pitch`:

| | USB `z` | Pin in pocket | Case height |
| --- | --- | --- | --- |
| `pin_slot` off | 2.5 | 3.8 | 14.3 |
| on, `pin_slot_w = 0` (1 mm channel) | 2.5 | 3.8 | 14.3 — strip bridges it |
| on, `pin_slot_w = 3` — **the default** | 1.3 | **5.0** | **13.1** |
| on, 4 mm channel | 1.3 | **5.0** | **13.1** |
| on, `pin_slot_depth = 1` (4 mm channel) | 1.5 | 4.8 | 13.3 |
| on, `pin_slot_depth = 12` (4 mm channel) | 1.3 | 5.0 | 13.1 — capped |

**The test is `strip_w`, not the pitch.** What the board rests on is the plastic
spacers the pins pass through, and on a devkit those are about **3 mm** square —
wider than the 2.54 pitch this used to assume. A channel narrower than a spacer
is bridged by it; a channel that wide or wider swallows it:

| `pin_slot_w` | vs `strip_w` 3.0 | USB `z` | Case |
| --- | --- | --- | --- |
| 0 (1 mm channel) | bridged | 2.5 | 14.3 |
| 2.9 | bridged | 2.5 | 14.3 |
| **3.0 (default)** | **swallowed** | **1.3** | **13.1** |
| 4.0 | swallowed | 1.3 | 13.1 |

Measure your own spacers and set `strip_w` to match — at 3.5 the default channel
bridges again and the board does not move. The old assumption would have called
a 2.6 mm channel a drop when a 3 mm spacer actually bridges it.

The drop is capped at `pcb_standoff`, the spacer's *height*, so it is 1.2 mm and
not the full 3 mm of `pin_slot_depth`. Once the spacer has sunk, the board's
underside is resting on the plinth tops either side of the channel — it is
28.86 mm wide against a 3 mm slot, so that is as far as it goes. Raise
`pcb_standoff` to your header's real spacer height and the drop follows it.

The drop is capped by the **board**, not the channel: the strip sinks until
either it grounds out or the board's own underside reaches the plinth top, and
the board is the width of the case against a channel a few millimetres wide. So
the cap is the strip's own height, `pcb_standoff`. A 12 mm channel drops exactly
as far as a 3 mm one. Without that cap a 3 mm channel put the board's top face
*below* the floor and asked for a USB opening at a negative height.

**`dupont_housing` follows exactly the same rule.** It forces `pin_slot` on, so
the board drops just as it would with the tick off and the channel set by hand:

| | Case height | USB `z` | Pin in trough |
| --- | --- | --- | --- |
| `pin_slot` on, 3 mm channel | 13.1 | 1.3 | 5.0 |
| `dupont_housing` on | 13.1 | 1.3 | 5.0 |

An earlier version of this model suppressed the drop for the surround, on the
reasoning that the housings rise to the floor's top face and the strip lands on
*them*. That was wrong. **A housed Dupont is pushed up from below and held by
friction on its pin, over a trough that is open at the underside — it is not
standing on anything.** It follows the board down; it cannot hold the board up.
The one case where a connector really does push back is a sealed base, where it
bottoms out on the slab, and that already has its own warning about lifting the
board.

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
| **Plus `rib_h` 2.1, socket in the stack** | **5.3** | **14.3** | **0** | **the components** |

**The socket is counted as a component.** `component_h` is what you measured on
the board; `usb_shell_h` is what `usb_type` already implies. The cavity takes the
larger, so a tall connector cannot be forgotten — USB-C's 3.2 mm shell against a
`component_h` of 2.5 gives a 6.0 cavity, not 5.3, and the lid does not close onto
the socket:

| `usb_type` | Shell | Cavity | Case |
| --- | --- | --- | --- |
| `micro` | 2.50 | 5.3 | 14.3 |
| `c` | 3.20 | 6.0 | 15.0 |
| `mini` | 4.00 | 6.8 | 15.8 |
| `a` | 5.70 | 8.5 | 17.5 |

The rib hangs around the perimeter and only overlaps the board at the USB end,
where the socket is. Cut it away over the socket's width and the tallest thing it
still has to miss is the board's own top face — `board_top + rib_h` instead of
`opening_top + rib_h`, which is 2.6 mm lower. The far-end opening is notched the
same way, so it no longer has to duck under the rib either.

So `rib_h` is free up to `component_h − 0.4` — **2.1** at the defaults, which is
where it now sits, so the joint costs no height at all:

| `rib_h` | 1.5 | 2.0 | **2.1** | 3.0 | 4.0 |
| --- | --- | --- | --- | --- | --- |
| Case height | 14.3 | 14.3 | **14.3** | 15.2 | 16.2 |

And `component_h` is what moves the lid now — set it to your tallest part and the
lid comes down to meet it. The console still names whichever term won.

**The pocket is the biggest single lever.** The floor is
`pocket + hole_plate_t` = 7.0 mm of the 14.3 mm total — half the case — and the
pocket is `max(terminal_len, what the pin tail needs)`.

Set `cavity_h` to a number to pin it; an `assert` will catch it if you pin it so
low that an opening runs up below the rib.

### Closure

The lid's plate lands on the top of the tray wall, and a **rib underneath it
drops inside the wall** to locate it. On its own that is only a press fit —
both mating faces are plain vertical walls — so it aligns the lid and grips by
friction, and nothing actually holds it down.

> **There is no groove in the tray.** The lid used to sit in a slot milled into
> the wall top, and that slot is what forced a thick wall: 1.2 mm of slot plus a
> 1.0 mm lip either side is 3.2 mm before you have a case at all.
>
> That thickness is not free — **the socket sits against the inside of the wall,
> so every millimetre of wall is a millimetre off the USB plug's insertion
> depth.** At 3.2 mm most micro leads never bottom out: the moulded shell fouls
> the case first. Hanging the rib inside the wall asks nothing of the wall's
> thickness, so the wall dropped to **1.6 mm** and the plug got 1.6 mm of its
> reach back. From outside the joint looks the same.

| Parameter | Default | What it does |
| --- | --- | --- |
| `wall` | 1.6 | Wall thickness. Four 0.4 mm perimeters, and the plug's reach. |
| `rib_w` | 1.2 | Rib thickness — three perimeters. |
| `rib_h` | 2.1 | How far the rib hangs into the cavity. Sets the case height. |
| `latches` | true | Ball detents on/off |
| `latch_count` | 2 | How many down each long side |
| `latch_grip` | 0.35 | How far the ball squeezes past the wall, in mm |
| `latch_fit` | 0.10 | Slack in the dimple so the ball seats |

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

There is still no cantilever-snap option: for any lid that separates vertically,
a hook's retention face is always a downward-facing surface, and steepening it
enough to print cleanly makes it too weak to hold. A ball detent avoids that —
it retains by interference, not by an undercut.

### Lid

Vents sit in a patch over the radio module — the only part of a devkit that gets
meaningfully warm — rather than being spread across the plate, which keeps the
rest of the lid solid and leaves room for the label. The patch defaults to
**20 × 20 mm**, positioned with `vent_from_end`, `vent_zone_l` and
`vent_zone_w`. `vent_from_end` is measured from the board's far edge, so the
patch stays over the module whatever the antenna bay is set to.

Vents are always cut from **artwork in an SVG**, named by `vent_file`. Two ship
with the model:

| File | What it is |
| --- | --- |
| [`slots.svg`](slots.svg) | Five plain bars across the patch. The default. |
| [`wifi.svg`](wifi.svg) | The wifi symbol |

`vent_rotate` turns the artwork on the lid, counter-clockwise as you look down
at the closed case. **Zero is not "as drawn"** — artwork is laid down a quarter
turn clockwise from how it sits in the file, which is what stands `slots.svg`
bars up across the case and puts `wifi.svg` dot-beside-the-label. So 0 is the
orientation you want and you only touch this to deviate. The turn is applied
before the artwork is scaled, so `vent_zone_l` always measures across the
finished orientation.

`vent_fit` either keeps the artwork's proportions (default) or stretches it to
fill the patch exactly. With `aspect`, `vent_zone_w` is not used at all — the
artwork is scaled to `vent_zone_l` and its own proportions decide the height.

**Use SVG.** It imports as a true outline. A PNG can only be read as a heightmap
and thresholded at `vent_level`, which lands every edge on the pixel grid —
measured on a plain disc, the PNG route wobbled **0.75 mm on a 10 mm radius**
and used six times the triangles, where the SVG was exact to 0.000 mm.

Two things to know if you are drawing your own:

- **Fill, not stroke.** OpenSCAD imports filled areas and ignores stroke, so a
  stroked path comes in empty. It ignores fill *colour* too, which is a trap
  with icon sets built for the screen: artwork that layers a light shape over a
  dark one has no colour to distinguish them once imported, so the two union
  and you get the outer silhouette with the detail gone. Detail only survives
  if it is a real hole in the path. Check the render whenever you drop in new
  art.
- **Keep the viewBox origin at 0 0.** OpenSCAD's `import(center = true)`
  mis-centres a negative viewBox origin — the first cut of `wifi.svg` landed
  off-centre until its viewBox started at the origin.

> ### A missing SVG fails quietly
>
> If `vent_file` cannot be found, OpenSCAD prints `ERROR: Can't open file` from
> `import()` — and then **carries on and renders a lid with no vents at all**,
> reporting `Status: NoError` and exporting a perfectly valid STL. There is no
> way to test for a file's existence in OpenSCAD, so this cannot be caught by
> an `assert`. The console line tells you which file the lid used; an unvented
> lid is the symptom to watch for.
>
> This is also why the Thingiverse and Printables customizers cannot render the
> lid: they cannot resolve the file. The tray, template and coupon are
> unaffected and still render from the `.scad` alone, as does the lid with
> `vents = false`.

## Printing

**No supports needed.** Measured off the exported meshes, not assumed:

| Part | Surface below 45° | below 55° | below 60° |
| --- | --- | --- | --- |
| Tray | 38.9 mm² | 39.4 mm² | 40.0 mm² |
| Lid | 0.71 mm² | 1.14 mm² | 1.65 mm² |
| Template | 0.00 mm² | 0.00 mm² | 0.00 mm² |
| Coupon | 0.00 mm² | 0.00 mm² | 0.00 mm² |

The tray's 38.9 mm² is almost all the top edge of the USB opening — a 12 mm
bridge across the 3.2 mm wall, or 38.4 mm², which every FDM printer spans
without help. The remaining 0.5 mm² is the four latch dimples.

The lid's 0.71 mm² is the four latch balls. A half-round bump has a small flat
patch at its lowest point; measured against a 45°-chamfered bead of the same
size, the bead is 0.00 mm² and the ball 0.58 mm² per pair. It is a fraction of
a square millimetre either way and bridges in a couple of layers, but that is
the price of a round ball rather than a chamfered one.

The lid has nothing to bridge at all. `label` defaults to blank, and the
engraving was the only overhang on it: set a label and you get the ceiling of
the lettering, 0.6 mm above the bed — about 32 mm² for `"ESP"` — bridged over
a glyph's width in the first two layers. The vent openings are cut clean
through and never overhang whatever artwork you use.

Three features exist specifically to keep this true:

- **The troughs are square, and their ceilings bridge.** This is the one place
  the tray has real flat downward area — 255 mm² of it, two strips 3 mm wide
  running the length of the header. It is a *bridge*, not an overhang: the
  trough is anchored on both its walls, so the slicer spans the 3 mm short
  direction, and 3 mm at a 0.4 mm nozzle needs no support. That is also why
  there are two narrow troughs rather than one full-width recess — 3 mm bridges,
  a 28 mm floor would not.

  They used to be roofed by a 65° ridge to avoid even that, on the reasoning
  that a flat ceiling was an unsupported span inside a slot you could never
  clean support out of. It was never a span. What the ridge actually did was
  taper the trough to nothing at the plate, so a connector could not reach the
  pin — see below.
- **The holes are plain bores**, vertical top to bottom, so they cannot overhang
  at all. They used to carry an upward-facing funnel, which could not overhang
  either — removing it left the downward-facing area completely unchanged at
  38.9 / 38.9 / 38.6 mm² for 45 / 55 / 60°, which is how you can tell the
  chamfer was never carrying any printability weight.
- **The floor relief is cut downward out of the cavity**, so every face it makes
  is either vertical or upward-facing. It also deliberately spares
  a pillar under each screw boss, so nothing is left
  standing on air. Measured across 19 configurations — plinths merging, rests
  removed, oversized bosses, no antenna bay — the tray never rises above
  28.8 mm².

Both angles are parameters. Lowering them makes the case shorter and the print
riskier; they are set with margin above the 45–55° thresholds slicers use.

If you set a label, it is engraved into the face that lies on the bed, so it
appears as a shallow recess in the first layers.

`label_rotate` turns it, counter-clockwise as you look down at the closed case;
−90 stands it on its side reading down the case. Unlike the vents there is no
quarter turn built in — 0 is as you typed it.

Turning it costs you room. Upright, the label has the length of the case to
fill; on its side it only has the width, which is a lot less. The model warns
when the label looks too big:

```
WARNING: the label looks too big for the lid — roughly 6 x 51 mm against an
interior of 57.72 x 31.26, so it will run off the edge.
```

That figure is estimated, not measured — OpenSCAD's `textmetrics()` is an
experimental builtin that is off by default and returns `undef`, so the real
width cannot be read here. The estimate was checked against five measured
cases and agreed with all of them (76.5 mm predicted against 76.57 measured on
the worst), but it is a smoke alarm, not a specification.

## Verification

Checked by rendering headlessly and measuring the meshes:

| Check | Result |
| --- | --- |
| Geometry self-contained | Tray, template and coupon render from the `.scad` alone in an empty directory; zero `use`/`include` |
| Lid needs its SVG | Verified: with the file absent the lid renders at genus 0 — no vents — while still reporting `NoError` |
| All parts × both closures | 12/12 manifold, `Status: NoError` — and 12/12 again with `seal_bottom` |
| Tray and lid footprints | Identical, both closures |
| Tray/lid interference when closed | Empty intersection for both closures |
| Through-holes actually connect | Genus 39 = 38 holes + USB, recess on and off |
| Parameter sweep | 41 configurations across all parts, all manifold |
| Vent artwork | 24/24 manifold across slots.svg and wifi.svg × all parts × both closures |
| Shipped wifi.svg cuts cleanly | Genus 4 — exactly 3 arcs and the dot — and centred to 0.000 mm |
| Latches seat without clashing | Empty tray ∩ lid for both closures, so the ball sits in its dimple |
| Latch grip survives the printer | 0.35 mm = 0.87 of a 0.4 mm extrusion width; 0.55 mm of lip left under each dimple |
| Artwork canvas size is cosmetic | Rescaling slots.svg to the shared canvas left the lid mesh bit-identical |
| slots.svg replaces the old parametric slots exactly | Same 550.0000 mm³ cut, same bbox, and an identical lid vertex set |
| Artwork import works both ways | SVG hex sheet → genus 45 for 45 hexagons; PNG → genus 1 for one connected shape |
| Invalid parameters | 9/9 caught by `assert` with a message naming the fix |
| Overhang is only the trough ceilings | 255.3 mm² at 45/55/60°, all of it the two 3 mm-wide trough bridges plus the USB opening's own 38.4 mm² |
| Board really is flush | Measured 0.000 mm between the board's USB edge and the wall |
| Antenna bay really is the gap | Measured 6.000 mm of clear air past the board's far edge |
| The four rest pads are gone | Probed at all four corner positions: SOLID before, open after. 211 mm³ of plastic removed, genus 39 unchanged, downward area unchanged at 101.9 mm² |
| Tray volume | 24.11 cm³ → 16.30 cm³ off the two meshes; the floor relief still removes ~8 cm³, the thicker latch wall puts some back |
| Template holes all go through | Genus 38 = exactly the 38 pin holes, nothing else |
| Template needs no support | 0.00 mm² across every configuration tested |
| Hole is one size all the way down | Sectioned through the plate at nine depths: 1.000 mm at every one. The chamfered version measured 1.000 at z 9.72 opening to 1.825 at 10.21, so "the hole size" depended on where you measured it |
| The coupon goes over five real pins | Sectioned: 5 holes all **1.000 mm** at **2.54 mm centre-to-centre exactly**, 1.22 mm to each end. The neighbouring pins clear by **0.50 mm** — real clearance, not the 0.01 mm a Dupont-sized coupon gave, which is inside print tolerance. The old coupon spaced its holes 7 mm apart, 2.76× the pitch, so only a single snapped-off pin ever went in |
| The coupon reports the pin, not the surround | Its pin row is sized from `pin_hole`, never `hole`. Sized from `hole` it cut 2.86 mm openings and called that a pin fit, leaving a 0.64 mm pin **1.11 mm of air per side** — which is what making `dupont_housing` default-on had quietly done to it |
| Everything at the selected size, Dupont row merged | Genus **6** with the Dupont row (5 pin holes + 1 merged slot) and **5** without — the engraved label cuts 0.50 mm into a 1.00 mm plate and adds none. The Dupont row sections as a single **12.000 mm** opening: the overlapping surround openings run together exactly as the tray's do, and it is cut as one slot, so it cannot butt cube-on-cube into a negative genus |
| The `pin_hole` rename moved nothing | Tray, lid and template byte-identical against a copy with the old expression inlined. The lid initially differed — the copy sat in a directory without `slots.svg`, so `import()` failed silently and it rendered vent-free at genus 0 instead of 5, exactly the documented trap |
| `part = "all"` still lays out | The coupon is 13.60 × 10.86 against a 60.92-wide case; the lid ends at Y 73.92 and the coupon starts at 78.92 — 5.00 mm clear, which is `layout_gap` |
| Removing the chamfer breaks nothing | Genus 39 unchanged, 5000 → 4544 facets, and the same 17/17 configurations render manifold — including `hole_plate_t` at both 0.6 and 4.0, the two ends the funnel cap used to have to police |
| No forward-referenced variables | Static scan of every top-level assignment — an undef here silently deletes geometry |
| Wire route is actually continuous | Traced by section from trough to bay; one width the whole way now, so there is no narrowest point to find — it was the neck that used to be it |
| Wire channels add no overhang | 28.8 mm², unchanged, and the ribs between channels survive |
| Sealed base really is closed | Underside probes solid 2.0 mm over both troughs, where it is open air unsealed |
| Sealing changes nothing else | Pin engagement, holes and channels all identical; only the base slab and 2 mm of height are added |
| Rest pillars survive a thin floor | 28.8 mm² across `floor_solid` 0.8 → 5.0, sealed and open — a coplanar-face bug used to break this at 0.8 |
| Template matches the tray | Same footprint, same interior outline, same hole positions |
| Pin channel is genuinely continuous | Genus 39 → 3, i.e. −36, which is 19 holes collapsing to 1 on each of two rows. Probed at 18 between-pin midpoints: 18/18 solid with holes, 0/18 with the channel |
| Pin channel is the width asked for | Measured 4.005 mm against a nominal 4.0, and now straight-sided the whole way — the swept chamfer along its mouth went with the holes' funnels |
| The opening into the trough is the narrow one | Measured 1.885 mm against 1.865 predicted, with the full 3.000 mm trough below it — which is why the console reports it rather than calling the channel 4 mm of passage |
| Pin channel adds no overhang | 38.9 / 38.9 / 38.6 mm² at 45/55/60°, **identical** to the holes it replaces. The shelf either side faces up, not down — the mesh is what settled this, the paper argument had it backwards |
| Channel never runs off its trough | Ends measured at x 5.70 and 52.42 inside a trough spanning 4.70 to 53.42; widening it does not lengthen it |
| `pin_slot = false` changes nothing | Same 5608 facets, same 2728 vertices, same 16303.8308 mm³, same genus 39 — one coplanar quad on the floor top flips its diagonal, which is CSG-tree noise, not geometry |
| Pin channel depth guard | Clamped, not rejected: the whole 0.5 → 12 slider renders, anything under `hole_plate_t` cut at `hole_plate_t` with a console note |
| Square troughs reach the plate | Sectioned at eleven depths from the underside to the plate: **3.000 mm at every one**, then 0 at the plate. Ridged, the same section ran 3.000 at the bottom tapering to 0.105 at z 9.0 and 0 at the plate |
| Pockets are per pin, separate, and square | Sectioned both ways at three depths: **1.740 mm along the row, 1.743 mm across**, with **0.800 mm** dividers. `pocket_wall = 0` gives one continuous run instead |
| A silent forward reference, caught | `pocket_l` was briefly used one block above its assignment. Every pocket in the tray vanished and OpenSCAD still reported `NoError` and a plausible genus 39 — found by the static scan, not by rendering. It is why that block carries a warning not to move it |
| Separate pockets show up in the topology | Sealed base drops from genus 37 to **genus 1**: a pocket reached by one hole is no handle, where one slot reached by 19 was 18 of them per row |
| The reported grip is now the real grip | The pin occupies z 2.2 → 6.0 and the trough is full width across all of it, so "3.8 mm of pin inside the trough" is what a connector can actually reach. Ridged, a 2.5 mm terminal stopped at z ≈ 6.44 against a pin tip at 5.4168 — about 1.0 mm, with no warning, because the check tested the 3.8 figure |
| Removing the ridge shortens the case | 23.12 → 19.90 mm tall and 16.51 → 13.52 cm³ at the time, at identical genus 39. Later changes took it further — the case is 14.3 mm now |
| What the ridge cost in overhang | 38.9 → 255.3 mm² of flat downward face, in 3 mm-wide strips the slicer bridges. That is the entire trade |
| Pin channel across the presets | Manifold at 2.54 and 1.27, `pin_slot_w` 0 and 4, sealed, relieved, recess off, both closures, template and assembled — 13/13 |
| `board_side_margin` across its whole range | Failed above 2.2 of a 0 → 20 slider before; 0, 1.5, 2.2, 3, 5, 10, 20 all render now, the case widening past 2.2 |
| `board_w` across its whole range | 26 → 60 all render; used to fail past ~27.3 |
| `side_margin` is the only width lever | Swept 4.7 → 12; below 4.6 the board sets the width, above it `side_margin` does, and the gap tracks `side_margin − board_side_margin − wall` exactly at every step |
| Sizing fix changes no default | Default tray identical to HEAD — 5608 facets, 2728 vertices, 16303.8308 mm³, genus 39, same bbox |
| Press fits are reported, not silent | Warning fires at `board_side_margin` 3/10/20, `board_w` 60 and `antenna_gap` 0 — every configuration where the gap reaches zero |
| Zero gap is really zero | `inner_w` is `pcb_w` plus and minus `2 × wall`, which returned 3.55e-15; snapped, so the console reads 0 and the fit `assert` is not decided by a rounding error |
| `pin_length` changes the case | Past 8.2 mm the pocket follows the pin: 15.1 / 18.1 / 22.1 mm at 9 / 12 / 16, default geometry unchanged. It used to alter nothing at all — swept 2 → 20 for an identical 14.3 mm case |
| Two demands, one dimension | `pocket = max(terminal_len, pin_length − standoff − plate)`. Neither is redundant: a longer pin does not enlarge a connector |
| Overrides still caught | `width_override = 32.5` fails with a message naming `width_override` rather than blaming the board |
| USB opening is flush and lands on the socket | Cuts 8.100 × 3.105 mm at z 9.50–12.60; a 2.5 mm micro shell on the board occupies 9.80–12.30, so 0.30 mm clear on all four sides. At the old fixed `opening_z = 0.5` the same opening caught 0.8 mm of that 2.5 mm shell |
| All four presets render, typos do not | micro / c / mini / a / custom all manifold; `usb_type = "usbc"` fails with a message listing the valid values |
| `component_h` now sets the height | With the rib notched around the socket it is the binding term at last: 14.7 at `component_h` 1, 14.9 at 3.1, 17.8 at 6 (measured at the then-default `rib_h` 2.5). `rib_h` is free up to 2.7 |
| Notching the rib is worth 2.6 mm | 17.5 → 14.9 mm; dropping `rib_h` to 2.1 took it to **14.3**, with the lid underside measured at 12.31 against a component top of 12.30 — touching |
| The socket counts as a component | Cavity tracks the shell: 5.3 / 6.0 / 6.8 / 8.5 for micro / c / mini / a. Before, a USB-C shell against `component_h` 2.5 would have had the lid closing onto it by 0.7 mm |
| A cavity that shrank past its own openings | At a 5.3 cavity the wall no longer reaches above the USB opening — the notch height went negative, i.e. a cube with a negative side, and the console reported "−0.3 mm of solid wall". Clamped, and the note now says the opening already reaches the rim |
| The rib really is cut | Sectioned across the lid's USB-end rib at three depths: an **8.11 mm gap at y 13.18–21.29**, exactly the socket opening, through the rib's full depth |
| The latch balls survive it | Rib material reaches y 33.205 at each latch against 32.705 between them — a 0.5 mm bulge, the ball radius. I had briefly moved `latch_balls` into the subtrahend list, which would have cut dimples into the lid instead of adding bumps |
| The rib-inside-the-wall joint seats | tray 9271.1158 + lid 4231.1156 = 13502.2314 mm³, **exactly** the assembled volume — zero interference, tab and rib included |
| The socket can actually get in | Nose path (x 0.6–1.6) was solid z 12.61–15.49 before the notch; after it, the only solid left is z 9.00–9.49, below where the socket ever goes |
| The lid closes the notch | Probed through the end wall on the assembled model: solid from z 12.80 to the top, open only at the socket opening below |
| A coincident face that cost manifoldness | Landing the notch exactly on the profile's top, at exactly the same width, gave **8 non-manifold edges** where the tray had none. Overlapping it by 0.1 fixed it — 0 across all four connector types |
| The wall is solid its whole height | Sectioned at z 5, 10, 14 and 15.3: **1.600 mm** at every one, no slot |
| The latch survives a 1.6 mm wall | Dimple bites 0.448 mm into the inner face, leaving 1.155 mm behind it. Warning fires below `wall` 1.25 |
| The latch keeps its seat | Warning fires when the 1.0 mm ball passes half the rib. `rib_h` 2.5 leaves 0.75 mm of rib above and below it |
| A `search()` that looked right and was not | The first usb_type guard used `search()` over a list — it matches per *character*, so it passed "micro" and rejected "c". Caught by rendering all five presets, not by reading it |
| Openings are the connector's outline | Sectioned at five heights. micro 7.245 → 8.055 (nominal 7.20 → 8.10, sampled 5% inside each end); mini 7.135 → 8.265; USB-C symmetric about 9.550; USB-A flat at 13.600 |
| The board follows the pin channel | `pin_slot` on drops it 1.2 mm — USB z 2.5 → 1.3, pin in pocket 3.8 → 5.0, case 19.0 → 17.8. A 1 mm channel does not drop it at all, and a 12 mm channel drops no further than a 3 mm one |
| The drop is bounded by the board | Unbounded, a 3 mm channel put the board's top face below the floor and produced a negative USB height. Capped at `pcb_standoff`, `pin_slot_depth` 3 and 12 give identical geometry |
| Cable slot really is the hole's width | Measured 1.000 mm across four consecutive channels against a 1.00 mm hole, with 1.540 mm ribs between them — exactly `pitch − hole`, the same rib as between two holes |
| Slot still does its job | Breaks clear through the plinth face at y 8.55 (face at 8.50) and reaches down into the trough, so the wire can still turn the corner |
| Fixing the width removes a constraint | The channel assert is now the plate's own `pitch − hole` printability, not a separate `wire_w` limit — one fewer way to build something that will not print |
| Simplification costs no quality | Genus 39 unchanged, 5608 → 5000 facets, downward area still 38.9 / 38.9 / 38.6 mm² at 45/55/60° |
| Whole matrix after the cut | 16/16 render manifold — both other presets, channels on and off, `pin_slot`, sealed, relieved, recess off, both closures, all five parts |
| The surround tick was exactly the manual settings | With wire channels off, `dupont_housing = true` rendered **byte-identical** to the same opening hand-set via the old Custom preset (`custom_post = 2.50`, `pin_slot`, `pin_slot_w = 0`, `pocket_wall = 0`). Same md5, so the tick derived what it claimed and nothing else. Custom has since been removed, so the tick is now the only way to get a surround |
| …and it was strictly better with wire channels | Hand-setting `custom_post = 2.50` made the wire channel 2.86 mm and the rib check **rejected it outright**, while the tick rendered, because it keeps the channel at the post's 1.00 mm. Those two meshes had to *not* match, and did not |
| Wire channels are independent of the surround | Ray-cast section through the hole plate: **19 gaps of exactly 1.000 mm** per row with the tick on, not the 2.86 mm the opening became — 1.54 mm ribs, unchanged from the tick off. Channels off, the same section is one unbroken run |
| `wire_channel_w` is the width it says | Asking 0.1 / 0.6 / 1.2 at 2.54 sections into **0.40 / 0.60 / 1.20 mm**, 19 channels per row every time |
| A clamped top third, caught by using it | Capping the width at `pitch − 0.8` made every value above 1.74 render identically — a third of the slider silently dead, which is the same broken slider as one that asserts. Found by setting it, not by rendering the default |
| Channels merge instead of capping | At 2.54 the plate section collapses from **19 gaps to one of 48.26 mm**, exactly `span + channel_w`; at 3.0 to one of 48.72. Cut as a single slot, not touching cubes — manifold at the butting point, where a row of cubes would have gone non-manifold at negative genus |
| Every value on the slider renders | 28/28 explicit widths across all four presets. 124/128 over the whole range × presets × surround × `pin_slot`; the 4 rejections are all the derived `0` at 1.27, unchanged |
| The micro preset is unlocked | Wire channels were impossible at 1.27 at any setting — the derived 0.76 leaves 0.51 mm of plate. `wire_channel_w = 0.45` leaves 0.82 and renders at genus 38 |
| The clamp is not a silent one | Both directions print a note naming the value asked for, the value given, and the reason. The summary line carries the resulting width and rib on every render, marked `(set)` or `(from the pin)` |
| Adding the setting changed nothing | Default tray byte-identical at `wire_channel_w = 0` — same md5 as before the parameter existed |
| Surround across the whole matrix | All four presets × `hole_clearance` 0, 0.36 and 1.5 × wire channels on and off: **19 of 24 render, every one manifold at genus 2** — a single distinct genus across the lot. The other 5 are rejected by the pre-existing rib check (clearance 1.5 anywhere, plus 1.27 at 0.36) and are rejected **identically with the tick off — 19/5 both ways**. The surround neither causes a rejection nor prevents one |
| Surround openings are pitch-derived | 2.50 / 1.96 / 1.23 of surround giving 2.86 / 2.32 / 1.59 mm openings at 2.54 / 2.00 / 1.27 — read off the console at each preset, not assumed |
| The tick adds no overhang | Downward area **63.5 → 0.5 mm²** at 45/55/60°: the merged channel removes the per-pocket ceilings it replaces, and adds nothing. Volume 8.39 → 7.78 cm³ |
| The channel default earns its keep | At `pin_slot_w = 0` the channel is exactly the opening (2.86), so it matches the trough underneath: the "wide channel over a narrower slot" note and the thin-plinth warning both stop firing, where the old 4.0 default raised both. Plinth left each side 1.20 mm, over two perimeters |
| The tick costs no height | 14.30 mm case either way at the same `terminal_len`; 6 → 15 is what takes it to 23.30. The width is free, the depth is not |
| The surround drops the board like any wide channel | `dupont_housing` on gives case 13.1, USB z 1.3, 5.0 mm of pin in the trough — **identical** to `pin_slot` on with a 3 mm channel. An earlier version suppressed this on the theory that the housings hold the strip up; they are friction-held on the pin over an open trough and hold nothing up |
| Butting pockets, found by sweeping | `pocket == pitch` exactly — reachable today at `pocket_wall = 0` with `pin_slot`, and newly reachable at `hole_clearance ≤ 0.04` with the tick — left 19 cubes meeting face to face, giving **negative genus** at `Status: NoError`. Merged rows are now cut as one trough: same extent, genus −6 → 2, and the default tray stayed byte-identical |
| Still no forward references | Static scan re-run over the new `housing` → `post_eff` → `hole` → flags → `pocket` chain. This is the bug this file keeps making |

The `board_clearance` bug is the one to read the reasoning for rather than
trusting a table: a parameter that only ever fed an `assert` is invisible to
every mesh-level check, because *no* mesh changes when you move it. It was
caught by grepping for where the parameter was used, not by rendering.

Re-run any of it with:

```sh
openscad -o tray.stl -D 'part="tray"' esp-enclosure.scad
openscad -o lid.stl  -D 'part="lid"'  esp-enclosure.scad
```

### Not verified

Nothing here has been tested physically. Whether a Dupont terminal actually
grips at the default clearance, whether your devkit's pins are long enough,
whether the lip holds the lid shut — none of that is testable by rendering. The
Dupont and PCB defaults are reasonable starting points, **not specifications**.
Print the coupon and check the console's pin-engagement figure before committing
to a full case.

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
