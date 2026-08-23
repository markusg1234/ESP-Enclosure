# ESP-Enclosure

A parametric ESP devkit enclosure for OpenSCAD, with the header broken out
through the floor.

The board sits up on four corner rests, hard against the inside of the USB end
wall so its socket lines up with the opening. Its header pins drop through a
thin hole plate into a trough under each row, and Dupont connectors push up into
those troughs from below — so the connectors finish **flush with the floor**
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
they are 4.5 cm³ against the tray's 13.7, and they cover the two ways a full
case goes wrong: the `template` says whether your board fits, the `coupon` says
whether your pins grip.

### Print the template first

Set `part = "template"`. It is a shallow stand-in for the tray — same footprint,
same interior outline, same pin holes in the same places, same rests, same screw
bosses — but 4.2mm tall instead of 20.9, and 3.9 cm³ of plastic against the
tray's 13.7.

Drop your actual devkit into it and you can see all three things at once:

| Check | What you are looking for |
| --- | --- |
| Does the board fit? | It drops between the walls without forcing |
| Does the header line up? | Every pin finds its hole, with the board seated flat on the rests |
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

Set `part = "coupon"`. It is a five-hole strip that takes about two minutes and
reproduces the real hole plate, each hole at a different clearance:

| Engraved digit | Hole size |
| --- | --- |
| 1 | nominal − 0.10 |
| 2 | nominal − 0.05 |
| 3 | nominal |
| 4 | nominal + 0.05 |
| 5 | nominal + 0.10 |

Push a header pin into each. Whichever fits the way you want, set
`hole_clearance` to match. Printers vary enough that this saves more time than
it costs.

The coupon and the template cut their holes with the same `plate_hole` module
the tray does, so neither can drift from what the case will actually give you.

That module caps the lead-in funnel at half the plate's thickness, which is what
makes the coupon trustworthy. The funnel is cut downward from the top face, so a
funnel deeper than the plate breaks out of the underside and the hole's
narrowest point stops being the size you asked for. The coupon is the plate at
its thinnest, so it fails first — exactly backwards for the part whose job is
reporting the real fit. With the cap, the nominal hole measures 1.00 mm with
0.5 mm of parallel bore, at every `lead_in` from 0.05 to 2.0.

### Check your pin length

This is the one thing most likely to catch you out. For a connector to grip, the
pin has to clear the standoff *and* the hole plate and still have 2–4mm left
over. The model works this out and prints it to the console:

```
ECHO: "Case 62.52 x 35.6 x 20.9168 mm | header 19 x2 @ 2.54 | 3.8 mm of pin
inside the trough | antenna bay 6 mm | rests 1.8/1.8 x 6"
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
| `row_spacing` | 22.86 | Centre-to-centre between the rows. 22.86 = 0.9", 25.4 = 1". |
| `pin_pitch` | 2.54 | Along the length. Used only when the Dupont preset is `Custom`. |
| `pin_x_offset` | 0 | Slide the header along the length. |

### Board and rests

| Parameter | Default | What it does |
| --- | --- | --- |
| `board_l` / `board_w` | 0 | PCB size. 0 = derive from the header. |
| `board_end_margin` | 3.0 | Header end pin to the board's edge. Sets where the header sits. |
| `pcb_standoff` | 1.2 | How far the board sits above the floor. |
| `board_t` | 1.6 | PCB thickness. Only feeds the cavity height. |
| `component_h` | 4.0 | Tallest thing on TOP of the board. The module is ~3.1mm. |
| `ledge_d` | 3.0 | Rest depth, in from the board's edge. 0 = no rests. |
| `ledge_w` | 6.0 | Rest width. Two per end, in the board's corners. |

The rests are **not** bars across the full width. The header pins carry and
locate the board, so four corner pads are all that is needed to stop it rocking
— and with the board flush against the USB wall there is no room for a bar there
anyway. Each pad is auto-trimmed to the room between the board's edge and the
nearest lead-in funnel, so a rest can never cap a hole; at the defaults that
trims `ledge_d` from 3.0 to 1.8. If there is no room at either end you get a
console warning rather than a silent bad case.

### Dupont size

The preset sets the post size and the pitch; `hole_clearance` is added on top.

| Preset | Pitch | Post | Hole at default clearance |
| --- | --- | --- | --- |
| 2.54mm standard | 2.54 | 0.64 | 1.00 |
| 2.00mm compact | 2.00 | 0.50 | 0.86 |
| 1.27mm micro | 1.27 | 0.40 | 0.76 |
| Custom | `pin_pitch` | `custom_post` | + `hole_clearance` |

### Terminal recess

| Parameter | Default | What it does |
| --- | --- | --- |
| `seal_bottom` | false | Cap the troughs so the base has no holes. Nothing else changes. |
| `terminal_recess` | true | Sink the connectors into the floor. Off = plain through-holes. |
| `terminal_len` | 6.0 | Trough depth. ~6 suits a bare crimp; a full plastic housing needs ~15. |
| `trough_w` | 3.0 | Trough width. |
| `hole_plate_t` | 1.0 | Material above the trough. Thinner leaves more pin to grip. |
| `pin_length` | 6.0 | How far your pins protrude below the PCB. **Measure this.** |
| `floor_relief` | true | Thin the floor everywhere the troughs do not run. |
| `plinth_wall` | 1.2 | Material each side of a trough, which sets the plinth width. |

`terminal_len` is what sets the case height — the floor becomes
`terminal_len + roof + hole_plate_t`, so hiding a longer connector makes a
taller case.

### Sealing the bottom

The troughs are the only thing that opens through the bottom of the case — the
pin holes stop at the trough, and the relieved floor is already solid.
`seal_bottom = true` puts a slab of `floor_solid` under them, so the base has no
holes in it at all.

**Nothing else changes.** The pin holes, the troughs, the plinths, the wire
channels and the rests all stay exactly as they are. The troughs simply become
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

   height 20.92 mm               height 22.92 mm
```

| | Default | Sealed |
| --- | --- | --- |
| Case height | 20.92 mm | 22.92 mm (+`floor_solid`) |
| Underside over a trough | open | **solid 2.00 mm** |
| Pin into the trough | 3.8 mm | 3.8 mm — unchanged |
| Rests | 1.8 / 1.8 mm | unchanged |
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

That floor is 10.2mm at the defaults, but only the two strips carrying the
troughs need to be. So with `floor_relief` on, the rest drops to `floor_solid`
and each pin row keeps a **raised plinth**, `trough_w + 2 * plinth_wall` wide —
just enough for the connector.

```
        relief off                  relief on (default)
  |=========|  <- PCB           |=========|  <- PCB, same height
  |         |  cavity           |         |  cavity
  |#########|                   |##|   |##|  <- plinths, 5.4mm wide
  |#########|  10.2mm floor     |__|___|__|  <- 2.0mm floor
```

The plinth tops sit exactly where the old floor top was, so the PCB seat, the
rests and the lid are all unaffected — it is purely plastic removed.

The plinths are clipped to the interior, so when a row sits close to a side wall
its plinth simply merges into that wall rather than leaving an unprintably
narrow gap beside it — which is what happens at the defaults, where the relief
ends up being the wide bay between the two rows.

### Wire channels

Every pin hole has a channel beside it, so you can take a wire off a pin and
bring it **into the box** rather than down through the underside — for wiring a
sensor or a display to a GPIO inside the case.

| Parameter | Default | What it does |
| --- | --- | --- |
| `wire_channels` | true | Off = plain holes, and about 0.5 cm³ less removed. |
| `slot_w` | 0 | Width where the channel leaves the hole. 0 = the hole's full width. |
| `slot_neck` | 0.6 | How far that opening runs before widening to `wire_w`. |
| `wire_w` | 1.4 | Channel width. Size it for your wire's OD *with* insulation. |
| `slot_depth` | 0 | How far the channel runs from the hole centre. 0 = far enough to break out. |

Channels always run toward the middle of the box. Outboard there is only the
side wall a couple of millimetres away, so a channel that way has nowhere to
leave the wire; inboard it opens onto the relieved floor — the whole open area
under the board.

```
  PLAN, default            PLAN, slot_w = 0.4         SECTION
                                                          ______  PCB
  +--------------+         +--------------+               1.2mm
  |  |        |  |         |  |        |  |          ####|####|####  plinth
  |  |  wire_w |  |        |  |__    __|  |          ####|    |###\_ breaks
  |  |        |  |         |     |  |     |  neck    ####|    |####  out
  |  |  hole  |  |         |   __|  |__   |          ##[ trough ]##
  |  |        |  |         |  |  hole  |  |          ##############  floor
  +--------------+         +--------------+
```

- **`slot_w = 0` opens the channel straight out of the hole** — the default.
  Setting it *below* the pin post (0.64) makes it a keyhole instead, which
  braces the pin on all four sides while you push a terminal onto it from below,
  and keeps the lead-in a complete funnel. **It makes no difference to the
  wire**, which enters the channel from the trough underneath and never passes
  through this opening at all.
- **The channel breaks clear through the plinth's side.** A channel that stopped
  inside the plinth would be a pocket, not a way out.
- **It exits sideways, not over the top.** The board sits only `pcb_standoff`
  above the plinth — 1.2 mm, about one wire diameter — so a wire climbing over
  the plinth would lift the board. Leaving at plate level and dropping into the
  relieved floor avoids that entirely.
- **It reaches below the hole by `wire_w`.** Without that, its mouth into the
  trough would be only `trough_w/2 - slot_neck` wide — 0.4 mm at the defaults,
  which no wire fits through. The drop opens a mouth a full wire tall.

Note that the pins do **not** rely on the holes being closed. Both rows' channels
point inboard, so a board drifting one way frees one row into its channels while
the *other* row presses against the far side of its holes and stops. Either
direction, the board is held to `(hole - post)/2` = 0.18 mm — the same figure a
closed hole gives, and far tighter than the 1.1 mm of clearance to the side
walls. That is why a full-width opening is a safe default.

The channels sit one per pin, so `wire_w` has to leave a rib between them:
at 2.54 pitch the default leaves 1.14 mm. An `assert` catches anything that
would merge them, because merged channels take away the shoulder holding the
hole plate up.

Set `wire_channels = false` if you do not want them — that recovers about
0.5 cm³ (13.26 → 13.76 cm³ at the defaults).

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

### Case size

The board sets the length, and the header sets the board:

```
length = 2 * wall + board_length + antenna_gap
width  = row_spacing + 2 * side_margin
```

where `board_length` is `board_l`, or `(pin_count - 1) * pitch +
2 * board_end_margin` when `board_l` is 0. Set `length_override` /
`width_override` to a non-zero value to pin them.

| Parameter | Default | What it does |
| --- | --- | --- |
| `antenna_gap` | 6.0 | Clear air past the board's far edge. **Measure yours.** |
| `side_margin` | 5.0 | Row centre to the outer side face. |
| `wall` | 2.4 | Wall thickness. |
| `floor_solid` | 2.0 | Floor away from the plinths, or the whole floor with the recess off. |
| `cavity_h` | 0 | Interior height above the floor. 0 = derive it. |
| `corner_r` | 3.0 | Outer corner rounding. |

> There is no `end_margin` any more. It set the distance from the end pin to the
> outer face, which the flush board now decides at the USB end and `antenna_gap`
> decides at the far end. Use `board_end_margin` to move the header on the board.

### Height

`cavity_h = 0` derives the interior height, taking the larger of what the board
needs and what the lid's groove needs to clear the wall openings:

```
cavity = max(pcb_standoff + board_t + component_h,
             opening_z + usb_h + groove_depth + 0.4)
```

At the defaults the second one wins, at 8.7mm. **`cavity_h` is not the biggest
lever on total height — `terminal_len` is.** The floor is
`terminal_len + roof + hole_plate_t` = 10.2mm of the 20.9mm total, and it also
pushes the USB socket up, which is what the groove then has to clear. Halving
`terminal_len` takes far more off the case than anything in the cavity.

Set `cavity_h` to a number to pin it; an `assert` will catch it if you pin it so
low that an opening runs up into the groove.

### Closure

The lid drops into a slot milled around the top of the tray wall — a rib on the
lid, a slot in the wall. On its own that is only a press fit: both mating faces
are plain vertical walls, so it aligns the lid and grips by friction, and
nothing actually holds it down.

**Ball latches** add that. Half-round bumps on the lid's rib click into dimples
in the slot wall.

| Parameter | Default | What it does |
| --- | --- | --- |
| `latches` | true | Ball detents on/off |
| `latch_count` | 2 | How many down each long side |
| `latch_grip` | 0.35 | How far the ball squeezes past the slot wall, in mm |
| `latch_fit` | 0.10 | Slack in the dimple so the ball seats |

`latch_grip` is the number that has to survive your printer. At 0.35 mm it is
0.87 of a 0.4 mm extrusion width — comfortably above dimensional noise. Below
about 0.25 mm it vanishes into tolerance and you get either no click or a
seized lid, varying print to print.

The joint is sized around that. A 3.2 mm wall with a 1.2 mm slot leaves 1.0 mm
lips and a 0.9 mm rib, all at two 0.4 mm perimeters or better, and still leaves
**0.55 mm of lip under the deepest point of a dimple**. A wider 1.6 mm slot
would have left only 0.35 mm there — under one extrusion width, where the
slicer would likely leave a void.

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

- **The troughs are peaked, not flat.** A flat trough ceiling would be a 48 mm
  unsupported span inside a 3 mm slot you could never clean support out of.
  Roofing it at `trough_roof_angle` (65°) removed 239 mm² of flat overhang.
- **The hole funnels face up**, so they guide a descending pin and never
  overhang. There is deliberately no angle parameter for them: an upward-facing
  funnel cannot overhang at *any* angle, so the setting would only look like it
  mattered. Measured from 40° to 80°, the tray sits at 28.8 mm² throughout.
- **The floor relief is cut downward out of the cavity**, so every face it makes
  is either vertical or upward-facing. It also deliberately spares
  a pillar under each PCB rest and under each screw boss, so nothing is left
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
interior of 57.72 x 30.8, so it will run off the edge.
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
| No new overhang anywhere | 28.8 mm² across all 19 — and 0.00 with `usb_opening=false`, which is what proves the 28.8 is only that bridge |
| Board really is flush | Measured 0.000 mm between the board's USB edge and the wall |
| Antenna bay really is the gap | Measured 6.000 mm of clear air past the board's far edge |
| Rests clear the header | Trimmed to 1.8 mm, leaving 0.2 mm to the nearest funnel rim |
| Tray volume | 24.11 cm³ → 16.30 cm³ off the two meshes; the floor relief still removes ~8 cm³, the thicker latch wall puts some back |
| Template holes all go through | Genus 38 = exactly the 38 pin holes, nothing else |
| Template needs no support | 0.00 mm² across every configuration tested |
| Lead-in never breaches the plate | Coupon's nominal hole measures 1.00 mm with 0.5 mm of parallel bore, at `lead_in` from 0.05 to 2.0 |
| No forward-referenced variables | Static scan of every top-level assignment — an undef here silently deletes geometry |
| Wire route is actually continuous | Traced by section from trough to bay; narrowest point is the full `wire_w`, not the 0.4 mm neck |
| Wire channels add no overhang | 28.8 mm², unchanged, and the ribs between channels survive |
| Sealed base really is closed | Underside probes solid 2.0 mm over both troughs, where it is open air unsealed |
| Sealing changes nothing else | Pin engagement, rests, holes and channels all identical; only the base slab and 2 mm of height are added |
| Rest pillars survive a thin floor | 28.8 mm² across `floor_solid` 0.8 → 5.0, sealed and open — a coplanar-face bug used to break this at 0.8 |
| Template matches the tray | Same footprint, same interior outline, same hole positions |

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
