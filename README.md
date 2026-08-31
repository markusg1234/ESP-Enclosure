# ESP-Enclosure

A parametric ESP devkit enclosure for OpenSCAD, with the header broken out
through the floor.

The board sits hard against the inside of the USB end wall so its socket lines up
with the opening, carried and located by its own header pins. Those pins drop
through a thin hole plate into a pocket under each one, and Dupont connectors push
up into those pockets from below, finishing **flush with the floor** instead of
hanging out of the case, with the wires leaving straight down through the open
underside. Past the board's far edge is a clear bay for the onboard antenna.

The devkit's **EN and BOOT buttons come up through the lid**, so you can reset
and flash the board with the case shut. Each is a **separate printed part** — a
stem standing proud through a plain hole in the lid, a flange underneath that
keeps it captive and comes down flat on the switch — fed in from inside the lid,
stem first, before the lid goes on. Nothing on it flexes,
which is the whole point: the printed flexure this replaced fatigued and broke
after a few presses.

**The geometry is one file.** [`esp-enclosure.scad`](esp-enclosure.scad) has no
`use <>` and no `include <>`, so the tray and the fit template render from it
alone. The lid is the exception: its vents are cut from artwork
in an SVG beside it, so that file has to travel with the model. Set
`vents = false` and everything is standalone again.

## Quick start

1. Install [OpenSCAD](https://openscad.org/).
2. Open `esp-enclosure.scad`.
3. **Window → Customizer**, set your parameters.
4. Choose a part with `part` at the top, press **F6**, then **File → Export → STL**.

Print the `tray`, the `lid` and the two `button`s — but print the `template`
first. It is quick, and it catches the way a full case usually goes wrong: your
board not fitting it.

> **Nothing here has been tested physically.** Whether a Dupont terminal grips at
> the default clearance, whether your devkit's pins are long enough, whether the
> latch holds the lid shut — none of that is testable by rendering. The Dupont
> and PCB defaults are starting points, **not specifications**. Print the template
> and check the console's pin-engagement figure before committing to a full case.

### Print the template first

Set `part = "template"`. It is a shallow stand-in for the tray — same footprint,
same interior outline, same pin holes in the same places, same screw bosses —
but 4.2 mm tall instead of 13.6.

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

### Check your pin length

This is the one thing most likely to catch you out. For a connector to grip, the
pin has to clear the standoff *and* the hole plate and still have 2–4mm left
over. The model works this out and prints it to the console:

```
ECHO: "Case 59.92 x 32.06 x 15.2 mm | header 19 x2 @ 2.54 (2.5 mm plastic
surround) | 3 x 3 mm pin channel (clearance, not a fit) | 1.2 x 1.2 mm wire
channels, 1.34 mm rib (set) | 8 mm of pin inside the trough | board gap
1.93 mm each side / 5 mm at the far end | USB micro 8.5 x 3.5 at 1.1 above
the floor | antenna bay 5 mm | 4 latches: ends at y 7.39 USB / 9.515 antenna
| vents from esphome.svg"
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

**Two parameters, and they are not the same kind of thing.** `board_w` is your
hardware — the PCB's width, measured across it with calipers. `side_margin` is
the case — pin row centre to the wall's inner face, the clearance beside the
pins. Everything else about the fit is derived from those two.

> **There is no `board_side_margin` and no `board_clearance`.** Both measured the
> same span from a different end — row centre to the board's edge, and the
> board's edge to the wall — so three parameters described two distances and only
> ever one of them was live. `side_margin` survived because it is what the
> troughs and pin holes are checked against.

The gap between board and wall is **derived, not requested**: you set how wide
your board is and where the wall goes, and the gap is what is left over.

```
gap each side = (interior width - board_w) / 2
```

The console prints it, and warns below 0.2 mm — half an extrusion width, under
which the board has to be forced rather than dropped in. Push `board_w` up far
enough and the board sets the case width instead, the gap goes to zero and you
get that warning; raise `side_margin` to match. Lengthwise the room is
`antenna_gap` alone, so `antenna_gap = 0` is a press fit and warns too. The USB
end is flush on purpose — clearance there would push the socket off its opening.

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

**It does nothing while the pin channel is on**, which `dupont_housing` forces:
the spacer sinks into the channel and the board lands on the plinth tops, so only
the part *taller than the channel is deep* has any effect:

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
| yes | 15.2, grip 8.0 | 15.2, grip 8.0 |
| no (`dupont_housing` and `pin_slot` off) | 15.2, grip 6.8 | 15.7, grip 5.5 |

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
> the fit template, which exists to check that your board fits: you would reach
> for the pitch setting and nothing would move. An
> `assert` now catches any `pin_pitch` that is not one of the three.

Look at the last two columns together. The plate left standing *between* one
hole and the next is pitch − hole: 1.70 mm at 2.54 pitch, 1.30 mm at 2.00, and
**0.67 mm at 1.27** — under the 0.8 mm two perimeters want. The micro preset
cannot be printed as separate holes on a 0.4 mm nozzle, which is what the pin
channel is for.

**The holes are plain square bores** — `hole` across at the top, at the bottom
and everywhere between, with no lead-in chamfer and nothing to set for one. A
funnel is cut downward from the top face, so one deeper than the plate broke out
of the underside and the hole's narrowest point stopped being the size you asked
for; the old 65° `lead_angle` cut 1.07 mm into a 1.00 mm plate and left holes
0.1 mm oversize.

It costs nothing, because **the hole is a clearance hole by construction** —
whatever passes through it plus `hole_clearance`, so it is already wider than
that thing before anything is chamfered. Against the bare post that is 0.10 mm
per side at every preset, a hole 31% wider than the pin at 2.54 and 50% wider at
1.27. The funnel only helped a pin *find* a hole it already fitted, and what does
the finding is the pitch.

The exception is `hole_clearance = 0`, which the slider allows: the hole is then
exactly the post, printing shrinks it, and there is no chamfer left to disguise
it. Below 0.1 the console warns.

### The plastic surround

Tick `dupont_housing` and the openings are sized for the connector's **plastic
square surround**, so a fully housed Dupont goes through. Untick it and they go
back to the **bare metal post**, which is what you want if
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
| 3 | 15.2 | 12.0 |
| 6 | 15.2 | 9.0 |
| 10 | 17.2 | 5.0 |
| 15 | 22.2 | 0.0 — flush underneath |

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
channel is exactly as wide as a hole: the pins stay gripped and the board does
not move.

`dupont_housing` forces `pin_slot` on at any pitch, since a plastic surround
leaves no rib either, and holds `pin_slot_w` at or above the opening.

Two things follow, and the console prints both with your own numbers:

- **4 mm is clearance, not a fit.** A 0.64 mm pin gets three millimetres of air,
  located in neither direction. `pin_slot_w = 0` makes the channel as wide as a
  hole was, and the grip comes back.
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
a template full of separate holes is as unprintable as the tray.

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

| `pin_length` | 3 | 6 | 7 | 9 | 12 | 16 |
| --- | --- | --- | --- | --- | --- | --- |
| Pocket | 6.0 | 6.0 | 6.0 | **8.0** | 11.0 | 15.0 |
| Case height | 13.2 | 13.2 | 13.2 | **15.2** | 18.2 | 22.2 |

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
| 0.8 | 1.74 | Separate, two clean perimeters |
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

The topology tells you which you got. At the shipped defaults the trough and the
channel above it are the same width, so the two merge into one opening straight
through the floor and the tray is **genus 2** — one handle per row, and nothing
else passes through it. Seal the base and both close into blind pockets:
**genus 0**. The USB opening never counts either way, because it lets the outside
into a cavity that is already open at the top.

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
| Case height | 15.20 mm | 17.20 mm (+`floor_solid`) |
| Underside over a trough | open | **solid 2.00 mm** |
| Pin into the trough | 8.0 mm | 8.0 mm — unchanged |
| Genus | 2 | 0 |

**Genus 2 → 0 is the check that it worked.** Open, the tray's only through-holes
are the two pin channels, one per row — the USB opening lets air from outside
into a cavity that is already open at the top, so it adds no handle. Seal the
base and both channels become blind pockets, closed at the bottom by the slab and
open only upward into the cavity. Nothing passes through the tray at all.

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
it is also where the **board's own edge** lands — at `board_w` 28.86 that
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
edges. At the defaults that happens at `side_margin` 10.93. The wire channels
have nowhere to break out into once it does, and the console warns.

### Wire channels

Every pin hole has a channel beside it, so you can take a wire off a pin and
bring it **into the box** rather than down through the underside — for wiring a
sensor or a display to a GPIO inside the case.

There is no `wire_channels` tick: a tick and a width are two settings for one
decision, and with both of them there was no way to see which one was the reason
you had no channels.

**Size it for the WIRE, not for the pin.** What travels down the channel is a
wire, so the wire is what it is measured against: 26 AWG with its insulation on
is about 1.2 mm, while the pin's own hole at the 2.54 pitch is 0.84 — narrower
than common hook-up wire, which then will not lie in it. A 1.2 channel on that
pitch leaves **1.34 mm of rib** between one channel and the next, comfortably
over two perimeters.

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
refusing. **What that costs:** at `pin_pitch = 1.27` a 1.2 mm channel renders with
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

#### Depth

`wire_channel_d` is how far the channel carries on **below the hole plate**, into
the trough. Passing through the plate is not a choice — that part is
`hole_plate_t` — and this is the rest: the drop that opens a mouth into the
trough's straight side, so a wire can turn the corner and come out.

| `wire_channel_d` | Channel floor | Mouth into the trough |
| --- | --- | --- |
| 0 | 7.90 | none worth the name — **warned** |
| 0.4 | 7.50 | one extrusion tall |
| 1.2 | 6.70 | square with the channel |
| 3 | 4.90 | |
| 6 | 1.90 | |
| 12 | cut back to the trough's depth | |

At the channel's own width the mouth is square, which is where the default sits.
It is **clamped to the trough's depth** — past that there is nothing left to open
into, and on a sealed base a deeper cut would eat the slab that closes the
underside. With `terminal_recess` off it is held at 0, since there is no trough
below the hole at all. Both clamps say so on the console.

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
an RF window. **Measure your own board** — the default is a starting point, not a
spec.

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
| `usb_opening` on | 60.42 | 5.5 |
| `usb_opening` off | 61.42 | 5.5 |

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
length   = 2 * wall + board_length + antenna_gap
interior = max(row_spacing + 2 * side_margin, board_w)
width    = interior + 2 * wall
```

where `board_length` is `board_l`, or `(pin_count - 1) * pitch +
2 * board_end_margin` when `board_l` is 0. Set `length_override` /
`width_override` to a non-zero value to pin either outright.

**`side_margin` measures to the INNER face**, so it is clearance you can see
inside the box. It does not carry the wall: thicken `wall` and the case grows
outward while the room beside the pins stays where you put it.

| `wall` | Interior | Outside |
| --- | --- | --- |
| 1.6 | 31.26 | 34.46 |
| 2.4 | 31.26 | 36.06 |
| 3.2 | 31.26 | 37.66 |

That `max` is what makes `board_w` work: the interior used to come from the
header alone, so growing the board past the case was an error rather than a
bigger case. Whichever asks for more room wins, and the console names it.

The two terms cross at `side_margin = (board_w - row_spacing) / 2`. Below that
the board sets the interior and moving `side_margin` changes nothing; above it,
`side_margin` sets it 1:1. The console names which one won.

**`side_margin` has a floor, and it clamps rather than errors.** The cut through
the plate — the pin channel, or the hole with no channel — is centred on the row,
so half of it has to clear the wall or it opens into the side of the case. Ask
for less and you get that minimum, with a note saying so:

| `pin_slot_w` | Floor under `side_margin` |
| --- | --- |
| 3 | 1.5 |
| 6 | 3.0 |
| 10 | 5.0 |
| no channel — bare 0.84 hole | 0.42 |

The floor moves with the cut, so it is right at every setting rather than a fixed
number that happens to suit the shipped one. Every value on the slider renders.

- **Screw bosses add to it instead of fitting inside it.** A corner boss needs
  width the header does not, so `closure = "screw"` puts a full `boss_d` on
  *each* side on top of what `side_margin` asked for:

  | `closure` | Case width |
  | --- | --- |
  | `friction` | 34.46 |
  | `screw` | 43.46 |

> There is no `end_margin` any more. It set the distance from the end pin to the
> outer face, which the flush board now decides at the USB end and `antenna_gap`
> decides at the far end. Use `board_end_margin` to move the header on the board.

### USB opening

`usb_type` picks the connector. The openings are **flush mount**: sized to the
socket's own metal shell plus `usb_fit`, so the socket meets the wall
rather than a big hole being left for the plug to pass through.

| `usb_type` | Receptacle shell | Opening | Case height |
| --- | --- | --- | --- |
| `micro` | 7.50 × 2.50 | 8.50 × 3.50 | 15.2 |
| `c` | 8.95 × 3.20 | 9.95 × 4.20 | 15.4 |
| `mini` | 7.70 × 4.00 | 8.70 × 5.00 | 16.2 |
| `a` | 13.00 × 5.70 | 14.00 × 6.70 | 17.9 |
| `custom` | — | `usb_w` × `usb_h` | 17.2 at 12 × 6 |

Sockets vary far less between boards than cable overmoulds do, which is what makes
flush mount worth having — but measure yours, and use `custom` if it disagrees,
where `usb_w`/`usb_h` are the finished opening and include your own fit.

**The opening is positioned automatically, not by `opening_z`.** A flush hole has
to line up, and the socket stands on the board's *top* face, so that face is the
only thing that can decide where the opening goes:

```
usb_z = board_under + board_t - usb_fit/2   = 0.0 + 1.6 - 0.5 = 1.1

board_under = pcb_standoff - board_drop, i.e. 0 while the channel swallows
the spacer.  With no channel it is pcb_standoff, and usb_z is 2.3.
```

Measured on the mesh: the wall is solid to **z 10.10** and open from there to the
rim at 13.60, the lid sitting low enough that the opening still reaches the top
edge. A 2.5 mm micro shell on the board's top face (10.60) occupies 10.60–13.10 —
**0.50 mm clear beneath it.** At the old fixed `opening_z = 0.5` that same opening
would have caught 0.8 mm of the shell and missed the rest. `opening_z` still
places the *far end* opening, which has no socket to meet.

**The opening is the connector's shape, not a rectangle.** On a flush mount every
corner the real shell curves away from is a gap left behind.

| `usb_type` | Outline | Width, bottom to top |
| --- | --- | --- |
| `micro` | Trapezoid, wider at the top | 7.60 → 8.50 |
| `mini` | Trapezoid, wider at the top | 7.50 → 8.70 |
| `c` | Obround, radius = half the height | 9.95 at mid-height, tapering to the caps |
| `a` | Rectangle — genuinely is one | 14.00 throughout |

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
| no channel at all — `dupont_housing` **and** `pin_slot` off | 2.3 | 6.8 | 15.2 |
| `pin_slot_w = 0` (2.70 mm channel, under `strip_w`) | 2.3 | 6.8 | 15.2 — spacer bridges it |
| `pin_slot_w = 3` | 1.1 | **8.0** | **15.2** |
| `pin_slot_w = 4` | 1.1 | **8.0** | **15.2** |
| `pin_slot_w = 4`, `pin_slot_depth = 1` | 1.3 | 7.8 | 15.2 |
| `pin_slot_w = 4`, `pin_slot_depth = 12` | 1.1 | 8.0 | 15.2 — capped |

The first row needs **both** off: `dupont_housing` forces `pin_slot` on, so
turning `pin_slot` off alone changes nothing while the surround is ticked.

**The test is `strip_w`, not the pitch.** The board rests on the plastic spacers
the pins pass through, about **3 mm** square on a devkit — wider than the 2.54
pitch this used to assume. A channel narrower than a spacer is bridged by it; one
that wide or wider swallows it:

| `pin_slot_w` | vs `strip_w` 3.0 | USB `z` | Case |
| --- | --- | --- | --- |
| 0 (2.70 mm channel) | bridged | 2.3 | 15.2 |
| 2.9 | bridged | 2.3 | 15.2 |
| 3.0 | swallowed | 1.1 | 15.2 |
| 4.0 | swallowed | 1.1 | 15.2 |

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
| `pin_slot` on, 3 mm channel | 15.2 | 1.1 | 8.0 |
| `dupont_housing` on | 15.2 | 1.1 | 8.0 |

An earlier version suppressed the drop for the surround, reasoning that the
housings rise to the floor's top face and the strip lands on *them*. **A housed
Dupont is pushed up from below and held by friction on its pin, over a trough
open at the underside — it is not standing on anything.** It follows the board
down and cannot hold it up. A connector only pushes back on a sealed base, where
it bottoms out on the slab, and that has its own warning.

### Height

`cavity_h = 0` derives the interior height, taking the largest of three demands:
what stands on the board, what the lid's rib needs to clear it, and what the
buttons need if the closed lid is not to hold them down.

```
cavity = max(board_top + max(component_h, usb_shell_h),   1.6 + 2.5             = 4.1
             board_top + rib_h + 0.4,                     1.6 + 2.1 + 0.4       = 4.1
             board_top + button_h + button_gap + flange)   1.6 + 1.5 + 0.3 + 0.6 = 4.0
```

**The buttons lose, so they cost no case height at all.** A 4.5 × 4.5 tact
stands about 1.5 mm off the PCB where the radio can stands 2.5, and the only
thing the button adds above it is a 0.6 mm flange:

```
   lid underside  ─────────────────  4.1 above the board, set by the components
                    flange 0.6
   flange face    ─────────────────  1.9, so 0.4 of air over the switch
   switch top     ─────────────────  1.5
   board top      ═════════════════  0
```

An earlier cut of this button had a tip under the flange to hold it off the
switch, and *that* cost 0.5 mm — 15.2 instead of 14.7. Making the flange's own
face flat and letting it press the switch gave the 0.5 back. Height only moves
now when the switch itself passes the components:

| `button_h` | **1.5** | 2.5 | 3.0 | 4.0 | 6.0 |
| --- | --- | --- | --- | --- | --- |
| Cavity | **4.6** | 5.6 | 6.1 | 7.1 | 9.1 |
| Case height | **15.2** | 16.2 | 16.7 | 17.7 | 19.7 |

The console names whichever of the three won, and says what the other two were
asking for. `button_board = "none"` takes the term out of the `max()` entirely
and the case goes back to 14.7.

**Getting the joint out of the way took three goes**, and then the buttons bought
half a millimetre of it back:

| | Cavity | Case | Air over the components | Set by |
| --- | --- | --- | --- | --- |
| Groove in the wall, depth 4.0 | 10.0 | 19.0 | 4.1 | the joint |
| Rib inside the wall, `rib_h` 2.5 | 8.5 | 17.5 | 2.6 | the joint |
| Rib notched around the socket | 5.9 | 14.9 | 0.6 | the components |
| Plus `rib_h` 2.1, socket in the stack | 4.1 | 14.7 | 0 | the components |
| **Plus a separate press button** | **4.6** | **15.2** | **0.5** | **the buttons** |

The first four rows are history — how the joint stopped setting the height. The
last is where it stands: the components would close the lid at 4.1 and the rib
would allow it, and the buttons ask for less than either. Set
`button_board = "none"` and nothing about the height changes at all.

**The socket counts as a component.** The cavity takes the larger of
`component_h`, which you measured, and `usb_shell_h`, which `usb_type` implies, so
a tall connector cannot be forgotten and the lid does not close onto the socket.
Measured at the shipped defaults, buttons and all — `micro` is the one case where
the buttons are what set the height, so it is the only row that moves if you turn
them off:

| `usb_type` | Shell | Cavity | Case | Set by |
| --- | --- | --- | --- | --- |
| `micro` | 2.50 | 4.6 | 15.2 | the buttons |
| `c` | 3.20 | 4.8 | 15.4 | the socket |
| `mini` | 4.00 | 5.6 | 16.2 | the socket |
| `a` | 5.70 | 7.3 | 17.9 | the socket |

The rib hangs around the perimeter and only overlaps the board at the USB end.
Cut it away over the socket's width and the tallest thing it has to miss is the
board's own top face — `board_top + rib_h` instead of `opening_top + rib_h`,
2.6 mm lower. The far-end opening is notched the same way.

So `rib_h` is free up to `component_h − 0.4` — **2.1** at the defaults, where it
now sits, so the joint costs no height at all. With the buttons on it is free
further still, because they are holding the lid higher than the rib needs:

| `rib_h` | 1.5 | 2.0 | **2.1** | 3.0 | 4.0 |
| --- | --- | --- | --- | --- | --- |
| Case height | 15.2 | 15.2 | **15.2** | 15.6 | 16.6 |

`component_h` and `button_h` are what move the lid now: set them to your tallest
part and your switch and the lid comes down to meet whichever wins, with the
console naming it.

**The pocket is the biggest single lever.** The floor is `pocket + hole_plate_t`
= 9.0 mm of the 15.2 mm total, well over half the case.

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

**`latch_location` picks which walls carry them**, and it is the only switch:
there is no separate on/off, because `none` already says that.

| `latch_location` | What you get |
| --- | --- |
| `none` | The press fit on its own. The rib still locates the lid and grips, but nothing holds it down. |
| `sides` | `latch_count` down each long side — 2 each, so four balls. |
| `ends` | Two at the USB end and two at the antenna end, none down the sides. **Default**, and also four balls. |
| `both` | All of them — eight at the defaults. |

`latch_count` only ever answers *how many down each long side*, so it starts at 1
rather than 0; turning the sides off is `latch_location`'s job, not a second way
of saying the same thing. It follows that **on a stock case `latch_count` does
nothing** — the default latches the ends — so move the location to `sides` or
`both` before reaching for it.

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

#### The end latches

The default latches the two ends, and they always come **two per end** — never
one, never three.

That is forced, not chosen. Each end's rib has an opening notched out of its
middle — the USB socket at one end, `end_opening` at the other. The balls are
unioned into the lid *before* that notch is cut, so one sitting in the notch's
width would come out sliced in half, and a single ball off to one side would cock
the lid. Two, straddling the opening, is the only arrangement that works.

Where they sit across the width is derived, not set. Each takes the middle of the
rib run left between the rounded corner and the opening's edge, both limits
backed off by the tray's dimple radius, because the dimple is the larger of the
two spheres. Change `usb_type`, `usb_fit` or `end_w` and they move on their own.
At the defaults, measured off the mesh:

| End | Its opening, `y` | Room for a ball centre | Ball centres, `y` |
| --- | --- | --- | --- |
| USB | 11.78 – 20.28 | 3.65 – 11.13 | **7.39** and **24.67** |
| Antenna | none (`end_opening` off) | 3.65 – 15.38 | **9.52** and **22.55** |

They bite the same as the side latches do — **0.447 mm** into the wall, leaving
**1.153 mm** behind — because they are the same ball on the same rib face, only
pointing along the case instead of across it. The console prints where they
landed.

Wide enough openings leave nothing between the notch and the corner. That end is
then **dropped rather than shoved somewhere it cannot seat**, and the console
says which end, what stopped it, and what the case would have to widen to. At
`corner_r` 12 the USB end goes; at `end_w` 28.8 the antenna end goes. Nothing
asserts, and the report reads

```
2 latches: ends at y NONE USB / 14.015 antenna
```

so a missing pair never looks like a setting that did nothing.

### Lid

Vents sit in a patch over the radio module — the only part of a devkit that gets
meaningfully warm — rather than spread across the plate, which keeps the rest of
the lid solid and leaves room for the label. The patch defaults to **15 × 15 mm**,
positioned with `vent_from_end`, `vent_zone_l` and `vent_zone_w`. `vent_from_end`
is measured from the board's far edge, so the patch stays over the module whatever
the antenna bay is.

Vents are always cut from **artwork in an SVG**, named by `vent_file`. Three ship
with the model:

| File | What it is |
| --- | --- |
| [`esphome.svg`](esphome.svg) | The ESPHome logo. **The default** — and the one file here that is not ours, so read [Third-party assets](#third-party-assets) before you ship it |
| [`slots.svg`](slots.svg) | Five plain bars across the patch |
| [`wifi.svg`](wifi.svg) | The wifi symbol |

`vent_rotate` turns the artwork on the lid, counter-clockwise as you look down at
the closed case. **Zero is not "as drawn"** — artwork is laid down a quarter turn
clockwise from how it sits in the file, which stands `slots.svg` bars up across
the case, puts `wifi.svg` dot-beside-the-label and points `esphome.svg` toward
the far end, so 0 is the orientation you want. The turn is applied before
scaling, so `vent_zone_l` always measures across the finished orientation.

`vent_fit` either keeps the artwork's proportions or stretches it to
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
> the lid used; an unvented lid is the symptom. The tray and template are
> unaffected, as is the lid with `vents = false`.

### Buttons

The devkit's **EN** and **BOOT** switches come up through the lid, so you can
reset and flash the board without taking the case apart. Each one is a
**separate printed part**: a stem that stands proud through a plain hole in the
lid and a flange underneath that keeps it captive and comes down flat on the
switch. It is fed in from inside the lid, stem first. All the lid gets is the
hole. Print them with `part = "button"`.

`button_board` is the pick list and the switch that turns the feature off. Pick
your devkit and the buttons are placed for it, **measured off the board's own
USB-end corner** — so an entry follows `board_w` and the header rather than being
pinned to a spot in the case. Resize the case and it keeps up.

| `button_board` | x from the USB edge | Inset from each side edge |
| --- | --- | --- |
| `none` | — | no buttons at all |
| `devkitc` | 6.5 | 4.0 |
| `doit` | 6.0 | 4.0 |
| `s3` | 8.0 | 4.5 |
| `custom` | — | the four coordinates below |

> **Those figures are estimates, not specifications.** They are where the buttons
> sit on a typical board of that family — the same standing `pin_x_offset = -1.0`
> has. Measure yours, and use `custom` if they disagree.

> #### Why the four coordinates hold real numbers rather than 0
>
> They used to sit at `0`, meaning "use the entry's figure". Picking
> *ESP32-DevKitC* placed the buttons correctly — but the four boxes still read
> **0**, so the panel gave no sign anything had happened.
>
> That cannot be fixed by tuning it. **OpenSCAD's Customizer cannot write one
> parameter from another.** It reads each field's default out of the file and
> lets you edit it; nothing in the panel computes. A named entry therefore
> cannot fill the boxes in.
>
> So they default to the **DevKitC positions** instead. The panel always shows a
> real place, and switching to `custom` starts you exactly where the shipped
> board leaves off rather than at the corner of the case. The console prints what
> your chosen entry works out to, computed for the case you actually got, so
> copying an entry into `custom` is a paste:
>
> ```
> Buttons: button_a_x / _a_y / _b_x / _b_y are not used at button_board =
> devkitc, which places them from the board's own corner. To take over from it,
> set button_board = custom and button_a_x = 8.1, button_a_y = 7.53,
> button_b_x = 8.1, button_b_y = 24.53 — the same place, in this case's own
> coordinates. The entry follows the board if you resize the case; those four
> numbers would not.
> ```
>
> Switch to `closure = "screw"` and the same line comes back reading **12.03 /
> 29.03**, because the case got wider and the entry moved with the board.

On this board the three entries work out to:

| Board | `button_a_x` | `button_a_y` | `button_b_x` | `button_b_y` |
| --- | --- | --- | --- | --- |
| **ESP32-DevKitC 38-pin** | **8.1** | **7.53** | **8.1** | **24.53** |
| DOIT DevKit v1 30-pin | 7.6 | 7.53 | 7.6 | 24.53 |
| ESP32-S3-DevKitC | 9.6 | 8.03 | 9.6 | 24.03 |

#### Placing them yourself

The four coordinates measure **in from the case's outer faces** — the two you can
put a rule against on the finished print:

```
   case from above: USB end to the LEFT, y = 0 along the BOTTOM edge

   +--------------------------------------------------+
   |                                                  |
   |        (o) B  . . . . . . . . . . . . .  24.53   |
 [USB]                                                |
   |        (o) A  . . . . . . . . . . . . .   7.53   |
   |         :                                        |
   +---------+----------------------------------------+
   :         :
   :<- 8.1 ->:      devkitc, on the board this file ships with:
   :                    button_a_x = 8.1   button_a_y =  7.53
   x = 0                button_b_x = 8.1   button_b_y = 24.53
```

**x** is measured in from the USB end's outer face; **y** in from the near long
side's outer face — the bottom edge above.

At `button_board = "custom"` they are the case's own coordinates, so **what you
type is where it is** — no magic value and nothing hidden. Set one and only that
button's one axis moves:

```
button_a_y = 5

A 8.1 / 5 in from the case faces = 6.5 / 1.47 in from the board's USB corner
WARNING: button A at x 8.1 y 5 runs its flange 1.5 mm into the lid's rib ...
```

> #### The USB end is stable; the width is not
>
> The board sits hard against the inside of the USB wall, so **x is fixed against
> your board** and only `wall` moves it. Grow the antenna bay, change
> `pin_count`, override the length — a button at x 8.1 stays over the same spot
> on the PCB:
>
> ```
> antenna_gap 5    A 8.1 / 7.53 in from the case faces = 6.5 / 4 in from the board's USB corner
> antenna_gap 15   A 8.1 / 7.53 in from the case faces = 6.5 / 4 in from the board's USB corner
> ```
>
> **Across the width it is not.** The board is centred, so anything that widens
> the case — `side_margin`, `board_w`, `width_override`, or `closure = "screw"`,
> which adds a whole `boss_d` each side — moves the board's edges away from
> `y = 0` and slides a y you set relative to the board. The board entries are
> immune, because they are re-derived from where the board actually is rather
> than stored as a spot in the case:
>
> ```
> friction   A 8.1 /  7.53 in from the case faces = 6.5 / 4 in from the board's USB corner
> screw      A 8.1 / 12.03 in from the case faces = 6.5 / 4 in from the board's USB corner
> ```
>
> That is why the console prints each button **both ways**, and derives both from
> the finished position rather than from the settings. The drift lands on the
> line instead of in the print.

#### Why it is a separate part

The first version of this was a **printed flexure**: the cap cut free on three
spring arms so the whole lid stayed one part. On paper it was sound — the arms
ran 108° around the cap so the bending strain came out near 2 %, inside what PLA
takes.

**It broke after a few presses.** That is the useful result, and it is worth
stating rather than quietly replacing: an arm that survives one press at 2 %
strain is not an arm that survives a thousand, and *fatigue* is not something the
strain figure predicts. A printed part is layers with bonds between them, and a
bond that is loaded in bending a few hundred times fails long before the material
does. No amount of tuning an arm's thickness fixes a design whose job is to bend
in PLA for years.

So the flexing is gone entirely. Nothing on the button bends, and nothing on the
lid does either:

```
            │ │         stem   the hole less button_fit, standing button_proud
            │ │                proud — its top face is what you press
   ═════════╡ ╞══════   lid    hole = button_d − 2.0
       _____│ │_____
      |_____________|   flange button_d across, 0.6 thick, SOLID — and its
                             FLAT underside is what presses the switch
        ___#####___     switch
   ══════════════════   PCB
```

> **Only one end is wider than the hole, and it is the flange.** That is not a
> detail, it is what makes the part assemblable: fed in from inside the lid, the
> whole stem — the pressed top included — passes through the bore, and the flange
> stays behind and cannot follow.
>
> The first cut of this had a wide head on top as well. **It could not be
> assembled at all** — a disc bigger than the hole at each end of a captive stem,
> with no way in short of moulding the lid around it. If you change these
> dimensions, that is the rule to keep.

**What holds the button up is the switch's own dome.** It is stiffer than a
fraction of a gram of plastic by a factor of thousands, so it pushes the button
until the flange meets the lid's underside, and that is the rest position. Press
and the button slides down its hole; let go and the dome returns it. The flange
carries no load in service at all — it is the stop the dome pushes it against.

It is **captive upward, not downward**: with the lid off, turn it over and the
button drops out into your hand, so fit the lid to the tray with the buttons
already in it. Closed, it cannot go anywhere. There is deliberately no slack
setting between flange and plate — slack would come straight out of the same
vertical budget the flange needs, and a tenth either way from print tolerance is
free play nobody can feel.

Three numbers are **derived rather than offered**:

| Derived | Value | Why there is no second right answer |
| --- | --- | --- |
| lip | 1.0 | The shoulder the flange catches on. Under two perimeters it shears off; over it is only a narrower button behind the same flange |
| flange thickness | 0.6 | Three 0.2 mm layers. A solid disc with nothing to flex has no reason to be thicker, and every extra tenth is a tenth of case height |
| flange thickness | 0.6 | Three 0.2 mm layers. A solid disc with nothing to flex has no reason to be thicker, and every extra tenth is a tenth of case height |

#### Assembly

**The buttons go in from inside the lid, stem first.** Hold the lid upside down,
push each button's 2.7 mm stem up through its 3.0 mm hole until the 5.0 mm flange
is flat against the underside, then fit the lid to the tray. The flange is the
only part wider than the hole — which is what lets it go in at all — and it
cannot come back out the top.

It *can* drop out downward from a bare lid, so fit the lid to the tray with the
buttons already in it. That is the price of having no snap feature, and a snap
feature is a thin flexing thing of exactly the kind that just failed.

`part = "button"` prints both, laid out side by side. They are in the `all`
layout too.

#### Printing them

**Flange down on the bed**, and it is the easiest part in the model to print
because of it. The flange's underside is flat and it is the widest thing on the
button, so the first layer is the full 5.0 mm disc — a solid, stable footprint —
and the only step above it goes *inward*, to the stem.

**Measured downward-facing area: 0.00 mm².** Not small, none: there is no
overhang anywhere on the part, at any setting, and nothing to bridge.

That is what the tip cost. With one under the flange the part had to print stem
down, which put a 1.15 mm unsupported annular ledge at the flange — **21.1 mm²
per button** — and it is why the first version would not print.

`button_fit` is the number that decides whether this works on your printer. It
comes off the **stem**, never out of the hole, so the lid's opening stays the
number the panel says and every tolerance lives on the loose part — the one you
can reprint on its own when it binds. 0.3 total, 0.15 a side, slides freely on a
well-tuned 0.4 mm nozzle. It is a clearance, never an interference: a button
pressed into its hole is a button that has stopped moving.

#### Room

**On a devkit-width case the rib is what runs out of room first**, and it is the
flange that binds — the hole through the plate is 2.0 mm smaller, but the flange
swings below the lid at the full `button_d`, in exactly the band where the rib
hangs. Two 7 mm flanges on a 25 mm board, 4 mm in from each edge, leave
**2.03 mm** of plate. That is reported on the console rather than warned about,
because it is a real number you can spend: `button_d` spends it, `side_margin`
buys more.

The model also warns when a button lands off the board, when the two overlap,
when one runs into the vent patch or under the label, when `button_fit` is tight
enough to seize, when `button_proud` is too short to still be proud at the bottom
of the stroke, and when `cavity_h` is pinned so low that the closed case would
hold the buttons down.

> **Only the flexure has been printed and tested — and it failed.** The part that
> replaced it has not. Whether 0.3 mm of `button_fit` slides on your printer and
> whether 0.3 mm of `button_gap` feels right are the two things only a print will
> tell you, and both are cheap to iterate: the button is a 4 mm disc that prints
> in under a minute, without reprinting the lid.

**The fit template deliberately shows nothing for the buttons.** It looks like
the place for it, but the template works by having you drop the board *into* it,
which puts the board on top of the floor — a mark at a button's position would end
up underneath it. What checks the positions is the console line and the
`assembled` preview.

## Every parameter

Generated from the `.scad` itself, so it cannot drift, and grouped as the
Customizer groups them. **Range** is the slider's own limits; where a value inside
them cannot be built, the model stops with a message naming the fix.

### Part

| Parameter | Range | What it does |
| --- | --- | --- |
| `part` | 6 choices | Which part to render |
| `layout_gap` | 0 – 40 | Gap between parts in the print layout (mm) |

### Pin header

| Parameter | Range | What it does |
| --- | --- | --- |
| `pin_count` | 1 – 60 | Pins per row. Two rows, one down each long side. |
| `row_spacing` | 5 – 60 | Centre-to-centre between the two pin rows, across the width. 25.4 is the other common one. (mm) |
| `pin_x_offset` | -20 – 20 | Shift the header along the length. Negative moves it toward the USB end. (mm) |

### Pin pitch / Dupont preset

| Parameter | Range | What it does |
| --- | --- | --- |
| `pin_pitch` | 3 choices | Pin pitch: centre to centre along the header. Sets the Dupont post size too. |
| `dupont_housing` | true / false | Size the openings for the connector's plastic surround, not the bare pin. |
| `hole_clearance` | 0 – 1.5 | Added to the post (or the surround) to get the hole. Raise if pins bind. (mm) |
| `pin_slot` | true / false | Replace the row of holes with one continuous channel down each pin row. |
| `pin_slot_w` | 0 – 10 | Pin channel width. 0 = as wide as a hole, which keeps the pins gripped. (mm) |
| `pin_slot_depth` | 0.5 – 12 | How far the pin channel cuts down from the floor's top face. (mm) |
| `wire_channel_w` | 0 – 3 | Wire channel width, sized for the wire. 0 is no channel at all. (mm) |
| `wire_channel_d` | 0 – 12 | How far the channel reaches below the hole plate, into the trough. (mm) |

### Terminal recess

| Parameter | Range | What it does |
| --- | --- | --- |
| `seal_bottom` | true / false | Close the underside with a solid slab, so the base has no holes in it. |
| `terminal_recess` | true / false | Sink the connectors into troughs in the floor so they finish flush. |
| `terminal_len` | 1 – 25 | Trough depth: how much connector is buried. The rest shows below the case. (mm) |
| `hole_plate_t` | 0.6 – 4 | Material left above the trough, which the pin holes run through. (mm) |
| `pocket_wall` | 0 – 3 | Wall between one trough pocket and the next. This is what sizes them. (mm) |
| `floor_relief` | true / false | Thin the floor down the middle, leaving a plinth along each pin row. |
| `plinth_wall` | 0.4 – 5 | Material left each side of a trough. (mm) |

### Board

| Parameter | Range | What it does |
| --- | --- | --- |
| `board_l` | 0 – 200 | PCB length. 0 = derive from the header. (mm) |
| `board_w` | 10 – 200 | Your PCB's width, measured across it. (mm) |
| `board_end_margin` | 0 – 20 | Added each side of the header to get the auto PCB length (mm) |
| `pcb_standoff` | 0 – 10 | The header spacer's height: a measurement of your header, not a lever. (mm) |
| `strip_w` | 0.5 – 12 | The header spacer's width across the row. MEASURE YOURS. (mm) |
| `pin_length` | 1 – 20 | Measured off the PCB: its underside down to the pin tip, spacer included. (mm) |
| `board_t` | 0.4 – 5 | PCB thickness. Only used to work out how tall the cavity has to be. (mm) |
| `component_h` | 1 – 40 | Tallest thing standing on top of the board, from its upper face. (mm) |

### Case size

| Parameter | Range | What it does |
| --- | --- | --- |
| `length_override` | 0 – 250 | Outer length. 0 = derive from the header. (mm) |
| `width_override` | 0 – 250 | Outer width. 0 = derive from the header. (mm) |
| `antenna_gap` | 0 – 30 | Clear air past the board's far edge, for the module's antenna. (mm) |
| `side_margin` | 0 – 30 | Pin row centre to the INNER side face: clearance beside the pins. (mm) |
| `wall` | 1 – 6 | Wall thickness, and the reach a USB plug has to find past it. (mm) |
| `floor_solid` | 0.8 – 8 | Floor thickness away from the plinths, or the whole floor with no recess. (mm) |
| `lid_t` | 0.8 – 8 | Lid plate thickness (mm) |
| `cavity_h` | 0 – 60 | Interior height above the floor. 0 = derive it from what has to fit. (mm) |
| `corner_r` | 1 – 12 | Outer corner rounding (mm) |

### Closure

| Parameter | Range | What it does |
| --- | --- | --- |
| `closure` | 2 choices | How the lid is held on |
| `rib_w` | 0.4 – 3 | Thickness of the rib under the lid that drops inside the wall. (mm) |
| `rib_h` | 0.5 – 6 | How far that rib hangs into the cavity. THIS SETS THE CASE HEIGHT. (mm) |
| `joint_clearance` | 0 – 0.6 | Clearance all round the joint. Raise if the lid is tight. (mm) |
| `screw_d` | 1 – 6 | Screw clearance hole in the lid, e.g. 2.2 for M2 (mm) |
| `screw_pilot_d` | 0.8 – 5 | Pilot hole in the boss, e.g. 1.6 for an M2 self-tapper (mm) |
| `boss_d` | 2 – 12 | Screw boss outer diameter (mm) |
| `latch_location` | 4 choices | Which walls carry the lid's ball latches. |
| `latch_count` | 1 – 6 | How many down each long side. Ignored unless `latch_location` includes the sides. |
| `latch_grip` | 0.1 – 1 | How far the ball squeezes past the wall. This has to survive your printer. (mm) |
| `latch_fit` | 0 – 0.4 | Slack in the dimple so the ball seats. Comes off the lip, so keep it small. (mm) |

### Openings

| Parameter | Range | What it does |
| --- | --- | --- |
| `usb_opening` | true / false | Opening in the near end wall, for the USB socket |
| `usb_type` | 5 choices | Which USB connector your board has. Sets the opening size and shape. |
| `usb_overhang` | 0 – 4 | How far the socket overhangs the board's edge. This is the plug's reach. (mm) |
| `usb_w` | 1 – 60 | Custom opening width, taken as the finished hole. Include your own fit. (mm) |
| `usb_h` | 1 – 40 | Custom opening height, taken as the finished hole. (mm) |
| `end_opening` | true / false | Opening in the far end wall |
| `end_w` | 1 – 60 | Far end opening width (mm) |
| `end_h` | 1 – 40 | Far end opening height. (mm) |
| `opening_z` | 0 – 30 | Height of the far end opening above the floor's top face. (mm) |
| `usb_fit` | 0 – 3 | Slack in the USB opening, total across the socket's shell. (mm) |

### Buttons

| Parameter | Range | What it does |
| --- | --- | --- |
| `button_board` | 5 choices | Which devkit's buttons to place. Custom hands it to the four coordinates below. |
| `button_a_x` | 0 – 250 | Button A from the USB end's outer face. Used at button_board = custom. (mm) |
| `button_a_y` | 0 – 250 | Button A from the near side's outer face. Used at button_board = custom. (mm) |
| `button_b_x` | 0 – 250 | Button B from the USB end's outer face. Used at button_board = custom. (mm) |
| `button_b_y` | 0 – 250 | Button B from the near side's outer face. Used at button_board = custom. (mm) |
| `button_h` | 0.3 – 10 | How far the switch's actuator stands above the board's top face. (mm) |
| `button_gap` | 0.1 – 2 | Air under the button's flange at rest. Too little and the case holds the button on. (mm) |
| `button_d` | 3 – 20 | The button's width: the flange, the flat bottom, and what presses the switch. (mm) |
| `button_proud` | 0.2 – 6 | How far the stem stands proud of the lid's top face at rest. (mm) |
| `button_fit` | 0.05 – 1 | Clearance between the stem and the lid's hole. Raise if it binds, lower if it rattles. (mm) |

### Lid

| Parameter | Range | What it does |
| --- | --- | --- |
| `label` | — | Text engraved into the lid. Blank for none. |
| `label_size` | 2 – 20 | Label size (mm) |
| `label_depth` | 0.2 – 2 | How deep the label is engraved (mm) |
| `label_x` | 0 – 250 | Where the label sits along the length. 0 = auto, centred in the space left. (mm) |
| `label_rotate` | -180 – 180 | Turn the label. 0 is as you typed it. (degrees) |
| `vents` | true / false | Cut vent artwork through the lid, over the radio module. |
| `vent_from_end` | 0 – 80 | Centre of the vent patch, measured from the board's far edge. (mm) |
| `vent_zone_l` | 2 – 80 | Length of the vent patch, along the case (mm) |
| `vent_zone_w` | 2 – 60 | Width of the vent patch, across the case. (mm) |

### Vent artwork

| Parameter | Range | What it does |
| --- | --- | --- |
| `vent_fit` | 2 choices | How the artwork is scaled into the vent patch. |
| `vent_rotate` | -180 – 180 | Turn the vent artwork before it is cut. (degrees) |
| `vent_file` | — | Artwork file for the lid vents. It must sit beside this .scad. |
| `vent_format` | 2 choices | Artwork format. SVG is a true outline; PNG is traced and wobbles. |
| `vent_level` | 0 – 100 | PNG only: brightness cut-off. Pixels brighter than this become openings. |
| `vent_invert` | true / false | PNG only: cut the dark parts instead of the light ones |

### Fit template

| Parameter | Range | What it does |
| --- | --- | --- |
| `template_t` | 0.4 – 4 | Floor thickness of the fit template. (mm) |
| `template_rim` | 0 – 15 | How high the fit template's wall stands. (mm) |

## Printing

**No supports needed.** Measured off the exported meshes, not assumed:

| Part | `latch_location` | Surface below 45° | below 55° | below 60° |
| --- | --- | --- | --- | --- |
| Tray | `none` | 0.00 mm² | 0.00 mm² | 0.00 mm² |
| Tray | `ends` (default) or `sides` | 0.50 mm² | 1.02 mm² | 1.67 mm² |
| Tray | `both` | 1.01 mm² | 2.04 mm² | 3.34 mm² |
| Lid | `none` | 0.00 mm² | 0.00 mm² | 0.00 mm² |
| Lid | `ends` (default) or `sides` | 0.85 mm² | 1.38 mm² | 1.99 mm² |
| Lid | `both` | 1.71 mm² | 2.75 mm² | 3.98 mm² |
| Template | — | 0.00 mm² | 0.00 mm² | 0.00 mm² |

Downward-facing area within that many degrees of horizontal, with the faces lying
on the build plate excluded — count those and you are measuring the bed.

**At `none` both parts measure a flat zero, so every downward face in the case is
a latch.** There is nothing else to bridge: the USB opening is slotted clear
through to the top of the wall for the socket's overhang, so its top edge is open
air rather than a bridge — the lid's tab fills the slot when the case is shut —
and the two pin channels run right through the floor, which is what the tray's
genus of 2 means, one handle per row. No ceiling over them either.

A half-round bump has a small flat patch at its lowest point, and that patch is
the whole figure. It bridges in a couple of layers.

**`sides` and `ends` measure identically, and `both` is exactly their sum.** That
is the check that the end latches are the same feature as the side ones rather
than something new — same ball, same dimple, same flat patch, only pointing along
the case instead of across it. The volumes say the same thing: each group of four
takes 1.246 mm³ out of the tray and puts 1.372 mm³ onto the lid, whichever walls
it is on. None of it needs support.

Otherwise the lid has nothing to bridge. `label` defaults to blank, and the
engraving is the only overhang on it: set one and you get the ceiling of the
lettering, 0.6 mm above the bed — about 32 mm² for `"ESP"` — bridged over a
glyph's width in the first two layers. The vent openings are cut clean through
and never overhang, whatever artwork you use.

**The buttons add nothing to the lid**, which is why the table above has no row
for them: the lid measures 0.85 / 1.38 / 1.99 mm² with them on and the identical
0.85 / 1.38 / 1.99 with `button_board = "none"`. All the lid gets is two plain
bores, vertical at every depth. With the buttons off it is **byte-identical** to
the lid before they existed, and the template is byte-identical either way; only
the tray changes, and only in height.

**The buttons themselves are the one part here that has an overhang**, and it is
deliberate:

| Part | Surface below 45° | below 55° | below 60° |
| --- | --- | --- | --- |
| Buttons (both) | 0.00 mm² | 0.00 mm² | 0.00 mm² |

Printed flange down, every step on the button goes inward from a flat 5.0 mm
first layer, so there is nothing to droop and nothing to bridge. Nothing bears on it — the face that bears is the
flange's *underside*, against the lid, and that one prints against the ledge
below it. See [Buttons](#buttons) for why a self-supporting cone was traded away.

Three features exist specifically to keep this true:

- **The troughs are square, and anything they do roof bridges.** On the current
  defaults they roof nothing at all: the trough is as wide as the pin channel
  above it, so the two merge into one opening straight through the floor and the
  measured area is 0.00 mm². Narrow the channel under the trough and a ceiling
  comes back — two strips 3 mm wide running the length of the header. That is a
  *bridge*, not an overhang: it is anchored on both walls, so the slicer spans the
  3 mm direction, which needs no support at a 0.4 mm nozzle. It is also why there
  are two narrow troughs rather than one full-width recess — 3 mm bridges, a 28 mm
  floor would not.

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
interior of 57.22 x 31.26, so it will run off the edge.
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
[`slots.svg`](slots.svg), [`wifi.svg`](wifi.svg) and this documentation — which
is an original design, written from scratch. It does **not** cover
`esphome.svg`, which came from somewhere else and keeps its own license. See
below.

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

**The logo is what the lid renders by default.** `vent_file` is set to
`esphome.svg`, so a stock `part = "lid"` cuts the ESPHome mark through the plate
— which means the attribution above travels with anything you publish, print for
someone else or sell. That is a licence obligation, not a formality: Apache 2.0
section 4 wants the notice kept, and section 6 grants nothing in the mark itself.

If you would rather not carry it, `vent_file = "slots.svg"` or `"wifi.svg"` swaps
in artwork that is part of this model and under its own CC BY 4.0, and
`vents = false` cuts none at all. Either of those frees you to delete
`esphome.svg` from your copy; note that the lid then prints without vents and
with `import()` reporting `ERROR: Can't open file` if `vent_file` still names the
missing one.

> Not legal advice. If you redistribute this, check the terms yourself.
