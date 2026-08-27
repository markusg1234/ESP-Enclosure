/* ===========================================================================
   ESP-Enclosure — a parametric ESP devkit case for OpenSCAD

   Copyright (c) 2026 markus1234
   Licensed under CC BY 4.0 — https://creativecommons.org/licenses/by/4.0/

   This model is an original design, written from scratch. It ships with
   wifi.svg, which is part of it and under the same licence.

   esphome.svg, if present, is NOT mine and NOT under CC BY 4.0: it is the
   ESPHome logo from Homarr Labs' dashboard-icons, under Apache 2.0, and
   modified. See "Third-party assets" in the README. Nothing here renders it
   unless you point vent_file at it.

   The lid drops into a slot around the top of the wall and is held by ball
   latches: half-round bumps on its rib clicking into dimples in the slot wall.

   The board sits up on ledges; its header pins drop through a thin hole plate
   into a trough under each row. Dupont connectors push up into those troughs
   from below, so they finish flush with the floor instead of hanging out, and
   the wires leave straight down through the open underside.

   NO use<> OR include<> STATEMENTS. The geometry is all in this file, so the
   tray and the template render from it alone.

   The lid is the exception: its vents are cut from artwork in an SVG beside
   this one, named by vent_file. slots.svg (plain bars) and wifi.svg ship with
   it. That file has to travel with the model, and the Thingiverse / Printables
   web customizers cannot resolve it — they will fail to render the lid. Set
   vents = false and everything is standalone again.

   Open in OpenSCAD, then Window > Customizer. Pick a part with `part` at the
   top, press F6, then File > Export > STL.

   EVERY DIMENSION IS IN MILLIMETRES. The only settings that are not are the
   handful marked (in degrees), the plain counts, and the on/off switches.

   >> PRINT THE FIT TEMPLATE FIRST. Set part = "template". A shallow shell with
   >> the same footprint, the same interior outline and the same holes in the
   >> same places, so you can drop your actual board into it and see that it
   >> fits, that the header lines up and that the antenna has its bay — before
   >> committing to a whole case. The Dupont and board defaults below are
   >> sensible starting points, not verified specifications for your hardware.
   =========================================================================== */


/* [Part] */

// Which part to render
part = "tray";          // [tray:Tray (bottom), lid:Lid (top), template:Fit template - check your board fits, all:Print layout, assembled:Assembly preview]

// Gap between parts in the print layout (mm)
layout_gap = 5;         // [0:0.5:40]


/* [Pin header] */

// Pins per row. Two rows, one down each long side.
pin_count = 19;         // [1:60]


/* Centre-to-centre between the two rows, across the width. 22.86 is what most
   ESP devkits use; 25.4 is the other common one. (mm)
   */
// Centre-to-centre between the two pin rows, across the width. (mm)
row_spacing = 22.86;    // [5:0.01:60]

/* Shift the whole header along the length: the holes, the pin channel, the
   Dupont troughs and the plinths that carry them, all together.

   NEGATIVE IS TOWARD THE USB END. The board itself cannot move — it sits hard
   against the inside of the USB wall so its socket meets the opening — so this
   is how you line the holes up with a header that is not centred on your board.

   The default is -1.0 because the header on a typical devkit sits that much
   closer to the USB edge than dead centre. Measure yours: it is the distance
   from the board's USB edge to the first pin, against the far edge to the last.
   */
// Shift the header along the length. Negative moves it toward the USB end. (mm)
pin_x_offset = -1.0;    // [-20:0.01:20]


/* [Pin pitch / Dupont preset] */

/* The three Dupont families, named by the thing you actually measure off your
   board: the pitch. Picking one sets the post size with it — 0.64 at 2.54,
   0.50 at 2.00, 0.40 at 1.27 — because a family is a pitch and a post together,
   not two things to line up by hand.

   This holds the pitch itself rather than a preset code, so the number in the
   dropdown is the number in the variable and there is nothing to decode.
   */
// Pin pitch: centre to centre along the header. Sets the Dupont post size too.
pin_pitch = 2.54;       // [2.54:2.54mm - standard, 2:2.00mm - compact, 1.27:1.27mm - micro]

/* Size the openings for the connector's PLASTIC SQUARE SURROUND instead of for
   the bare metal post, so a housed Dupont pushes up into the trough rather than
   only a naked crimp terminal. Off, everything is sized to the post, which is
   what it has always been.

   The surround is not a second measurement to take. Housings are moulded to
   TILE THE PITCH — that is exactly what lets a row of them sit shoulder to
   shoulder on a header — so their size IS the pitch, less the moulding gap that
   keeps two of them from jamming. 2.50 at the 2.54 preset, 1.96 at 2.00, 1.23
   at 1.27.

   That tiling is also why this tick MERGES THE ROW, and it is not a choice: at
   the 2.54 preset the opening becomes 2.70 against a 2.54 pitch, so the plate
   between one hole and the next is 0.32 mm of NEGATIVE material. There is no
   setting at which separate holes survive a surround. So while it is on:

   pin_slot      is on whatever it says — one continuous channel down the row
   pin_slot_w    is held at the opening's width if it is set below it
   pocket_wall   is 0 — the troughs merge into one slot down each row

   wire_channel_w is NOT one of them and keeps working normally. A wire channel
   is sized to the PIN, never to the surround: what goes along it is a wire off
   a pin, while the connector arrives from below and goes up through the plate.
   So it stays whatever you set — 0.84mm by default, with 1.70mm of rib between
   channels — exactly as with the tick off.

   The console says all of that when you tick it, so nothing goes quiet.

   terminal_len is worth a look alongside this, but there is no right answer to
   it and nothing warns: it is the trough's DEPTH, so it sets how much of the
   housing is buried and how much shows below the case. A housed Dupont is about
   15 mm, so at the default 6 roughly 9 mm of it is on display — which is a
   shorter case and an easier connector to unplug, if that is what you want.
   */
// Size the openings for the connector's plastic surround, not the bare pin.
dupont_housing = true;


/* Added to the post size to get the hole — or to the plastic surround, with
   dupont_housing ticked (mm). Raise if pins bind, lower if loose.
   */
// Added to the post (or the surround) to get the hole. Raise if pins bind. (mm)
hole_clearance = 0.2;  // [0:0.01:1.5]

// There is no lead-in chamfer on the holes, and no lead_in to set. The holes
// are plain square bores, top to bottom, at exactly `hole` across their whole
// depth.
//
// Losing the funnel costs less than it sounds like, because the hole is a
// CLEARANCE hole by construction: it is whatever has to pass through it plus
// hole_clearance, so it is already wider than that thing before anything is
// chamfered — half of hole_clearance per side. Against the bare post that is a
// hole 31% wider than the pin at 2.54 and 50% wider at 1.27; against a plastic
// surround the same slack is proportionally far less, because the surround is
// most of the pitch to begin with. Either way a pin was never being pressed
// into an interference fit that a funnel had to open up. The funnel only helped
// a pin FIND a hole it already fitted, and what does the finding is the pitch,
// which the header and the plate share.
//
// The exception is hole_clearance = 0, which the slider allows: that makes the
// hole exactly the post and there is no clearance left to speak of. Warned
// about below, since the funnel is no longer there to disguise it.

/* Replace the row of square clearance holes with ONE continuous channel running
   the length of the header. The pins still drop through it into the trough
   below and the terminals still push up from underneath — what goes away is the
   rib BETWEEN one hole and the next, which is what fails at a fine pitch: the
   1.27mm micro preset leaves pitch minus hole = 0.67mm of plate between holes,
   thinner than a single 0.4mm extrusion, so it prints as a smear rather than a
   wall.

   The price is location ALONG the row: nothing stops the header sliding
   lengthwise any more. The PCB rests and the board's own fit against the USB
   wall already do that.

   Forced on by dupont_housing, for the same reason at a coarser pitch: a
   surround leaves no rib between one hole and the next either.
   */
// Replace the row of holes with one continuous channel down each pin row.
pin_slot = true;

/* Channel width, and 0 is the default: as wide as a hole, which keeps the pins
   gripped across the row exactly as separate holes did. It is also the width that keeps the board where it is —
   see pin_slot, which only drops the board when the channel is wider than the
   header's strip.

   ANY OTHER VALUE GIVES THAT UP. At 4mm a 0.64mm pin has three millimetres of
   air around it: the channel is then clearance, not a fit, the pins are located
   in neither direction, and the board is held by its rests and the walls alone.
   That is a legitimate thing to want — it makes the pins trivial to drop in and
   leaves room to bring wires up beside them — but it is a different part.

   Keep it inside the pocket if you want the whole width to be a way through.
   Wider, and the channel is a wide pocket over a narrower opening: it still
   prints, and the pins still pass on the centreline, but only the pocket of it
   goes anywhere. The console tells you the opening you actually got.

   With dupont_housing on this is a request rather than the last word: anything
   below the opening's own width is raised to it, because a channel narrower
   than the surround is not a channel the surround goes through. Above it, it is
   yours as usual. (mm)
   */
// Pin channel width. 0 = as wide as a hole, which keeps the pins gripped. (mm)
pin_slot_w = 3;         // [0:0.1:10]

/* How far the channel cuts DOWN from the top face of the floor.

   There is a floor under this, and asking for less gets you the floor rather
   than an error: the channel has to get through the hole plate to reach the
   trough at all, so the minimum is hole_plate_t — 1.0 at the defaults. Below
   that it stops inside the plate and opens into nothing.

   Anything past the plate is optional. The trough is square, so the moment the
   channel breaks through it has the full pocket underneath it, and cutting
   deeper only removes more of the plinth. It is not the moving target it was
   when a tapering roof made the minimum depend on the trough and the roof angle.

   Ignored with the terminal recess off: there is no trough to reach, so the
   channel is simply cut through the floor the same depth the holes were. (mm)
   */
// How far the pin channel cuts down from the floor's top face. (mm)
pin_slot_depth = 3.0;   // [0.5:0.1:12]

/* A channel beside each pin hole, so you can bring a wire off a pin and out
   into the box instead of taking it down through the underside. It runs from
   the hole clear through the side of the plinth and opens onto the relieved
   floor.

   THE WIDTH IS THE SWITCH. 0 is no channel at all — plain holes — and any other
   value is that width in millimetres. There is no separate on/off tick: a tick
   and a width are two settings for one decision, and with both of them there was
   no way to see which one was the reason you had no channels.

   THE DEFAULT IS SIZED FOR THE WIRE, not for the pin: 1.2mm, which is 26 AWG
   with its insulation on, leaving 1.34mm of rib between one channel and the
   next at the 2.54 pitch. What travels down this channel is a wire, so the wire
   is what it is measured against. A channel at the pin's own 0.84 is narrower
   than common hook-up wire and the wire will not lie in it.

   That is a deliberate parting from the pin's hole, and the console reports it
   with both numbers so the rib you get is never a surprise. Matching the pin
   instead — 0.84 at 2.54, 0.70 at 2.00, 0.60 at 1.27 — is one number away, and
   it is the width at which the channels impose nothing the pin holes did not
   already impose. Nothing follows pin_pitch or hole_clearance on its own.

   The useful direction from here is DOWN. Narrowing buys back rib, which is the
   whole problem at a fine pitch: at the 1.27 micro preset even the pin's own
   0.60 leaves 0.67mm of plate and is too thin, while 0.45 leaves 0.82 and works.
   That is what makes wire channels possible there at all.

   Widening trades the other way, and the pitch caps it: two 0.4mm perimeters
   have to survive between one channel and the next. Ask for more and you get
   the most the pitch allows rather than an error, and the console says so.

   Every value on the slider does something:
   0             no channels
   under 0.4     raised to 0.4 — one extrusion. A narrower slot is not a slot,
                 the slicer simply fills it
   past the pitch the channels merge into one slot per row, which is a real part

   It is ONE setting, not the five it used to be — a tick plus slot_w, slot_neck,
   wire_w and slot_depth describing a keyhole with a neck, a wider section and
   its own length, every one of which could quietly break the channel.

   Works normally with dupont_housing on, and is unaffected by it. With the
   surround OFF the pin's hole is also the plate's hole, so the channel just
   continues it sideways. With it ON the hole is the surround's — 2.70 — and the
   channel deliberately does not follow: what goes along it is a wire off a pin,
   while the connector arrives from below. A 2.70 channel on a 2.54 pitch would
   merge every channel into one slot and take the inboard plinth wall with it.

   The direction and the length are not settings either, because neither has a
   second sensible value: it always runs toward the middle of the box, and
   always far enough to break clear through the plinth's side. Outboard is the
   side wall a couple of millimetres away, with nowhere to put a wire; stopping
   short of the plinth's face leaves a pocket the wire can never get out of.
   */
// Wire channel width, sized for the wire. 0 is no channel at all. (mm)
wire_channel_w = 1.2;   // [0:0.01:3]

/* How far the channel carries on BELOW the hole plate, into the trough.

   The channel has to pass through the plate to exist at all — that part is
   hole_plate_t and not a choice. This is the rest: the drop that opens a mouth
   into the trough's straight-sided section, so a wire can turn the corner and
   come out. Stop level with the plate's underside and that mouth is a sliver
   no wire fits through, which is what a 0 here gives you.

   AT THE CHANNEL'S OWN WIDTH THE MOUTH IS SQUARE, which is where the default
   sits: one width down for one width across. Shallower trades mouth for plinth,
   deeper costs nothing but the cut, so the useful direction is down only if you
   are short of plinth.

   Clamped to the trough's own depth, since past that there is nothing left to
   open into — and with a sealed base a deeper cut would breach the slab. With
   terminal_recess off there is no trough at all and this is held at 0: the
   channel is the plate's thickness and nothing more. The console says when the
   number you set was not the number you got. (mm)
   */
// How far the channel reaches below the hole plate, into the trough. (mm)
wire_channel_d = 1.2;   // [0:0.05:12]


/* [Terminal recess] */

/* Close the underside. The troughs are the only thing that opens through the
   bottom of the case, so this puts a slab of floor_solid under them and the
   case has no holes in its base.

   Nothing else changes: the pin holes, the troughs, the plinths, the wire
   channels and the rests all stay exactly as they are. The troughs simply
   become blind pockets, which is where the pin tails then sit — so a sealed
   base also removes any question of the tails fouling anything. The case grows
   by the thickness of the slab.
   */
// Close the underside with a solid slab, so the base has no holes in it.
seal_bottom = false;

/* Sink the Dupont connectors into a trough in the underside of the floor, so
   they finish flush instead of hanging below the case. The board sits up on
   its ledges, its pins drop through the hole plate, and the connectors push up
   into the trough from below. Wires leave straight out of the open underside.
   */
// Sink the connectors into troughs in the floor so they finish flush.
terminal_recess = true;

/* Trough depth, and therefore HOW MUCH OF THE CONNECTOR IS BURIED. Whatever is
   longer than this shows below the underside of the case.

   That is a dial, not a target. Bury the lot and the case is flush underneath
   but tall; leave some proud and the case is shorter and the connector is far
   easier to grip and unplug. About 6mm swallows a bare crimp terminal whole; a
   full plastic Dupont housing is nearer 15mm, so at 6 roughly 9mm of it shows.
   Neither is wrong, and nothing warns about it — set it to whatever leaves the
   amount of housing you want on display.

   It costs case height 1:1, because the floor is this plus hole_plate_t. That
   is the trade: every millimetre you bury is a millimetre of case. (mm)
   */
// Trough depth: how much connector is buried. The rest shows below the case. (mm)
terminal_len = 6.0;     // [1:0.1:25]

/* Material left above the pocket. The pin holes run through this, and it is
   what the pocket has to bridge when printed. Thinner leaves more pin for the
   terminal to grip; too thin and the holes tear out. (mm)
   */
// Material left above the trough, which the pin holes run through. (mm)
hole_plate_t = 1.0;     // [0.6:0.1:4]

/* Wall left between one pocket and the next. This is the ONLY thing that sizes
   a pocket, because the pockets are square and sit on the pitch: the pocket is
   whatever the pitch has left over, pitch - pocket_wall, the same in both
   directions. 1.74 mm square at the 2.54 preset.

   Ignored with dupont_housing on, which holds it at 0: a surround fills the
   pitch, so there is no room for a divider and the troughs have to merge.

   There is no trough_w any more. It set the pocket across the row while this set
   it along, which made the pockets rectangles — and it was the wrong shape to
   offer, because across the row the pocket had no reason to be anything other
   than what the pitch allows along it. Square, one number decides both.

   0.8 is two 0.4mm perimeters, the thinnest divider that prints as a wall
   rather than a smear. Set it to 0 and the pockets run together into one
   continuous trough down each row, which is the older behaviour and the only
   way a full-width crimp terminal fits at 2.54 pitch. (mm)
   */
// Wall between one trough pocket and the next. This is what sizes them. (mm)
pocket_wall = 0.8;      // [0:0.05:3]

// The troughs are square: straight sides from the underside of the case right
// up to the hole plate, so a connector can rise the whole way. There is no
// trough_roof_angle any more.
//
// They used to be roofed by a ridge, on the reasoning that a flat trough ceiling
// was an unsupported span inside a slot you could never clean support out of.
// It is not a span, it is a BRIDGE: a pocket is only `pocket` across and anchored
// on both its walls, so the slicer bridges the short way. 3mm at a 0.4 nozzle is
// routine, and support never enters into it.
//
// The ridge was costing more than it bought. It tapered the trough to nothing
// at the plate, so a terminal could only rise until the taper met its own width
// — about 1mm of grip at the old defaults, against the 3.8mm the console
// claimed, because that figure counted pin below the plate and ignored the roof
// in the way. Square troughs made the case 3.2mm shorter and made the reported
// grip the grip you actually get.

/* Relieve the floor down the middle, between the two troughs. Only the strips
   carrying the troughs need the full floor depth; the rest drops to floor_solid,
   leaving a raised plinth along each pin row. Each plinth runs from the side
   wall it is nearest to, in past its trough, so the board's long edge lands on
   solid floor rather than hanging over a trench. The outside of the case does
   not change — this only takes plastic out.
   */
// Thin the floor down the middle, leaving a plinth along each pin row.
floor_relief = true;

/* Material left each side of a trough. It is one of two demands on the plinth's
   width — the other is reaching the side wall — and the wider one wins, so this
   is a floor under the width rather than the width itself. Raise it and the
   plinth grows only while the trough is what is asking for the room; at the
   shipped defaults the side wall asks for more, and the console says so.
   */
// Material left each side of a trough. (mm)
plinth_wall = 1.2;      // [0.4:0.1:5]


/* [Board] */

// PCB length. 0 = derive from the header. (mm)
board_l = 0;            // [0:0.1:200]

/* YOUR BOARD'S WIDTH, measured across the PCB with calipers — not a lever on
   the case. It is one of the two demands on the case width; side_margin is the
   other, and the wider one wins.

   There is no board_side_margin and no board_clearance any more. Both measured
   the same span from a different end — row centre to the board's edge, and the
   board's edge to the wall — so three parameters described two distances and
   only ever one of them was live. What survives is the pair that cannot be
   confused: this one is your hardware, side_margin is the case. The gap between
   them is reported by echo() rather than requested, and warned about when it
   gets too tight to drop a board into. (mm)
   */
// Your PCB's width, measured across it. (mm)
board_w = 25;        // [10:0.1:200]

// Added each side of the header to get the auto PCB length (mm)
board_end_margin = 3.0; // [0:0.1:20]

/* THE HEADER SPACER'S HEIGHT — a measurement of your hardware, like strip_w or
   board_t. Not a lever: you are not setting how high the board rides, you are
   telling the model what the plastic block under it is.

   IT DOES NOTHING WHILE THE PIN CHANNEL SWALLOWS THE SPACER, which is the
   shipped default. The spacer sinks into the channel and the board lands on the
   plinth tops, so only the part TALLER than the channel is deep has any effect:

       board_under = max(0, pcb_standoff - pin_slot_depth)

   At the defaults that is zero for anything up to 3, and the tray mesh is
   byte-identical across 0, 1, 2 and 3. Raise pin_slot_depth to 5 and it is
   inert to 5. That is not a bug to chase; it is the board being datumed off a
   printed surface rather than off your spacer, which is the good case.

   WHERE IT IS LIVE: with dupont_housing AND pin_slot both off. Then there is no
   channel, the board rests on the spacer, and its height sets where the board
   sits — every value changes the mesh. That is the crimped-terminal mode.

   IT IS NOT THE LEVER FOR LIFTING THE PCB OFF THE BOTTOM OF THE BOX. Raising it
   pushes the board up OFF the pins, so it costs grip; and the floor shrinks
   underneath by the same amount, because the floor is sized to swallow the pin
   and there is less pin left below the board. The outside distance is

       bottom of box -> underside of PCB
           = max(pin_length, terminal_len + hole_plate_t + board_under)

   which is flat at pin_length until board_under gets large. For more room under
   the board use pin_length — it lifts the board AND buys grip, where this
   spends it. terminal_len deepens the trough the same way.

   Keep it just big enough to clear the solder joints. A standard 2.54mm header's
   block is about 2.5mm. (mm) */
// The header spacer's height: a measurement of your header, not a lever. (mm)
pcb_standoff = 1.2;     // [0:0.1:10]

/* How WIDE that plastic spacer is, across the row. MEASURE YOURS — about 3mm
   on the reference board, where the spacers under the module are roughly 3mm
   square.

   This is the one thing that decides whether the pin channel drops the board.
   The spacers are what the board actually rests on, so a channel narrower than
   one is bridged by it and the board sits where it always did; a channel that
   wide or wider swallows them and the board goes down with them, taking the
   flush USB opening and the case height with it.

   It used to be assumed equal to the pitch, on the reasoning that a header's
   moulding is one pitch wide. That is true of a continuous moulded strip and
   NOT true of the discrete spacers on a devkit, which run wider — so the model
   was testing 2.54 where the real number is 3, and would have missed the drop
   on exactly the channel width that causes it.

   There is no strip_l to go with it. The channel is continuous along the row,
   so how long a spacer is cannot change whether it falls in — only its width
   across the row can. (mm)
   */
// The header spacer's width across the row. MEASURE YOURS. (mm)
strip_w = 3.0;          // [0.5:0.1:12]

/* MEASURED OFF THE PCB: rest a caliper on the board's underside and read down
   to the tip of the pin. That is the whole tail — spacer and all — and it is
   the number this wants.

       PCB  ===================
              |  |   ^          spacer, pcb_standoff
              |  |   |
              |  |   |  pin_length = 9   <- underside of the board
              |  |   |                      to the tip of the pin
              |  |   v
                    ---

   The spacer is inside this, not additional to it. Read only the pin below the
   spacer and you get 6 where the answer is 9 — and that is not a mistake the
   model can catch: it believes you, and quietly builds a floor three
   millimetres too shallow for the pin that is really there.

   A pre-soldered devkit's stock tail is often only about 3mm off the PCB, which
   is not enough to cross the spacer and the hole plate AND still grip a
   terminal; this default assumes long-tail headers. With short pins, set
   terminal_recess = false.

   It drives the floor: the pocket is the larger of terminal_len and what the
   pin needs, so past a point the case grows to swallow the tail rather than let
   it out of the underside. The console prints the grip that is left, and it is
   an error at or below zero. (mm) */
// Measured off the PCB: its underside down to the pin tip, spacer included. (mm)
pin_length = 9.0;       // [1:0.1:20]

// PCB thickness. Only used to work out how tall the cavity has to be. (mm)
board_t = 1.6;          // [0.4:0.1:5]

/* The tallest thing standing on TOP of the board, measured from the board's
   upper face. 2.5 is the radio can on the reference board, which sits LEVEL
   with the top of the USB socket — measure yours. Raise it for tall
   electrolytics.

   The socket is allowed for automatically: the cavity takes the larger of this
   and the shell height usb_type already implies, so a tall connector cannot be
   forgotten here.

   It very rarely does anything. The cavity takes the larger of this and what the
   USB opening needs to clear the lid's rib, and the second beats it until
   component_h passes usb_oh + rib_h + 0.1. So it is NOT the lever for a shorter
   case; rib_h is. The console says which of
   the two is binding and how much dead air the other one is leaving. (mm)
   */
// Tallest thing standing on top of the board, from its upper face. (mm)
component_h = 2.5;      // [1:0.1:40]

// There are no PCB rest pads, and no ledge_d / ledge_w to size them. The four
// corner blocks that used to stand in the tray are gone: the board already sits
// on the header's plastic strip, and that strip lands on the plinth tops, so the
// pads were only ever stopping it rocking. The floor relief no longer has to
// spare a pillar under each one either.


/* [Case size] */

// Outer length. 0 = derive from the header. (mm)
length_override = 0;    // [0:0.1:250]

// Outer width. 0 = derive from the header. (mm)
width_override = 0;     // [0:0.1:250]

/* Clear air added at the FAR end, past the board, for the module's onboard
   antenna. Devkits mount the radio module hard against that end of the board
   and the antenna sits at the module's tip, often overhanging the board edge —
   so without this the module fouls the end wall and the antenna radiates into
   plastic pressed right against it. The case grows at the far end only: the
   USB end, the header, the troughs and the board all stay exactly where they
   are. MEASURE YOUR OWN BOARD — this default is a starting point. (mm)
   */
// Clear air past the board's far edge, for the module's antenna. (mm)
antenna_gap = 5;      // [0:0.1:30]

/* Row centre to the wall's inner face — the room beside the pins, measured out
   from a PIN ROW rather than from the board:

   interior = row_spacing + 2 x side_margin     (22.86 + 8.4 = 31.26)
   width    = interior + 2 x wall               (31.26 + 3.2 = 34.46)

   IT IS MEASURED TO THE INNER FACE, so it is clearance you can see inside the
   box and it does not carry the wall. Thicken wall and the case grows outward
   while the room beside the pins stays exactly where you put it: at 5.8 the
   interior is 31.26 whether the wall is 1.6 or 2.4, and the outside goes 34.46
   to 36.06.

   IT IS ONE OF TWO DEMANDS ON THE WIDTH, AND THE SMALLER ONE DOES NOTHING.
   The board needs pcb_w of interior, and the interior is whichever asks for
   more. They cross where side_margin = (pcb_w - row_spacing) / 2: below that the
   BOARD sets the width and moving this changes nothing whatever, above it this
   sets the width 1:1. Raising board_w moves that crossover up.

   So if it looks dead, it is losing the max(), not broken. The console prints
   the width it settled on and which demand set it.

   SCREW BOSSES ADD TO THIS INSTEAD OF FITTING INSIDE IT. A corner boss needs
   room across the width that the header does not, so closure = "screw" puts a
   full boss_d on EACH side on top of whatever side_margin asked for. The stock
   closure is "friction", where that does not apply and the row centre sits
   side_margin in from the inner face. Switch to screws and the case gains a
   full boss_d each side. Nothing here prevents that — the boss has to go
   somewhere. (mm)
   */
// Pin row centre to the INNER side face: clearance beside the pins. (mm)
side_margin = 3;      // [0:0.01:30]

/* Wall thickness. 1.6 is four 0.4mm perimeters, solid, and it is the reach a USB
   plug has to find before it even touches the socket — the socket sits against
   the inside of this wall, so every millimetre of wall is a millimetre off the
   plug's insertion depth. At 3.2 most micro leads simply do not bottom out: the
   moulded shell fouls the case first.

   It used to be 3.2 because the lid's groove was cut INTO the wall top and
   needed a lip either side of a 1.2mm slot. The rib hangs inside the wall now,
   so nothing here is holding a slot open and the wall can be as thin as it
   prints. Below about 1.05 the latch dimple has nothing left behind it. (mm)
   */
// Wall thickness, and the reach a USB plug has to find past it. (mm)
wall = 1.6;             // [1:0.05:6]

/* Floor thickness: the whole floor when the terminal recess is switched off,
   or the thin part between the plinths when the floor relief is on. (mm)
   */
// Floor thickness away from the plinths, or the whole floor with no recess. (mm)
floor_solid = 2.0;      // [0.8:0.1:8]

// Lid plate thickness (mm)
lid_t = 1.6;            // [0.8:0.1:8]

/* Interior height above the floor. 0 = derive it, as the standoff plus the
   board plus whatever stands on top of the board, which is as short as the box
   can be and still close. Set a number to pin it. (mm)
   */
// Interior height above the floor. 0 = derive it from what has to fit. (mm)
cavity_h = 0;           // [0:0.1:60]

// Outer corner rounding (mm)
corner_r = 3.0;         // [1:0.1:12]


/* [Closure] */

// How the lid is held on
closure = "friction";   // [friction:Rib and latches only, screw:Corner screw bosses]

/* Thickness of the rib under the lid — the part that drops inside the wall and
   locates it. 1.2 is three 0.4mm perimeters, stiff enough to carry the latch
   balls without being so stiff it will not flex past them. It no longer has to
   fit inside the wall, so it costs nothing in wall thickness. (mm)
   */
// Thickness of the rib under the lid that drops inside the wall. (mm)
rib_w = 1.2;            // [0.4:0.05:3]

/* How far the rib hangs below the lid, into the cavity. This is how much springy
   rib the latches have to work with, and how far the lid is located.

   THIS IS WHAT SETS THE CASE HEIGHT, and it is the only thing that does at any
   sane component height. The rib drops inside the wall, so the USB opening has
   to finish below it — and the socket is barely lower than the tallest thing on
   the board, so the air left over the components comes out at almost exactly
   rib_h + 0.1. Every millimetre here is a millimetre of wasted height, one for
   one.

   2.1 carries a 1.0mm latch ball with 0.55mm of rib above and below it, and is
   chosen to just lose to the components: the cavity is the larger of
   board_top + component_h and board_top + rib_h + 0.4, so anything up to
   component_h - 0.4 costs no height at all. Below about 2.0 the ball is more
   than half the rib and the latch loses its seat. (mm)
   */
// How far that rib hangs into the cavity. THIS SETS THE CASE HEIGHT. (mm)
rib_h = 2.1;            // [0.5:0.1:6]

// Clearance all round the joint. Raise if the lid is tight. (mm)
joint_clearance = 0.2; // [0:0.01:0.6]

// Screw clearance hole in the lid, e.g. 2.2 for M2 (mm)
screw_d = 2.2;          // [1:0.1:6]

// Pilot hole in the boss, e.g. 1.6 for an M2 self-tapper (mm)
screw_pilot_d = 1.6;    // [0.8:0.05:5]

// Screw boss outer diameter (mm)
boss_d = 4.5;           // [2:0.1:12]

/* Ball latches: half-round bumps on the lid's rib that click into dimples in
   the slot wall, so the lid latches rather than only gripping by friction.
   */
// Ball detents on the lid's rib, clicking into dimples in the wall.
latches = true;

// How many down each long side
latch_count = 2;        // [0:1:6]

/* How far the ball has to squeeze past the slot wall going in. This is the
   grip, and it is the number that has to survive your printer: below about
   0.25mm on a 0.4mm nozzle it disappears into dimensional tolerance and you
   get either no click or a seized lid, unpredictably. (mm)
   */
// How far the ball squeezes past the wall. This has to survive your printer. (mm)
latch_grip = 0.35;      // [0.1:0.05:1]

/* Slack in the tray's dimple so the ball seats instead of jamming on the way
   in. Comes straight off what is left of the lip, so do not be generous. (mm)
   */
// Slack in the dimple so the ball seats. Comes off the lip, so keep it small. (mm)
latch_fit = 0.10;       // [0:0.02:0.4]


/* [Openings] */

// Opening in the near end wall, for the USB socket
usb_opening = true;

/* Which connector your board has. These are FLUSH MOUNT: the opening is the
   socket's own metal shell plus a print fit, so the socket meets the wall
   instead of a big hole being left for the plug to pass through. The plug then
   mates from outside and its moulded shell sits against the case.
   Nominal receptacle shells, before the fit is added:
       Micro-USB B  7.5 x 2.5      Mini-USB B  7.7 x 4.0
       USB-C        8.95 x 3.2     USB-A       13.0 x 5.7
   Sockets vary less than cable overmoulds do, which is what makes flush mount
   worth doing — but measure yours, and use Custom if it disagrees.

   A flush opening has to LINE UP with the socket, which a generous one never
   had to: it is positioned automatically from the board stack, because the
   socket sits on the board's top face and nothing else decides where that is.
   Watch the console, which prints where it landed. */
// Which USB connector your board has. Sets the opening size and shape.
usb_type = "micro";     // [micro:Micro-USB B, c:USB-C, mini:Mini-USB B, a:USB-A, custom:Custom - set usb_w / usb_h]

/* How far the socket's shell stands PROUD of the board's edge. Measure it.
   About 1mm is typical; some boards mount the socket flush.

   Two things follow, and both matter more than they look.

   It is the plug's reach. The board sits hard against the inside of the end
   wall, so the socket's face ends up wall - usb_overhang from the outside — 0.6
   at the defaults, not the full 1.6. That is the difference between a lead
   seating and a lead fouling the case.

   And it is why the opening is NOTCHED up to the wall's top edge. A nose that
   overhangs has to END UP inside the wall, but it cannot GET there going
   straight down: there is solid wall above the opening, and the board drops
   vertically. The notch is the slot it slides down. Set this to 0 for a
   flush-mounted socket and the notch goes away with it. (mm) */
// How far the socket overhangs the board's edge. This is the plug's reach. (mm)
usb_overhang = 1.0;     // [0:0.05:4]

/* Opening width. Used only when usb_type = Custom, and taken as the finished
   opening rather than a shell size, so include your own fit. (mm)
   */
// Custom opening width, taken as the finished hole. Include your own fit. (mm)
usb_w = 12;             // [1:0.1:60]

/* Opening height. Used only when usb_type = Custom. This is usually what sets
   how TALL the case is: the opening has to finish below the lid's rib, so the
   cavity ends up as the opening's top plus rib_h. (mm)
   */
// Custom opening height, taken as the finished hole. (mm)
usb_h = 6;              // [1:0.1:40]

// Opening in the far end wall
end_opening = false;

// Far end opening width (mm)
end_w = 8;              // [1:0.1:60]

/* Far end opening height. 4.0 fits the cavity the case now has — it was 5,
   sized when the lid sat 4.7mm higher, and turning the opening on simply
   asserted. Unlike the USB end this is not positioned from anything, so it has
   to fit under the lid on its own: opening_z + this <= cavity. (mm)
   */
// Far end opening height. (mm)
end_h = 4;              // [1:0.1:40]

/* Height of the FAR END opening above the floor top. The USB opening is not
   set here: it is positioned automatically to meet the socket on the board's
   top face, which is the only place a flush mount can go. (mm)
   */
// Height of the far end opening above the floor's top face. (mm)
opening_z = 0.5;        // [0:0.1:30]

/* Slack in the USB opening, on top of the receptacle's own shell. It is the
   TOTAL, split either side, so 0.8 is 0.4 per side.

   The presets are nominal shells and real sockets are not: rolled edges, a
   flared lip, or a shell a tenth over drawing all stop a socket entering an
   opening cut to the book figure. Raise this and the opening grows around the
   same outline, so the micro/mini taper is kept — which is what going to
   usb_type = custom to get a bigger hole costs you.

   It changes the opening only, not the case: the cavity is measured from the
   shell, so the height does not follow it. Ignored with usb_type = custom,
   where usb_w and usb_h are the finished opening and the fit is already in
   whatever you typed. (mm)
   */
// Slack in the USB opening, total across the socket's shell. (mm)
usb_fit = 1;          // [0:0.05:3]


/* [Lid] */

/* Text engraved into the lid. Blank for none, which is the default — the
   engraving is the only thing on the lid that needs bridging, so leaving it
   off takes the lid to zero overhang.
   */
// Text engraved into the lid. Blank for none.
label = "";

// Label size (mm)
label_size = 6;         // [2:0.5:20]

// How deep the label is engraved (mm)
label_depth = 0.6;      // [0.2:0.05:2]

/* Where the label sits along the length. 0 = auto, centred in the space
   between the USB end and the vent patch. (mm)
   */
// Where the label sits along the length. 0 = auto, centred in the space left. (mm)
label_x = 0;            // [0:0.1:250]

/* Turn the label, in degrees, counter-clockwise as you look down at the closed
   case. -90 stands it on its side reading down the case, 90 reading up it.
   Unlike the vents there is no quarter turn built in: 0 is as you typed it.
   */
// Turn the label. 0 is as you typed it. (degrees)
label_rotate = 0;       // [-180:5:180]

/* Ventilation over the radio module. The module is the only part of a devkit
   that gets meaningfully warm, so the openings sit over it rather than being
   spread across the lid — the rest of the plate stays solid and stiff.
   */
// Cut vent artwork through the lid, over the radio module.
vents = true;

/* Centre of the vent patch, measured from the board's FAR edge (the end away
   from USB, where the radio module sits on most devkits). (mm)
   */
// Centre of the vent patch, measured from the board's far edge. (mm)
vent_from_end = 10;     // [0:0.5:80]

// Length of the vent patch, along the case (mm)
vent_zone_l = 15;       // [2:0.5:80]

/* Width of the vent patch, across the case. Used by the slots, and by
   vent_fit = stretch. With vent_fit = aspect it is not used at all: the
   artwork is scaled to vent_zone_l and its own proportions set the height.
   Millimetres.
   */
// Width of the vent patch, across the case. (mm)
vent_zone_w = 15;       // [2:0.5:60]


/* [Vent artwork] */

// How the artwork is scaled into the vent patch.
vent_fit = "aspect";    // [aspect:Keep its proportions, stretch:Fill the patch exactly]

/* Turn the artwork on the lid, in degrees, counter-clockwise as you look down
   at the closed case.

   Zero is not "as drawn": artwork is laid down a quarter turn CLOCKWISE from
   how it sits in the file, which is what puts the shipped wifi.svg the right
   way round on the lid. This setting turns it further from there, so 0 is the
   orientation you want and you only touch it to deviate.

   Applied before the artwork is scaled, so vent_zone_l always measures across
   the finished orientation.
   */
// Turn the vent artwork before it is cut. (degrees)
vent_rotate = 0;        // [-180:5:180]

/* The artwork cut into the vent patch, which has to sit next to this file.
   slots.svg (plain bars) and wifi.svg ship alongside; drop in your own and
   name it here.

   >> THE LID NEEDS THIS FILE. Vents are always cut from artwork now, so the
   >> model is only standalone with vents = false. The Thingiverse and
   >> Printables customizers cannot resolve it and will fail to render the lid.
   */
// Artwork file for the lid vents. It must sit beside this .scad.
vent_file = "esphome.svg";

/* SVG imports as a true outline. PNG is read as a heightmap and thresholded,
   which leaves the edges stepped by the pixel grid — measured on a disc, a PNG
   wobbled 0.75mm on a 10mm radius where the SVG was exact. Prefer SVG.
   */
// Artwork format. SVG is a true outline; PNG is traced and wobbles.
vent_format = "svg";    // [svg:SVG - a true outline, png:PNG - stepped edges]

// PNG only: brightness cut-off. Pixels brighter than this become openings.
vent_level = 50;        // [0:1:100]

// PNG only: cut the dark parts instead of the light ones
vent_invert = false;


/* [Fit template] */

/* Floor thickness of the fit template. Two or three layers is plenty — it only
   has to hold its shape while you drop the board in and look. (mm)
   */
// Floor thickness of the fit template. (mm)
template_t = 1.2;       // [0.4:0.1:4]

/* How high the template's wall stands. Enough to catch the board's edges and
   show you it clears, without printing a whole case. (mm)
   */
// How high the fit template's wall stands. (mm)
template_rim = 3.0;     // [0:0.1:15]


/* [Quality] */

// Facets per full circle. 100+ for a final render, 30 for a fast preview.
$fn = 200;               // [12:200]


/* [Hidden] */


// --- USB connector lookup --------------------------------------------------
/* Flush-mount opening: the receptacle's own shell plus usb_fit, which is set
   with the other opening parameters. Derived here because opening_top, the
   cavity height, the openings themselves and both opening asserts read these,
   and every one of those is further down the file. */
usb_ow = usb_type == "micro" ? 7.50  + usb_fit
       : usb_type == "c"     ? 8.95  + usb_fit
       : usb_type == "mini"  ? 7.70  + usb_fit
       : usb_type == "a"     ? 13.00 + usb_fit
       : usb_w;

usb_oh = usb_type == "micro" ? 2.50 + usb_fit
       : usb_type == "c"     ? 3.20 + usb_fit
       : usb_type == "mini"  ? 4.00 + usb_fit
       : usb_type == "a"     ? 5.70 + usb_fit
       : usb_h;

// usb_z is further down, with board_drop — where the board sits is not settled
// until the pin channel has had its say. See "Where the board actually sits".


// --- Dupont preset lookup -------------------------------------------------
/* No struct type in the Customizer, so presets are a ternary chain.

   There is no Custom entry, and no pin_pitch or custom_post to feed it. Those
   three settings only did anything at ONE of the four dropdown values and sat
   inert at the other three — a pitch slider that moves nothing is exactly the
   broken slider this file keeps taking out. The three presets are the three
   Dupont families; anything else is a different connector, not a tuning of
   this one.

   The last branch is a plain else rather than a test for 1.27, so the chain
   cannot fall through to undef. That makes an out-of-range pin_pitch read as
   the 1.27 post instead, which the assert below catches rather than letting you
   print a micro-pitch case by accident. */

post = pin_pitch == 2.54 ? 0.64
     : pin_pitch == 2.00 ? 0.50
     :                     0.40;

assert(pin_pitch == 2.54 || pin_pitch == 2.00 || pin_pitch == 1.27,
       str("pin_pitch ", pin_pitch, " is not one of the three Dupont families. ",
           "Use 2.54 (standard), 2.00 (compact) or 1.27 (micro). There is no ",
           "Custom any more, and no custom_post: they did nothing at every ",
           "value but that one."));

/* The plastic surround, and why it is derived rather than a fourth entry in the
   chain above.

   A housing is moulded to TILE THE PITCH — that is the whole point of it, so a
   row of connectors sits shoulder to shoulder on a header without fouling.
   Its size is therefore not an independent measurement the way the post is: it
   is the pitch, less the moulding gap that stops two of them jamming. 2.50 at
   the 2.54 preset, 1.96 at 2.00 and 1.23 at 1.27 — three presets, three
   numbers, no parameter of its own.

   post_eff is what actually has to pass through the plate. Everything below
   reads `hole`, so putting the choice HERE — in one place, above `hole` — is
   what keeps the template and the tray describing the same opening. */
housing  = pin_pitch - 0.04;
post_eff = dupont_housing ? housing : post;

hole  = post_eff + hole_clearance;

/* What a BARE PIN needs, whatever the surround is doing. Two things want this
   number and both want it for the same reason, so it is named once rather than
   spelled out twice: the wire channel (a wire comes off a pin, not off a
   housing) and the fit template's pin row, which has to keep answering "do my
   pins line up" even with the surround on, or it is measuring the wrong thing.

   With dupont_housing off this IS `hole`. With it on they part company — 0.84
   against 2.70 at the 2.54 preset — which is exactly why it needs its own name. */
pin_hole = post + hole_clearance;

/* The wire channel is sized to the PIN, not to the surround, and that is the
   difference between the feature working with a housing and being impossible
   with one.

   What travels along this channel is a WIRE coming off a pin — it is not a way
   in for the connector, which arrives from below and goes UP through the plate.
   So the thing it has to clear is the post, and the surround never enters into
   it. Tying it to `hole` was right while `hole` was the post's; with a surround
   it would ask for 2.70 on a 2.54 pitch, merge every channel into one slot down
   the row, and take the whole inboard plinth wall with it.

   At the post's width the rib between two channels is pitch - channel_w, the
   same 1.70 mm it has always been, so the channels stay separate and printable
   at every preset — surround or no surround. With the tick off this IS `hole`,
   so nothing about the default part changes.

   wire_channel_w overrides that width. It is clamped at the BOTTOM only:

     channel_min   one 0.4mm extrusion. A slot narrower than the nozzle is not a
                   slot — the slicer fills it — so asking for less gets 0.4.
     channel_max   what the pitch leaves after two 0.4mm perimeters of rib. This
                   is REPORTED, not enforced: see below.

   There is deliberately NO upper clamp, and that is a correction. Clamping the
   top at channel_max left the slider dead above 1.74 at the 2.54 preset — a
   third of its travel doing nothing, which is the same broken slider as one
   that asserts, just quieter. Past the pitch the channels simply MERGE, the way
   pin_slot merges the holes and pocket_wall = 0 merges the pockets, and the row
   becomes one continuous slot out through the plinth's side. That is a real
   part — a full-length wire exit — not an error to be prevented.

   Between the two the ribs are thinner than two perimeters but not yet gone.
   That band warns rather than clamps, which is exactly how pocket_wall's own
   too-thin dividers are handled: it prints, it is just fragile, and how fragile
   depends on a nozzle the model cannot know.

   The bottom clamp only applies to an EXPLICIT width. Left at 0 the derived
   width is passed through untouched, so a pitch too fine for a pin-wide channel
   still fails the rib check rather than being silently narrowed — there is no
   request to honour in that case, only a default. */
channel_min  = 0.4;
channel_max  = max(channel_min, pin_pitch - 0.8);

/* The width IS the switch, so "are there channels at all" is read off it rather
   than off a tick of its own. Internal, and below the last parameter group, so
   it stays out of the Customizer — everything downstream still reads
   `wire_channels` the way it always did. */
wire_channels = wire_channel_w > 0;

// 0 when there are none, so channels_merged and every message downstream cannot
// quote a width for a channel that does not exist
channel_w = wire_channels ? max(wire_channel_w, channel_min) : 0;

/* Wide enough that one channel reaches its neighbour. Cut as ONE slot from
   there on — a row of cubes at exactly `pitch` across on a `pitch` spacing
   butts face to face, and butting one cut onto another is what gives this model
   non-manifold edges and a negative genus. Same trap the pockets fell into. */
channels_merged = channel_w >= pin_pitch - 0.001;

/* What the surround takes over, and why it could not be left set.

   With dupont_housing on the opening is most of a pitch wide before
   hole_clearance is added at all, so at the default clearance it is WIDER than
   the pitch: 2.70 against 2.54. The plate between one hole and the next is then
   negative material, and so is the wall between one pocket and the next. No
   value of pocket_wall or pin_slot rescues that, because it is the connector's
   own shape doing it.

   wire_channel_w is NOT on this list. It used to be, on the reasoning that a
   surround leaves no rib to run a channel through — but that was the surround's
   width being applied to a cut that never needed it. Sized to the post, as
   above, the channels are unaffected by the tick and stay entirely the user's.

   So the tick derives these two rather than asserting against them — a slider
   whose range is unreachable is a broken slider, and a checkbox that errors is
   worse. The console says what was taken over, so nothing goes dead quietly.

   Defined HERE, straight after `hole` and before `pocket`, for the same reason
   `pocket` is: a forward reference at file scope is undef, it propagates in
   silence, and this file has lost every pin pocket to exactly that three times
   while OpenSCAD reported NoError. */
pocket_wall_eff = dupont_housing ? 0     : pocket_wall;
slot_on         = dupont_housing ? true  : pin_slot;

/* The pocket is SQUARE — the same across the row as along it — and the pitch is
   what sizes it. Along the row it can be at most pitch - pocket_wall_eff or it
   touches its neighbour, and across the row there is no competing demand, so
   there is nothing to gain by making the two differ. One number, one shape.

   Never smaller than the hole above it, though: a pocket narrower than its own
   hole would choke the pin it exists to receive. At the 1.27 preset that clamp
   bites and the divider comes out thinner than asked, so pocket_gap reports what
   was actually left and the check below compares it against the request rather
   than trusting it.

   Defined HERE, straight after `hole`, because half the file reads it: the
   plinth width, the floor relief, the pin channel's opening and the pockets
   themselves. Used above its assignment it is undef, which propagates silently
   into the pocket cubes and deletes every pocket in the tray while the render
   still reports NoError and a plausible genus. This file has been bitten by
   exactly that twice. */
pocket     = max(hole, pin_pitch - pocket_wall_eff);
pocket_gap = pin_pitch - pocket;

/* Whether the pockets still stand apart, or have run together into one trough.

   This is a geometry decision, not just something to report. A pocket exactly
   `pitch` long on a `pitch` spacing — pocket_wall at 0, or a plastic surround
   at a clearance under the moulding gap — leaves each cube BUTTING its
   neighbour face to face, and butting one cut exactly onto another is how this
   model makes non-manifold edges. It renders Status: NoError and reports a
   NEGATIVE genus, which is the tell.

   So terminal_troughs() cuts one long trough instead of a row of touching
   cubes whenever this is true. The two are exactly the same extent — the union
   of the cubes runs trough_x0..trough_x1 the moment pocket >= pitch — so
   nothing moves; what goes away is the interior faces that never had any
   business being there. */
pockets_merged = pocket_gap <= 0.001;


/* Sealing the bottom does not take anything away: the holes, the troughs, the
   plinths and the wire channels all stay. It just puts a slab of floor_solid
   under the troughs, which are the only things that open through the underside.
   The troughs become blind pockets — which is exactly where the pin tails want
   to go — and the case grows by that slab. */
base_t = seal_bottom ? floor_solid : 0;

// what a pin actually has to pass through: the thin plate when the recess is
// on, the whole floor when it is off. Independent of the pocket's depth, which
// is why everything below can be settled before the floor is.
plate_t   = terminal_recess ? hole_plate_t : floor_solid;

/* The pin channel's width and depth, and where the board ends up.

   All of this sits ABOVE the floor because the pocket's depth now depends on
   where the board lands, and the board lands on the header's strip — or in the
   channel, if the channel is wide enough to swallow it. slot_min_depth is
   plate_t outright rather than floor_t - plate_z; those are the same number
   (the floor is the pocket plus the plate, and plate_z is the top of the
   pocket), and writing it directly is what breaks the loop. */
/* Width is clamped UP to the opening with a surround, rather than replaced by
   it. pin_slot_w stays a live setting either way — ask for more than the
   surround needs and you get it, the same as always; ask for less and you get
   the least that lets the connector through, which is the only value that is
   not simply broken. */
slot_cut_w     = max(pin_slot_w > 0 ? pin_slot_w : hole,
                     dupont_housing ? hole : 0);
slot_min_depth = plate_t;
slot_cut_d     = terminal_recess ? max(pin_slot_depth, slot_min_depth) : plate_t;

/* The header's plastic strip drops into a channel wider than itself.

   A plastic surround does NOT change this, and an earlier version of this file
   wrongly assumed it did — it suppressed the drop on the reasoning that the
   housings rise to the floor's top face and the strip lands on them. They do
   rise, but they are not standing on anything: a housed Dupont is pushed up
   from below and held by friction on its pin, over a trough that is open at the
   underside. It follows the board down; it cannot hold the board up. The one
   case where a connector does push back is a SEALED base, where it bottoms out
   on the slab — and that already has its own warning about lifting the board.

   So dupont_housing gets the ordinary rule. It forces slot_on, so with a
   channel that swallows the spacers the board drops exactly as it would with
   the tick off.

   The test is strip_w, not pitch. What the board rests on is the plastic
   spacers, and on a devkit those are wider than the pitch — about 3mm against
   2.54. Testing the pitch would have said "drops" for a 2.6mm channel that a
   3mm spacer actually bridges, and it is a measurement only the user has.

   "At or wider", not "wider than", because a channel exactly the spacer's width
   is the case you hit by setting them to the same number, and it is a drop, not
   a bridge. The epsilon is written out rather than using `fuzz`, which is
   declared further down this file and would be undef here — an undef comparison
   is false, so the drop would silently never happen and the render would still
   report NoError. */
board_drop = (slot_on && terminal_recess && slot_cut_w + 1e-6 >= strip_w)
           ? min(slot_cut_d, pcb_standoff) : 0;

// board faces, both measured from the floor's top face
board_under = pcb_standoff - board_drop;
board_top   = board_under + board_t;

/* How deep the pocket has to be, and it is the larger of two separate demands.

   terminal_len is how much CONNECTOR you need to bury for it to finish flush.
   The other is how much PIN there is to swallow: a tail longer than the pocket
   comes out through the underside. They are not two names
   for one thing — a longer pin does not make a connector bigger — but they both
   land on this one dimension, so it takes whichever asks for more.

   That is what makes pin_length change the case at last. It only ever grows it:
   cut the pins short and the connector still needs its room, so lower
   terminal_len too, or switch terminal_recess off and let the connectors hang
   below. Solder straight to the board and you want terminal_recess off anyway —
   there is no connector to bury and no pin to swallow. */
pin_pocket_need = max(0, pin_length - board_under - hole_plate_t);
pocket_d        = max(terminal_len, pin_pocket_need);

/* With the recess on, the floor is exactly the pocket plus the plate that
   carries the holes — nothing between them, because the pocket is square and
   runs straight up to the plate's underside. Sealed or recess-off, it is a plain
   slab of floor_solid. */
floor_t   = base_t + (terminal_recess ? pocket_d + hole_plate_t : floor_solid);
trough_z  = base_t + (terminal_recess ? pocket_d : 0);
plate_z   = trough_z;                             // underside of the hole plate
slot_break_z = plate_z;
// The hole is the plate and only the plate. With a square trough there is no
// taper below it to punch through first — the plate's underside IS the trough.
hole_z0   = plate_z;
hole_h    = plate_t;

/* The holes have no lead-in chamfer, which takes a whole class of error out of
   the model along with the feature. A funnel is cut from the top down, so it had
   to be capped at half the plate or it broke out of the underside and the hole's
   narrowest point stopped being `hole` at all — worst on the thinnest plate,
   which is exactly backwards. There was a lead_angle before that, defaulting to
   65 degrees, which cut 1.07mm into a 1.00mm plate and left holes 0.1mm
   oversize. A plain bore cannot do any of that: it is
   `hole` wide at the top, at the bottom and everywhere between. */


/* The continuous pin channel — how wide, how deep, and how deep it MUST be.

   Width is its own parameter because it is a different decision from the hole's.
   At `hole` the channel is still a fit; wider, it is clearance and the pins
   float in it. Nothing downstream cares which,
   so both are just slot_cut_w.

   With the recess on, the depth is measured down from the floor's top face and
   pin_slot_depth chooses it. With the recess off there is no trough under the
   plate and nothing to choose: the channel goes through the same material the
   holes went through, so it is plate_t deep and the parameter is ignored.

   `slot_break_z` is the highest the channel's floor may sit and still let a pin
   through, and with a square trough that is simply the plate's underside. The
   pocket below is `pocket` wide from there all the way down, so the channel
   either reaches the plate's underside and opens into the full trough, or stops
   inside the plate and opens into nothing. There is no partial case any more —
   the ridge used to give one, tapering the void so the channel could break into
   a slit narrower than a pin, and half the arithmetic here existed to find the
   height where that slit was still `hole` wide.

   slot_min_depth is a FLOOR, and the depth is clamped up to it rather than
   asserted against. Asking for less gets the least that works, and the console
   says so. */
slot_z0 = floor_t - slot_cut_d;   // the rest of this lives above floor_t

/* Where the board actually sits, and the USB opening with it.

   The board is carried on the header's plastic strip, and the strip lands on
   the plinth tops. Switch pin_slot on and there may not BE a plinth top under
   it any more: the channel is cut down the middle of the row, and if it is
   wider than the strip the strip drops straight into it until it grounds on the
   channel floor. The whole board goes down with it.

   What the board rests on is the plastic spacers, so the test is slot_cut_w
   against strip_w — about 3mm on a devkit, wider than the 2.54 pitch this used
   to assume. At the default pin_slot_w = 3 the channel is exactly that, so the
   spacers drop in and the board goes down with them. Set pin_slot_w = 0 and the
   channel is `hole` wide, 1mm, the spacers bridge it, and switching pin_slot on
   moves nothing.

   How far it goes is capped by the BOARD, not the channel. The strip sinks
   until either it grounds on the channel floor or the board's own underside
   reaches the plinth top — and the board is the whole width of the case against
   a channel a few millimetres wide, so it lands flat long before a deep channel
   runs out. That cap is the strip's own height, which is what pcb_standoff is.
   Without it a 3mm channel drops the board 3mm, puts its top face BELOW the
   floor, and asks for a USB opening at a negative height.

   This is not cosmetic. It moves the pins further into the pockets, moves the
   board's top face away from the lid, and moves the USB socket — and a flush
   opening that does not follow is a hole in the wrong place. */

// the shell stands on the board's top face; back off half the fit to centre it
usb_z = board_top - usb_fit / 2;

/* The notch, and what a plug actually has to reach.

   usb_notch_z is where the slot starts: at the profile's WIDEST point, so the
   two merge without leaving ears. For a trapezoid that is its top edge; for the
   obround it is mid-height, where the caps are at full width. */
usb_notch   = usb_opening && usb_overhang > 0;
usb_notch_z = usb_type == "c" ? usb_z + usb_oh / 2 : usb_z + usb_oh;
usb_reach   = wall - usb_overhang;      // outer face to the socket's face

/* How far the board is pushed off the USB end wall, and why it is only ever
   pushed when there is NO opening.

   The board sits hard against the inside of that wall so its socket lines up
   with the opening. But the socket OVERHANGS the board's edge by usb_overhang,
   so flush against the wall it is protruding usb_overhang INTO the wall — which
   is exactly what you want when there is a hole there for it to protrude into.

   Switch usb_opening off and there is no hole: that millimetre of socket is
   then inside solid plastic, and the board cannot go in. So the board steps
   back by the overhang and the socket's face lands on the wall's inner face
   instead, fully inside the box.

   The case grows by the same amount rather than the antenna bay absorbing it —
   antenna_gap is clear air you measured for a reason, and silently eating it to
   pay for this would be the wrong trade. With an opening this is 0 and nothing
   moves at all. */
usb_inset = usb_opening ? 0 : usb_overhang;


/* How much of the channel's floor is actually open.

   The trough is square, so once the channel reaches the plate's underside the
   opening is the full pocket — no taper, no depth dependence. slot_ledge is
   the solid shelf left each side when the channel is wider than the trough it
   lands on.

   The shelf is NOT an overhang, which is worth stating because it looks like
   one on paper: it is the top of solid plinth, so it faces UP into the channel.
   What it does mean is that a channel wider than the pocket is a wide slot over
   a narrower hole, and only the pocket of it goes anywhere. Unlike before,
   widening the trough now fixes that directly. */
slot_void_w = terminal_recess ? pocket : 0;
slot_ledge  = terminal_recess ? max(0, (slot_cut_w - slot_void_w) / 2) : 0;


// --- Derived dimensions ---------------------------------------------------

span = (pin_count - 1) * pin_pitch;

// screw bosses need corner room across the width the auto size would not
// otherwise leave. Along the length they tuck into the corners beside the
// board, so they cost nothing there.
screw_pad = closure == "screw" ? boss_d : 0;

pcb_l = board_l > 0 ? board_l : span + 2 * board_end_margin;
pcb_w = board_w;

/* The board sits hard against the inside of the USB end wall, so its socket
   lines up with the opening in that wall. That fixes the USB end, and the far
   end is the board plus the antenna bay — so the length is the board, not the
   header, plus the bay and two walls.

   The width is the larger of two demands, and that max is the point. It used to
   come from the header alone and never looked at the board at all, so a board
   grown past the case was an assert rather than a bigger case. Now whichever
   needs more room wins. At the
   defaults the header wins and the case is the size it has always been. */
/* The least room the row can have beside it, whatever you asked for: the cut
   that goes through the plate is `row_cut` across and centred on the row, so
   half of it has to clear the wall or the channel opens into the side of the
   case. side_margin is CLAMPED UP to that rather than asserted against — a
   slider whose bottom end errors is a broken slider, and this end of it is
   reachable the moment you widen pin_slot_w.

   Clamping here rather than at the assert is what lets the slider start at 0:
   every value on it renders, and the console says when the number you set was
   not the number you got. */
row_cut        = slot_on ? slot_cut_w : hole;
side_margin_min = snap(row_cut / 2);
side_margin_eff = max(side_margin, side_margin_min);

length = length_override > 0 ? length_override
       : 2 * wall + pcb_l + antenna_gap + usb_inset;
width  = width_override  > 0 ? width_override
       : max(row_spacing + 2 * side_margin_eff, pcb_w) + 2 * wall + 2 * screw_pad;

inner_l = length - 2 * wall;
inner_w = width  - 2 * wall;
inner_r = max(corner_r - wall, 0.5);

/* The gap the board actually got. It is derived, not requested — you set where
   the wall goes (side_margin) and how wide your board is (board_w), and the gap
   is whatever is left between them. Reported by echo() and checked below, so it
   is a number you can read rather than one you compute. Length is measured at
   the far end only; the USB end is flush by design. */
/* Both gaps go through snap() because both are differences that can be exactly
   zero. When the board is what sets the size, inner_w is pcb_w with 2 x wall
   added and then taken away again, and the gap comes back as 3.6e-15 rather
   than 0 — noise in the console, and worse than noise in the assert below,
   which compares the two and would fail on the wrong side of a rounding error.
   A nanometre is far below anything an STL or a printer resolves. */
fuzz = 1e-6;
function snap(x) = abs(x) < fuzz ? 0 : x;

board_gap_side = snap((inner_w - pcb_w) / 2);
board_gap_end  = snap(inner_l - pcb_l);

// How deep the cavity has to be: enough for the standoff, the board and
// whatever stands on top of it, and enough that the lid's rib clears the
// openings cut in the walls. The second one usually wins, because the floor
// already carries the sockets high — if you want a shorter case, terminal_len
// is a far bigger lever than this.
// how high the openings reach. The cavity no longer derives from this — the rib
// is notched around both openings — but the height notes still quote it.
opening_top = max(usb_opening ? usb_z + usb_oh : 0,
                  end_opening ? opening_z + end_h : 0);
/* The cavity's two demands, named so the console can say which one won.

   cav_board is what is standing on the board. cav_joint is the lid's rib having
   to clear the BOARD — not the socket, which is the whole point of notching the
   rib. The rib hangs around the perimeter and only overlaps the board at the
   USB end, where the socket is; cut the rib away over the socket's width and
   the tallest thing it still has to miss is the board's own top face.

   That is worth 2.6mm. Clearing the socket meant opening_top + rib_h + 0.4 =
   8.5; clearing the board is board_top + rib_h + 0.4 = 5.7, which loses to the
   components at 5.9 — so component_h finally sets the cavity, which is what it
   always claimed to do. */
/* The socket is a component like any other, and the cavity has to allow for it.
   component_h is what YOU measured standing on the board; usb_shell_h is what
   the connector preset already knows. Taking the larger means a tall socket
   cannot be forgotten — pick usb_type = "c" with its 3.2mm shell against a
   component_h of 2.5 and the lid would otherwise close onto the socket by
   0.7mm. For a custom opening the shell is assumed usb_fit smaller than the
   hole, which is the same relationship the presets have.

   NOT conditional on usb_opening. It used to be, and that was wrong: switching
   the opening off removes the hole in the WALL, not the socket from the BOARD.
   The socket still stands there and the lid still has to clear it. Zeroing this
   let the cavity forget it entirely — a USB-A devkit with the opening off had
   the lid closing onto its socket by 3.2mm, rendering clean the whole way. */
usb_shell_h = usb_oh - usb_fit;
cav_board   = board_top + max(component_h, usb_shell_h);
cav_joint = board_top + rib_h + 0.4;

cavity = cavity_h > 0 ? cavity_h
       : max(cav_board, cav_joint);

wall_h = floor_t + cavity;

/* The lid's tab, which fills the notch when the case is closed.

   The notch has to reach the wall's top edge or the nose cannot get in, which
   leaves a slot above the socket that the lid's rib does not cover — the rib
   sits INSIDE the wall, and the notch is the wall. So the lid grows a tab in
   the wall's own thickness that drops into it, and the end wall reads as solid
   again from outside.

   It starts above the OPENING's top, not the notch's. For the obround the notch
   begins at mid-height so it can merge cleanly, and a tab following it down
   there would land on the socket.

   Down here because it needs wall_h, which is floor_t plus the cavity, and the
   cavity is not known until the opening it has to clear has been placed. */
/* How much wall is left standing above the opening. Drop the lid far enough and
   the answer is none: the cavity shrinks until the opening's top IS the wall's
   top edge, and then there is nothing for the nose to get past and nothing to
   notch. Clamped at 0 because it goes negative there, and a negative notch is a
   cube with a negative side. */
usb_wall_above = max(0, wall_h - floor_t - usb_z - usb_oh);

usb_tab_z = usb_z + usb_oh + joint_clearance;
usb_tab_h = wall_h - floor_t - usb_tab_z;
usb_tab_w = usb_ow - 2 * joint_clearance;

row_a_y = (width - row_spacing) / 2;
row_b_y = (width + row_spacing) / 2;

pcb_x = wall + usb_inset;                    // flush, unless there is no opening

// the header is soldered to the board, so it goes where the board goes
x_first = pcb_x + (pcb_l - span) / 2 + pin_x_offset;

// --- Floor relief ---------------------------------------------------------
// Only the strips carrying the troughs need the full floor depth. The rest of
// the floor drops to floor_solid, so each row keeps a raised plinth and the bay
// between them goes away. Nothing here moves floor_t: the plinth top IS the old
// floor top, which is why the case outside is untouched.

relief = terminal_recess && floor_relief;

/* How wide each plinth is, and it is the larger of two separate demands.

   The first is the trough plus the material it needs each side of it, which is
   what plinth_wall asks for. The second is REACHING THE SIDE WALL: a plinth
   that stops short of the wall leaves a trench between the two, and at the
   defaults that trench is 1.65 mm across and 7 mm deep — four extrusions wide,
   deeper than it is wide, and on a wide board it is where the board's own edge
   lands: at board_w 28.86 that edge sits at y 2.8, outboard of a plinth face at
   3.25 and hanging over nothing. Closing it puts solid floor under the whole
   board and takes a slot out of the print that was never worth having.

   Reaching the wall is a demand on the OUTBOARD side only, so the plinth grows
   inboard by the same amount to stay centred on its row: the trough stays in
   the middle of what carries it, and the two rows stay mirror images. The rows
   sit at width/2 +/- row_spacing/2, so one half-width covers both.

   A max(), not a replacement — the trough's own demand still wins wherever it
   asks for more, which is what a wide pocket or a raised plinth_wall does. */
plinth_half = max(pocket / 2 + plinth_wall, row_a_y - wall);
plinth_w    = 2 * plinth_half;
wall_bound  = row_a_y - wall >= pocket / 2 + plinth_wall;

/* What is left relieved down the middle, between the two plinths. It closes as
   the rows move out toward the walls, and once it is under a millimetre it is a
   slot too narrow to print — the same rule the plinth's ends already use. Below
   that the floor comes out solid across, and floor_relief_cut() has to spare it
   as ONE box rather than two that touch. */
relief_bay = row_spacing - plinth_w;
bay_open   = relief_bay >= 1;

/* How far the wire channel runs, measured from the hole's centre.

   Far enough to break clear through the plinth's side face, which is the whole
   point — that is what gives the wire somewhere to go. Half the plinth plus a
   little, so it cannot land exactly on the face and leave a zero-thickness
   skin. Stopping short would leave a pocket the wire could never get out of,
   which is why this is derived rather than offered as a number to get wrong.

   The channel is cut through the full height of the hole, not sunk from the
   plinth's top. That matters: a groove in the top face would never reach the
   trough, so no wire could get into it from below. Full height, it meets the
   trough void where it crosses the trough's sloping roof. */
slot_reach = plinth_w / 2 + 0.6;

/* How far the channel reaches BELOW the hole, from wire_channel_d.

   Clamped to the trough's own depth: past that there is nothing left to open
   into, and on a sealed base the cut would go through the slab that closes the
   underside. Held at 0 with the recess off, where there is no trough below the
   hole and dropping the cut would only breach the floor. */
channel_drop_max = terminal_recess ? pocket_d : 0;
channel_drop     = wire_channels ? min(wire_channel_d, channel_drop_max) : 0;


// the same x extent terminal_troughs() covers, so the plinth and the pockets it
// carries cannot drift apart. The end pockets stand pocket/2 proud of the end
// pins, and that is the whole extent now — there is no trough_end_margin any
// more, because with a pocket per pin the pocket's own size is what gives you
// room to get at the end connectors.
trough_x0 = x_first - pocket / 2;
trough_x1 = x_first + span + pocket / 2;

// a sliver of relief left between a plinth end and the interior wall would be
// a slot too narrow to print, so close the gap when it gets that small
plinth_x0 = (trough_x0 - plinth_wall) - wall < 1 ? wall - 0.5
                                                 : trough_x0 - plinth_wall;
plinth_x1 = (length - wall) - (trough_x1 + plinth_wall) < 1 ? length - wall + 0.5
                                                            : trough_x1 + plinth_wall;

/* The joint: a rib under the lid that drops INSIDE the wall.

   There is no groove in the tray any more. A slot milled into the wall top needs
   its own width plus a lip either side — 1.2 + 1.0 + 1.0 — which is what forced
   a 3.2mm wall, and a 3.2mm wall is 3.2mm of reach a USB plug has to find before
   it even gets to the socket. Most leads do not have it. Hanging the rib inside
   the wall instead asks nothing of the wall's thickness at all, so the wall can
   be as thin as it wants to be and the socket comes to meet the plug.

   The lid's plate still lands on the wall top, so the joint looks the same from
   outside; the rib now locates it from within rather than sitting in a slot. */
rib_a    = wall + joint_clearance;     // rib's outer face, clear of the wall
rib_b    = rib_a + rib_w;              // rib's inner face
tongue_h = rib_h;                      // the rib hangs its full depth into air

/* Ball latches. The ball is a half round, so its radius is also how far it
   stands proud of the rib: clearing the joint clearance first, then biting
   latch_grip into the wall. It has moved to the rib's OUTER face — there is no
   slot wall on the inside to bite any more, and the wall itself is what the rib
   now meets. The dimple still opens into the cavity rather than showing
   outside, because it is cut into the wall's inner face. */
latch_r = joint_clearance + latch_grip;
latch_y = rib_a;                           // the rib's outer face
latch_z = -tongue_h / 2;                   // lid-local, mid-height of the rib

// Artwork is laid down a quarter turn clockwise from how it is drawn, so the
// shipped wifi.svg lands the right way round; vent_rotate adjusts from there.
vent_angle = vent_rotate - 90;

// Vent patch, sitting over the radio module at the far end. Measured from the
// board's far edge, not the case's, so the antenna bay can grow or shrink
// without dragging the vents off the module.
vent_cx     = pcb_x + pcb_l - vent_from_end;
vent_zone_x0 = vent_cx - vent_zone_l / 2;

// label goes in the clear space between the USB end and the vent patch
label_cx = label_x > 0 ? label_x
         : vents ? (wall + vent_zone_x0) / 2
         : length / 2;

/* A rough guess at how much room the label wants.

   OpenSCAD's textmetrics() is an experimental builtin that is off by default,
   so the real width cannot be measured here — 0.85 per character is about
   right for capitals in the default font. This drives a console warning, not
   an assert, because it is an estimate and a wrong assert would be worse than
   no assert.

   It matters most when the label is turned: upright it has the length of the
   case to fill, on its side only the width, which is a lot less. */
label_len_est = len(label) * label_size * 0.85;
label_x_est = abs(cos(label_rotate)) * label_len_est
            + abs(sin(label_rotate)) * label_size;
label_y_est = abs(sin(label_rotate)) * label_len_est
            + abs(cos(label_rotate)) * label_size;

// how far the pins stick out below the case, reported by echo() below
/* plate_t, not hole_plate_t. With the recess on they are the same thing, but
   with it off the pin has to cross the WHOLE floor — floor_solid, 2.0 — and
   using the plate's thickness there overstated the grip by a millimetre in the
   one configuration where pins are already shortest. */
pin_free  = board_under + plate_t;    // pin spent crossing the floor
pin_engage = pin_length - pin_free;   // pin left inside the pocket to grip

/* How far the pin tails hang out of the bottom of the case, if they do.

   Sealed, they cannot — they bottom out on the slab and lift the board, which
   is the check further down. Open, which is the default, there is nothing
   underneath them and a long tail simply comes out through the pocket and
   stands the case off the desk. */
pin_protrude = max(0, pin_length - board_under - floor_t);


// --- Sanity checks --------------------------------------------------------

assert(x_first - hole / 2 >= wall && x_first + span + hole / 2 <= length - wall,
       str("Pin header does not fit. It spans ", x_first - hole / 2, " to ",
           x_first + span + hole / 2, " but the floor inside the walls runs ",
           wall, " to ", length - wall,
           ". Raise board_end_margin, lower pin_count, or set length_override."));

/* side_margin_eff already keeps the row's own cut clear of the wall, so this
   only fires when width_override pins a width too narrow for the header — the
   one path the clamp cannot reach. The fuzz is there because both sides are
   sums of the same parts in a different order, and the difference lands a whole
   ULP short: 3.1 - 1.5 is 1.5999999999999999, which would reject a width that
   fits exactly. */
assert(row_a_y - hole / 2 >= wall - fuzz,
       str("Pin holes reach into the side wall: row centre ", row_a_y,
           " with a ", hole, " hole reaches ", row_a_y - hole / 2,
           " but the wall ends at ", wall,
           ". Raise width_override or clear it to let the width derive."));


/* The hole is the post plus hole_clearance, so it is a clearance hole by
   construction — half of hole_clearance each side, a hole 31% wider than the pin
   at 2.54 and 50% wider at 1.27. That is why removing the lead-in funnel costs
   so little: a pin was never being pressed into an interference fit that a
   chamfer had to open up.

   At hole_clearance = 0 that stops being true. The hole is then exactly the
   post, printing shrinks a small hole slightly, and there is no funnel left to
   disguise it. */
if (hole_clearance < 0.1)
    echo(str("WARNING: hole_clearance ", hole_clearance, " leaves only ",
             hole_clearance / 2, " mm each side of a ", post, " mm pin, so the ",
             "hole is barely a clearance hole at all — and once the print ",
             "shrinks it, an interference one. The holes are plain bores with ",
             "no funnel to guide a pin in. Raise it before committing to a ",
             "whole case."));

/* The channels sit one per pin, so anything approaching the pitch merges them
   into a single long slot and takes the plate's inboard support with it.

   A channel is exactly a PIN hole wide, so the rib between two channels is
   pitch - channel_w, which is the same rib as between two holes whenever the
   holes are the pin's too. So this is really the plate's own printability
   rather than a separate channel constraint. It bites at the 1.27 micro preset,
   where that rib is 0.67mm, and pin_slot does not rescue it: the channels run
   ACROSS the plate, so they need the pitch whether the pins sit in holes or in
   one long channel.

   channel_w rather than hole, which is what lets the channels survive a plastic
   surround: the surround widens the way IN for the connector, not the way OUT
   for a wire, so it must not be allowed to fail this check on the channel's
   behalf. With the tick off the two are the same number and this is unchanged. */
/* There is no assert on the channel width any more, and its absence is the
   point. It used to reject the DERIVED width — the one you got at 0 — because
   nobody had asked for it; every width now comes from the panel, so every width
   is a stated intention, and the bands above channel_max are reported rather
   than refused: thin ribs get a warning, merged channels get a note.

   At the 1.27 preset that means the shipped width renders with a warning instead
   of being rejected. The model does not refuse a number you can see and could
   have changed, and 0 is right there if you want no channels at all. */

/* The channel is sized for the WIRE, so by default it is not the pin's hole and
   the rib between two channels is not the rib between two pin holes. That is the
   shipped trade rather than a mistake, and it moves whenever pin_pitch or
   hole_clearance moves the pin without moving the channel — so it is reported
   with both numbers and the way back, never corrected. */
if (wire_channels && abs(channel_w - pin_hole) > 0.005)
    echo(str("NOTE: the wire channel is ", channel_w, " mm, ",
             channel_w > pin_hole ? "wider than" : "narrower than",
             " the pin's own hole at this pin_pitch (", pin_hole,
             " mm), so the rib between two channels is ", pin_pitch - channel_w,
             " mm against the ", pin_pitch - pin_hole,
             " mm between two pin holes. The default is sized for a wire, not ",
             "for the pin: 26 AWG with insulation is about 1.2 mm. Set ",
             "wire_channel_w to ", pin_hole, " to match the pin instead."));

// asked for less than one extrusion: clamped up, because a slot narrower than
// the nozzle is not a slot at all — the slicer just fills it. 0 is not this
// case: 0 is no channel, which is a choice rather than a width too small to cut
if (wire_channels && wire_channel_w < channel_min)
    echo(str("NOTE: wire_channel_w ", wire_channel_w, " was raised to ",
             channel_w, " mm. Under 0.4 mm a slot is narrower than one ",
             "extrusion, so it would print as solid plate rather than as a ",
             "channel."));

// The depth clamp, said out loud for the same reason as the width one.
if (wire_channels && wire_channel_d > channel_drop_max + fuzz)
    echo(str("NOTE: wire_channel_d ", wire_channel_d, " was cut back to ",
             channel_drop, " mm — ",
             terminal_recess
               ? str("the trough is only ", pocket_d, " mm deep, so there is ",
                     "nothing below that to open into", seal_bottom
                       ? " and the sealed base is right underneath it." : ".")
               : "terminal_recess is off, so there is no trough below the hole at all."));

/* A wire leaves through the mouth this drop opens into the trough, so a drop
   under one extrusion is a mouth a wire cannot turn the corner into. Warned,
   not clamped: the channel still prints, and taking the wire down through the
   hole instead is a legitimate thing to want. */
if (wire_channels && terminal_recess && channel_drop < channel_min)
    echo(str("WARNING: the wire channel drops only ", channel_drop,
             " mm below the plate, so its mouth into the trough is ",
             channel_drop, " x ", channel_w,
             " mm — under one 0.4mm extrusion tall, which no wire turns into. ",
             "Raise wire_channel_d to ", channel_w,
             " to make that mouth square with the channel."));

/* The band between "printable ribs" and "no ribs at all". It renders and it
   prints; the ribs are just thin. Warned rather than clamped, exactly as
   pocket_wall's too-thin dividers are — clamping here is what left the slider
   dead above channel_max in the first place. */
if (wire_channels && !channels_merged && pin_pitch - channel_w < 0.8)
    echo(str("WARNING: a ", channel_w, " mm wire channel leaves only ",
             pin_pitch - channel_w, " mm of plate between one pin and the next, ",
             "under two 0.4mm perimeters — the ribs will print as a single ",
             "bead rather than a wall, and will be fragile. ", channel_max,
             " mm is the widest that keeps two perimeters; ", pin_pitch,
             " mm and over merges the channels into one slot instead, which is ",
             "sound again."));

/* Past the pitch there are no ribs left, and the row is one continuous slot out
   through the plinth's side. That is a legitimate part — a full-length wire
   exit — but it is invisible in a render, and it gives up the one thing the
   separate channels were doing, so it gets said. */
if (wire_channels && channels_merged)
    echo(str("NOTE: wire_channel_w ", wire_channel_w, " is at or past the ",
             pin_pitch, " mm pin_pitch, so the wire channels MERGE into one continuous ",
             channel_w, " mm slot down each row rather than staying one per ",
             "pin. The plate between pins is gone, and with it the last thing ",
             "locating the header along the row — the board's own fit against ",
             "the walls is what holds it now. Cut as a single slot, not as ",
             "touching cubes, so the mesh stays sound."));

assert(2 * rib_b < min(inner_l, inner_w),
       str("The lid's rib meets itself: 2 x ", rib_b,
           " exceeds the smaller interior dimension ", min(inner_l, inner_w),
           ". Lower rib_w or raise the case size."));

/* What the cavity cost, and which of its two demands set it.

   Almost always the joint: the USB opening has to finish below the lid's rib,
   and the socket sits barely lower than the tallest thing on the board, so the
   air left over the components works out at about rib_h + 0.1 whatever
   the components are. Said out loud because "make the case shorter" sends people
   to component_h, which is the one lever that cannot do it. */
if (cavity_h == 0 && cav_joint > cav_board + fuzz)
    echo(str("NOTE: the cavity is ", cavity, " mm, set by the lid's rib ",
             "clearing the board (", cav_joint, ") rather than by what is ",
             "standing on it (", cav_board, "). That leaves ",
             snap(cavity - cav_board),
             " mm of air over the tallest component. Lower rib_h to ",
             snap(max(component_h, usb_shell_h) - 0.4),
             " or less and the components set the height instead, which is as ",
             "low as the lid goes."));

// the good case, worth saying so you know nothing is being wasted
if (cavity_h == 0 && cav_joint <= cav_board + fuzz)
    echo(str("NOTE: the cavity is ", cavity, " mm and the lid lands on the ",
             "components — ", snap(cavity - cav_board),
             " mm of air over the tallest one. The rib wants ", cav_joint,
             ", which is under it, so nothing is being spent on the joint."));

/* The overhang is the plug's whole story, so say what it left. */
if (usb_opening && usb_overhang > 0)
    echo(str("NOTE: the socket overhangs the board by ", usb_overhang,
             " mm, so its face sits ", usb_reach,
             " mm inside the outer wall — that is what a plug has to reach past ",
             "before it touches the socket, not the full ", wall,
             " mm of wall. The opening is notched to the wall's top edge so the ",
             usb_wall_above > 0
               ? str("nose can slide down into place; without that the board ",
                     "cannot go in, because there is ", usb_wall_above,
                     " mm of solid wall above the opening.")
               : str("nose can slide straight in — the lid sits low enough ",
                     "that the opening already reaches the wall's top edge, so ",
                     "there is no wall above it to notch and none to get past.")));

assert(!usb_opening || usb_overhang <= wall,
       str("The socket overhangs ", usb_overhang,
           " mm but the wall is only ", wall,
           " mm thick, so the socket would stand proud of the outside of the ",
           "case. Raise wall, or measure the overhang again."));

/* The dimple is cut into the wall's inner face now, not into a slot wall, so a
   thin wall is the thing that runs out. The pocket reaches latch_r + latch_fit
   from the rib's outer face, which is joint_clearance proud of the wall, so it
   eats (latch_r + latch_fit - joint_clearance) into it. */
if (latches && latch_count > 0
    && wall - (latch_r + latch_fit - joint_clearance) < 0.8)
    echo(str("WARNING: the latch dimple leaves only ",
             wall - (latch_r + latch_fit - joint_clearance),
             " mm of wall behind it, under two 0.4mm perimeters — it will show ",
             "through, or blow out. Raise wall above ",
             0.8 + latch_r + latch_fit - joint_clearance,
             ", lower latch_grip, or switch latches off."));

/* The latch ball is a half-round of latch_r, so it stands 2 x latch_r across the
   rib's face. Sink the groove far enough and the ball is most of the rib, with
   nothing left above or below to hold it — the lid still renders and still
   clicks in the preview, it just stops having a seat. */
if (latches && latch_count > 0 && tongue_h < 4 * latch_r)
    echo(str("WARNING: the lid rib is only ", tongue_h, " mm tall carrying a ",
             2 * latch_r, " mm latch ball, so there is just ",
             (tongue_h - 2 * latch_r) / 2,
             " mm of rib above and below it. Raise rib_h to ",
             4 * latch_r, " or lower latch_grip."));

assert(rib_h < wall_h - floor_t,
       str("rib_h ", rib_h, " hangs deeper than the cavity itself (",
           wall_h - floor_t, "). Lower it or raise cavity_h."));

/* The board is flush to the USB wall by design, so there is no clearance to
   check at that end — only across the width, and in the bay past the far edge.

   On the auto sizes this can no longer fail: the width takes the larger of the
   header's demand and the board's, so the case grows to meet the board rather
   than the board outgrowing the case. What is left for it to catch is an
   override, which is a flat number that knows nothing about the board — hence
   the different advice. */
assert(board_gap_end >= 0 && board_gap_side >= 0,
       str("The PCB does not fit the interior: board is ", pcb_l, " x ", pcb_w,
           " but the interior is only ", inner_l, " x ", inner_w, ". ",
           width_override > 0 || length_override > 0
             ? str("That is an override talking: width_override / ",
                   "length_override are flat numbers and do not grow with the ",
                   "board. Raise them, or set them to 0 to size the case ",
                   "automatically.")
             : "Raise antenna_gap or side_margin, or lower the board size."));

/* The gap is derived now, so nothing stops it being too small to use. A board
   has to DROP in: below about half an extrusion width the slot is tighter than
   the printer's own repeatability, and the board either jams or needs forcing
   past the pins. Warned rather than asserted — it prints, and a press fit may
   even be what you want for a board you never intend to remove. */
if (board_gap_side < 0.2)
    echo(str("WARNING: only ", board_gap_side, " mm each side between the ",
             "board and the wall — that is a press fit, not a drop-in. Raise ",
             "side_margin (currently ", side_margin,
             ", and the interior follows it above ",
             snap((pcb_w - row_spacing) / 2),
             ") or lower board_w (currently ", board_w, ")."));

if (board_gap_end < 0.2)
    echo(str("WARNING: only ", board_gap_end, " mm past the board's far edge, ",
             "so it is a press fit lengthwise and the antenna is hard against ",
             "the end wall. Raise antenna_gap (currently ", antenna_gap, ")."));

/* The USB opening has no rib to clear — the rib is notched away over its width,
   which is what lets the lid come down onto the components. What the rib still
   has to miss is the BOARD it hangs over, and that is the check. It only bites
   when cavity_h is pinned by hand; the derived cavity already includes it. */
assert(cavity - rib_h >= board_top,
       str("The lid's rib reaches ", cavity - rib_h,
           " above the floor but the board's top face is at ", board_top,
           ", so the rib would land on the board. Raise cavity_h to at least ",
           board_top + rib_h, ", or lower rib_h."));

// the far end opening's rib is notched away too, so what is left to check is
// that the opening fits under the lid at all
assert(!end_opening || opening_z + end_h <= cavity,
       str("The far end opening runs out of the top of the case: it tops out ",
           opening_z + end_h, " above the floor, but the cavity is only ",
           cavity, " deep. Raise cavity_h, or lower end_h/opening_z."));

// Spelled out rather than a search() over a list: search() on a string matches
// per CHARACTER, which quietly passed "micro" and rejected "c".
assert(usb_type == "micro" || usb_type == "c" || usb_type == "mini"
       || usb_type == "a" || usb_type == "custom",
       str("Unknown usb_type \"", usb_type,
           "\". Use micro, c, mini, a or custom. Anything else falls through ",
           "to usb_w / usb_h without telling you."));

assert(!usb_opening || usb_ow <= inner_w,
       str("The ", usb_type, " USB opening is ", usb_ow,
           " mm wide, more than the ", inner_w, " mm interior."));

assert(!end_opening || end_w <= inner_w,
       str("end_w ", end_w, " exceeds the interior width ", inner_w, "."));

// pocket is clamped to at least `hole`, so this can only fail if the clamp
// itself is wrong — it is here to catch that, not the user
assert(!terminal_recess || pocket >= hole,
       str("The pocket ", pocket, " is narrower than the pin hole ", hole,
           " above it, which would choke the pin. Lower pocket_wall."));

/* Whether you actually got separate pockets, or one slot wearing their name.

   Reported rather than asserted, because a merged row is not broken — it is the
   old continuous trough, and at 2.54 pitch it is the only thing a full-width
   crimp terminal fits into. But it is not what "a hole per pin" looks like, and
   the difference is invisible in a render, so it gets said out loud.

   Skipped with a surround on, which merges them for a reason of its own and has
   already said so: blaming pocket_wall there names a setting the user did not
   touch and tells them to raise something that is now ignored. */
if (terminal_recess && !dupont_housing && pockets_merged)
    echo(str("NOTE: pocket_wall is 0, so the pockets touch and merge into one ",
             "continuous slot down each row rather than staying separate. That ",
             "is the older behaviour, and at a ", pin_pitch, " mm pin_pitch it is what ",
             "a full-width crimp terminal needs. Raise pocket_wall to divide ",
             "them."));

// the hole clamp beat the request: a fine pitch cannot give both a pin-sized
// pocket and a printable divider, and the pin has to win
if (terminal_recess && pocket_gap > 0.001 && pocket_gap < pocket_wall_eff - 0.001)
    echo(str("NOTE: pocket_wall ", pocket_wall_eff, " would leave a pocket only ",
             pin_pitch - pocket_wall_eff, " mm long, narrower than the ", hole,
             " mm hole above it, so the pocket was held at ", pocket,
             " mm and the divider came out ", pocket_gap, " mm instead. At a ",
             pin_pitch, " mm pin_pitch that is as much wall as a pin-sized pocket ",
             "leaves."));

if (terminal_recess && pocket_gap > 0.001 && pocket_gap < 0.8)
    echo(str("WARNING: only ", pocket_gap, " mm of wall between one pocket and ",
             "the next — under two 0.4mm perimeters, so the dividers print as ",
             "a single bead rather than a wall. They will be fragile."));

/* pocket_wall is the lever normally, but a surround holds it at 0 and sizes the
   pocket from the pitch instead, so the advice has to change with it. */
pocket_lever = dupont_housing
             ? "or untick dupont_housing — the plastic surround is what made the pocket this big"
             : "or raise pocket_wall to shrink the pocket";

assert(!terminal_recess || row_a_y - pocket / 2 >= wall,
       str("The terminal pockets cut into the side wall: they reach ",
           row_a_y - pocket / 2, " but the wall ends at ", wall,
           ". Raise side_margin, ", pocket_lever, "."));

assert(!terminal_recess || 2 * (row_a_y + pocket / 2) < width ||
       row_b_y - pocket / 2 > row_a_y + pocket / 2,
       str("The two rows of pockets overlap in the middle. Raise row_spacing, ",
           pocket_lever, "."));

/* A channel that stops inside the plate never reaches the trough at all, so the
   pin stops on plastic — while the render looks perfectly healthy, because the
   cut is clean and the case is still manifold. Clamped up to the minimum rather
   than rejected; this only reports it.

   With a square trough the minimum is just hole_plate_t, which is a far simpler
   thing to explain than it was when a tapering roof made it depend on the trough
   and the roof angle too. */
if (slot_on && terminal_recess && pin_slot_depth < slot_min_depth)
    echo(str("NOTE: pin_slot_depth ", pin_slot_depth, " does not get through ",
             "the hole plate, so the channel was cut ", slot_min_depth,
             " mm instead — anything less stops inside the plate and opens ",
             "into nothing. The floor is hole_plate_t (", hole_plate_t,
             "); below that there is trough all the way down."));

// Deeper than the trough itself and the channel comes out of the bottom of the
// case, which is the one thing sealing the base is for.
assert(!slot_on || !seal_bottom || slot_z0 >= base_t,
       str("pin_slot_depth ", pin_slot_depth, " cuts through the sealed base: ",
           "the channel reaches ", slot_z0, " but the slab under the troughs ",
           "starts at ", base_t, ". Lower pin_slot_depth to at most ",
           floor_t - base_t, ", or raise floor_solid."));

// Same guard for the channel, and same story: the clamp keeps it clear, so this
// is the width_override path only.
assert(!slot_on || row_a_y - slot_cut_w / 2 >= wall - fuzz,
       str("The pin channel cuts into the side wall: row centre ", row_a_y,
           " with a ", slot_cut_w, " mm channel reaches ",
           row_a_y - slot_cut_w / 2, " but the wall ends at ", wall,
           ". Raise width_override, or narrow pin_slot_w."));

/* The clamp is not silent: a number you set that is not the number you got has
   to say so, or the slider looks like it did nothing. */
if (side_margin < side_margin_min - fuzz)
    echo(str("NOTE: side_margin ", side_margin, " was raised to ",
             side_margin_eff, " mm. The ", row_cut, " mm ",
             slot_on ? "pin channel" : "pin hole",
             " is centred on the row, so half of it — ", side_margin_min,
             " mm — has to clear the wall or it opens into the side of the ",
             "case. Narrow ", slot_on ? "pin_slot_w" : "hole_clearance",
             " to bring that floor down."));

// With floor_relief on, the plinth is all that carries the channel's two sides.
// A warning rather than an assert: it still renders and still prints, it just
// gets fragile, and how fragile depends on a nozzle the model cannot know.
//
// The advice at the end has to follow whichever demand set the plinth. Once it
// is reaching the side wall, plinth_wall is not what is holding the width up
// any more and raising it moves nothing — the width comes from side_margin.
if (slot_on && relief && (plinth_w - slot_cut_w) / 2 < 0.8)
    echo(str("WARNING: the ", slot_cut_w, " mm pin channel leaves only ",
             (plinth_w - slot_cut_w) / 2, " mm of plinth each side of it, ",
             "which is under two 0.4mm perimeters. The channel walls will be ",
             "weak. Lower pin_slot_w to ", plinth_w - 1.6,
             wall_bound
               ? str(" or less. Raising plinth_wall will not help here: the ",
                     "plinth is as wide as it is to reach the side wall, so it ",
                     "takes side_margin to widen it further.")
               : " or less, or raise plinth_wall."));

/* A channel wider than the trough it opens onto is a wide pocket over a
   narrower slot, and only the slot goes anywhere. Say so with the number,
   because "4mm channel" sounds like 4mm of clear passage and it is not. It
   still prints — the shelf either side is the top of solid plinth and faces up,
   not down, so it adds no overhang.

   The fix is now one thing rather than two. With the ridge gone, the pocket IS
   the opening at every depth, so widening the trough widens the passage; it
   used to be that a wider trough was also a taller one and the channel landed
   at the same point on the slope, so depth had to move as well. */
if (slot_on && terminal_recess && slot_ledge > 0.15)
    echo(str("NOTE: the ", slot_cut_w, " mm pin channel opens onto a trough ",
             "only ", pocket, " mm wide, so the ", slot_ledge,
             " mm each side is solid floor rather than a way through. The pins ",
             "sit on the centreline so they pass. Lower pin_slot_w to ",
             pocket, " to match the pocket",
             dupont_housing
               ? str(" — with a plastic surround that is as wide as the trough ",
                     "goes, since the pin_pitch is what sizes it.")
               : ", or lower pocket_wall to widen the pocket."));

// pin_slot_depth is the one parameter here that quietly does nothing, so say so
if (slot_on && !terminal_recess && pin_slot_depth != plate_t)
    echo(str("NOTE: terminal_recess is off, so there is no trough for the pin ",
             "channel to reach and pin_slot_depth (", pin_slot_depth,
             ") is ignored. The channel is cut ", plate_t,
             " mm, straight through the floor, exactly as the holes were."));

assert(!relief || floor_solid < floor_t - 0.4,
       str("floor_relief has nothing to remove: floor_solid ", floor_solid,
           " is not thinner than the ", floor_t, " floor the troughs need. ",
           "Lower floor_solid, or switch floor_relief off."));

/* The plinth width is a max() of two demands, so say which one won and what it
   produced. Neither is deducible from a render: both make the same shape and
   only the numbers differ, and plinth_wall goes quiet the moment the side wall
   is what sets the width. */
if (relief)
    echo(str("Plinth ", plinth_w, " mm wide per row, set by ",
             wall_bound
               ? str("reaching the side wall (row centre ", row_a_y, " less the ",
                     wall, " mm wall, doubled to stay centred on the row), over ",
                     "the ", pocket + 2 * plinth_wall,
                     " mm the trough and plinth_wall ask for")
               : str("the trough and its walls (pocket ", pocket, " + 2 x ",
                     plinth_wall, "), which is wider than the ",
                     2 * (row_a_y - wall), " mm it takes to reach the side wall"),
             ". It runs from ", row_a_y - plinth_w / 2, " to ",
             row_a_y + plinth_w / 2, " in Y, and the board's edge sits at ",
             wall + board_gap_side, ". Relief left between the two plinths: ",
             bay_open ? str(relief_bay, " mm.")
                      : "none — the floor comes out solid across."));

// A bay under a millimetre is spared as solid, so there is nothing for the wire
// channels to break out INTO. Same failure as floor_relief off, different cause.
if (wire_channels && relief && !bay_open)
    echo(str("WARNING: the plinths have met in the middle (bay ", relief_bay,
             " mm), so the floor is solid across and the wire channels dead-end ",
             "in it. The wire has to climb out of the top instead, with only ",
             board_under, " mm before it fouls the board. Lower side_margin, or ",
             "narrow the plinth with a smaller pocket."));

assert(!vents ||
       (vent_zone_x0 >= wall && vent_cx + vent_zone_l / 2 <= length - wall),
       str("The vent patch runs off the lid: it spans ", vent_zone_x0, " to ",
           vent_cx + vent_zone_l / 2, " but the lid's walls run ", wall, " to ",
           length - wall, ". Lower vent_zone_l or vent_from_end."));

assert(!vents || vent_fit != "stretch" || vent_zone_w <= inner_w,
       str("vent_zone_w ", vent_zone_w, " exceeds the interior width ",
           inner_w, ". It only binds with vent_fit = stretch; on aspect the ",
           "artwork's own proportions set the height."));

assert(closure != "screw" || screw_pilot_d < boss_d - 1.2,
       str("Screw boss wall is too thin: pilot ", screw_pilot_d, " in a ",
           boss_d, " boss. Raise boss_d or lower screw_pilot_d."));

if (wire_channels && !relief)
    echo(str("WARNING: with floor_relief off there is no plinth for the wire ",
             "channel to break out of, so it dead-ends in the floor. The wire ",
             "has to climb out of the top instead, with only pcb_standoff (",
             pcb_standoff, " mm) before it fouls the board."));

/* What the surround decided, all in one place.

   Two parameters stop reaching geometry the moment this is ticked, and a
   setting that produces no visible change is indistinguishable from a broken
   one. So the tick has to say what it took over, with the numbers — not leave
   it to be deduced from a render that looks the same either way.

   It is worth saying what it did NOT take over too. wire_channel_w reads as a
   casualty of a surround and is not one, so the note names it explicitly. */
if (dupont_housing)
    echo(str("NOTE: dupont_housing is on, so the openings are sized for the ",
             "plastic surround, not the post: ", housing, " mm of surround (the ",
             pin_pitch, " pin_pitch, less 0.04 of moulding gap) plus hole_clearance ",
             hole_clearance, " = ", hole, " mm, against a post of ", post,
             " mm. That is ", hole - pin_pitch >= 0 ? "wider than" : "within",
             " the pin_pitch, so the row is ONE continuous ", slot_cut_w,
             " mm channel over one continuous ", pocket,
             " mm trough per row. Ignored as a result: pocket_wall (",
             pocket_wall, ", held at 0) and pin_slot (", pin_slot,
             ", held on). pin_slot_w is honoured above ", hole,
             " and clamped up to it below. wire_channel_w is NOT affected — ",
             wire_channels
               ? str("it is ", wire_channel_w, ", so the channel is sized to ",
                     "the PIN (", channel_w, " mm, leaving ",
                     pin_pitch - channel_w, " mm of rib), because what goes ",
                     "along it is a wire off a pin, not the connector")
               : str("it is 0, so there are no wire channels, which is your ",
                     "setting and not something the surround did"),
             ". Forcing pin_slot on also means the board follows ",
             "the usual rule for a channel wider than the header's strip: it ",
             board_drop > 0 ? str("DROPS ", board_drop, " mm, so it sits ")
                            : str("does not drop, so it sits "),
             board_under, " mm above the floor with the lid ",
             snap(cavity - board_top),
             " mm over it. The surrounds do not hold it up — they are pushed ",
             "up from below and held by friction on the pin, not standing on ",
             "anything."));

/* There is deliberately NO warning that terminal_len is too shallow for a
   housed connector.

   It used to warn below 12, on the assumption that you want the whole housing
   buried. You often do not: terminal_len is the trough's DEPTH, so it is the
   control for how much of the connector sits inside the case and how much shows
   below it, and leaving some proud is a legitimate thing to want — it is easier
   to grip and unplug, and it costs no case height. A model that calls that a
   mistake is telling you off for using the setting.

   Nothing is lost by dropping it. The trough depth is stated in the parameter's
   own comment, the console prints the case height it produced, and how long
   your housings are is a measurement only you have — so the model was guessing
   at 15mm to generate a number it had no way to know. */

echo(str("Case ", length, " x ", width, " x ", wall_h + lid_t,
         " mm  |  header ", pin_count, " x2 @ ", pin_pitch,
         dupont_housing ? str(" (", housing, " mm plastic surround)") : "",
         slot_on ? str("  |  ", slot_cut_w, " x ", slot_cut_d,
                        " mm pin channel",
                        slot_cut_w > hole ? " (clearance, not a fit)" : "")
                  : str("  |  ", hole, " mm holes, ", pin_pitch - hole,
                        " mm of plate between them"),
         wire_channels ? (channels_merged
                            ? str("  |  wire channels MERGED into one ",
                                  channel_w, " mm slot per row")
                            : str("  |  ", channel_w, " x ", channel_drop,
                                  " mm wire channels, ",
                                  pin_pitch - channel_w, " mm rib",
                                  abs(channel_w - pin_hole) < 0.005
                                    ? " (the pin's own width)" : " (set)"))
                       : "  |  no wire channels",
         "  |  ", pin_engage, " mm of pin inside the trough",
         seal_bottom ? str("  |  base SEALED, ", base_t, " mm under the troughs")
                     : "",
         "  |  board gap ", board_gap_side, " mm each side / ",
         board_gap_end, " mm at the far end",
         "  |  USB ", usb_type, " ", usb_ow, " x ", usb_oh,
         " at ", usb_z, " above the floor",
         "  |  antenna bay ", antenna_gap, " mm",
         vents ? str("  |  vents from ", vent_file) : "  |  no vents"));

if (label != "" && (label_x_est > inner_l || label_y_est > inner_w))
    echo(str("WARNING: the label looks too big for the lid — roughly ",
             label_x_est, " x ", label_y_est, " mm against an interior of ",
             inner_l, " x ", inner_w, ", so it will run off the edge. Shorten ",
             "it, lower label_size, or turn it with label_rotate. Estimated, ",
             "not measured: OpenSCAD cannot measure text without an ",
             "experimental option."));

// There is no way to ask OpenSCAD whether a file exists, so this cannot be an
// assert. Watch the console: a missing vent_file prints "ERROR: Can't open
// file" from import(), and then carries on to render a lid with NO VENTS and
// Status: NoError. A silently unvented lid is the failure to look out for.

// a sealed trough is a blind pocket, so there is no way to get a terminal into
// it and no reason to talk about grip — but the tail still has to fit
if (seal_bottom && terminal_recess && pin_engage > terminal_len)
    echo(str("WARNING: the pins reach ", pin_engage,
             " mm into a sealed trough only ", terminal_len,
             " mm deep, so they will bottom out and lift the board ",
             pin_engage - terminal_len, " mm. Raise terminal_len, or trim ",
             "the pins and lower pin_length."));

/* Below zero the pin never even leaves the plate, so there is nothing in the
   pocket for a terminal to find and the recess cannot do its job at all. That
   is not a warning, it is the wrong hardware for this option — and it rendered
   a perfectly good case while reporting "-0.2 mm of pin", which is not a length
   anything can have. */
assert(!terminal_recess || pin_engage > 0,
       str("Pins are too short for the terminal recess: ", pin_length,
           " mm of pin, but ", pin_free, " mm is spent crossing the standoff (",
           board_under, ") and the plate (", plate_t,
           "), leaving ", pin_engage, ". Use longer pins, lower pcb_standoff, ",
           "or set terminal_recess = false and let the connectors sit below ",
           "the case."));

// An open underside does not stop a long tail coming through it. Reported as a
// measurement, not a fault: how far the pins reach is your call, and there are
// reasons to want them proud.
if (!seal_bottom && pin_protrude > 0)
    echo(str("NOTE: the pins reach ", pin_protrude,
             " mm past the underside — ", pin_length, " mm of pin against ",
             board_under + floor_t, " mm from the board to the bottom."));

if (terminal_recess && !seal_bottom && pin_engage < 2)
    echo(str("WARNING: only ", pin_engage, " mm of pin reaches into the trough. ",
             "A crimp terminal needs roughly 2-4mm to grip. Use longer pins, ",
             "or lower pcb_standoff (", pcb_standoff, ") / hole_plate_t (",
             hole_plate_t, ")."));


// --- Primitives -----------------------------------------------------------

/* A box with its four vertical edges rounded, one corner at the origin.
   The hull of four corner cylinders — $fn comes from the caller. */
module rounded_box(x, y, z, r) {
    assert(r > 0 && 2 * r <= x && 2 * r <= y,
           str("rounded_box: radius ", r, " does not fit a ", x, " x ", y, " footprint."));
    hull()
        for (px = [r, x - r])
            for (py = [r, y - r])
                translate([px, py, 0]) cylinder(r = r, h = z);
}

/* An axis-aligned square prism, centred on x/y. */
module sq_prism(s, h) {
    translate([-s / 2, -s / 2, 0]) cube([s, s, h]);
}

/* A closed ring following the case outline, between two insets from the outer
   face. The lid's rib is cut from this.

   Each boundary's corner radius is corner_r minus its own inset, which is what
   makes the ring a CONSTANT width all the way round. The floor under that has
   to be tiny, because it is the inner boundary that runs out first: clamping it
   up pulls the inner corner back and leaves a lump of material behind it. At
   0.3 the rib measured 3.245mm thick at the corners against 1.203 on the
   straights — nearly three times, and plainly visible as a step rather than the
   even rib it is meant to be. rounded_box only needs r > 0.

   Past the corner the inner radius would go negative — the rib is thicker than
   the corner is round — and the floor makes it a near-square corner instead,
   which is the right limit: the ring simply fills the corner. */
module outline_ring(a, b, h) {
    translate([a, a, 0]) difference() {
        rounded_box(length - 2 * a, width - 2 * a, h, max(corner_r - a, 0.01));
        translate([b - a, b - a, -0.1])
            rounded_box(length - 2 * b, width - 2 * b, h + 0.2,
                        max(corner_r - b, 0.01));
    }
}


// --- Pin holes ------------------------------------------------------------

/* One clearance hole through a plate `t` thick: a plain square bore, `size`
   across from top to bottom. The tray and the fit template both cut their holes
   with this, so what the template reports is what the case will give — which is
   the only reason it is still a module now that it is one
   line of geometry. */
module plate_hole(t, size) {
    translate([0, 0, -0.1]) sq_prism(size, t + 0.2);
}

/* The continuous version of a whole row of plate_hole()s: one channel
   slot_cut_w wide, running from the first pin's centre to the last, cut through
   a plate `t` thick starting at z0. Positioned in x by the header itself, so it
   cannot drift away from where the holes would have been.

   Its LENGTH is the header's, not the width's: the channel covers exactly the
   ground the row of holes covered, from the first hole's outer edge to the
   last's, however wide pin_slot_w makes it. Widening it must not also lengthen
   it — past the end pins there is no trough underneath any more, and the
   channel would bottom out on solid plinth.

   Straight-sided, like the holes it replaces. It had a swept chamfer along its
   mouth to match their funnels; both went together, so the channel is
   slot_cut_w across at every depth. */
module pin_slot_row(cy, z0, t) {
    x0 = x_first - hole / 2;
    x1 = x_first + span + hole / 2;

    translate([x0, cy - slot_cut_w / 2, z0 - 0.1])
        cube([x1 - x0, slot_cut_w, t + 0.2]);
}

/* One row of header holes through the hole plate: a square clearance hole and
   its wire channel. The hole is a plain bore — no funnel on the upper side any
   more — so it is `hole` across at every depth, and nothing about it can differ
   between the tray and the template.

   The channel runs out through the plinth's side at channel_w, which by default
   is the PIN's own hole — so at the defaults it is the hole continued sideways
   at the same width, and the rib between two channels is the same rib as
   between two holes. A wire coming off a pin therefore leaves at plate level
   and drops into the relieved floor, rather than climbing over the plinth top,
   where it would have only pcb_standoff of room before it fouled the board.

   It parts company with `hole` in two cases, both deliberate: dupont_housing
   widens the hole to the plastic surround and the channel does NOT follow, and
   wire_channel_w sets it outright. Either way it is ONE width, not the neck and
   the separate wire_w it used to have — that keyhole cost three parameters and
   made the rib between two channels a different number from the rib between two
   holes, with no way to see which was binding. */
module pin_row(cy) {
    dir = cy < width / 2 ? 1 : -1;      // always toward the middle of the box

    // One channel down the row, or one hole per pin. The channel is measured
    // from the floor's top face rather than from hole_z0: it does not have to
    // start at the trough's shoulder the way a hole does, only to get low
    // enough that the trough's roof has opened out to the channel's own width.
    if (slot_on)
        pin_slot_row(cy, slot_z0, floor_t - slot_z0);

    for (i = [0 : pin_count - 1]) {
        cx = x_first + i * pin_pitch;
        translate([cx, cy, hole_z0]) {
            if (!slot_on) plate_hole(hole_h, hole);

            if (wire_channels && !channels_merged)
                translate([-channel_w / 2,
                           dir > 0 ? 0 : -slot_reach,
                           -0.1 - channel_drop])
                    cube([channel_w, slot_reach, hole_h + 0.2 + channel_drop]);
        }
    }

    /* Merged, the channels are ONE cut spanning the row rather than a row of
       cubes meeting face to face. Same extent either way — the union of the
       cubes runs x_first - channel_w/2 to x_first + span + channel_w/2 the
       moment channel_w reaches the pitch — but touching cubes are the butting
       case that makes non-manifold edges and a negative genus, which is the
       trap the pockets already fell into once. */
    if (wire_channels && channels_merged)
        translate([x_first - channel_w / 2,
                   cy + (dir > 0 ? 0 : -slot_reach),
                   hole_z0 - 0.1 - channel_drop])
            cube([span + channel_w, slot_reach,
                  hole_h + 0.2 + channel_drop]);
}

/* A trough under each pin row, open at the underside of the case. The Dupont
   connectors push up into it so they finish flush with the floor rather than
   hanging below, and the wires leave straight down out of the open bottom.

   Square: straight sides all the way from the underside to the hole plate, so a
   connector can rise the full terminal_len and grip everything the pin has to
   offer. The ceiling it leaves is a bridge `pocket` across, anchored on both
   trough walls — the slicer spans the short way, and at 3mm that needs no
   support. It is two narrow troughs rather than one full-width recess for that
   reason: 3mm bridges, a 28mm floor would not.

   Open at the bottom normally, so the connectors go in and the wires come out.
   Sealed, the cut stops at base_t and the slab below closes it into a blind
   pocket — the floor of that pocket faces up, so it still prints unsupported. */
module terminal_troughs() {
    z0 = seal_bottom ? base_t : -0.1;
    h  = plate_z - z0;

    if (terminal_recess)
        for (cy = [row_a_y, row_b_y])
            /* Merged, this is ONE cut rather than a row of cubes meeting face
               to face. Same extent either way — see pockets_merged — but a row
               of exactly-touching cubes is the butting case that makes
               non-manifold edges and a negative genus. */
            if (pockets_merged)
                translate([trough_x0, cy - pocket / 2, z0])
                    cube([trough_x1 - trough_x0, pocket, h]);
            else
                for (i = [0 : pin_count - 1])
                    translate([x_first + i * pin_pitch - pocket / 2,
                               cy - pocket / 2, z0])
                        cube([pocket, pocket, h]);
}

/* The floor only has to be floor_t thick where a trough runs through it.
   Everywhere else it drops to floor_solid, which leaves a raised plinth along
   each pin row, carrying its trough and running out to the side wall.

   Cut downward out of the cavity, so every face it makes is either vertical or
   upward-facing: no new overhang, and the tray still prints without support.
   What it deliberately spares is anything that would otherwise be left standing
   on air — a pillar under each PCB rest, and one under each screw boss. */
module floor_relief_cut() {
    if (relief)
        difference() {
            translate([wall, wall, floor_solid])
                rounded_box(inner_l, inner_w, floor_t - floor_solid + 0.1, inner_r);

            // The rest pads used to be spared here too, each on its own
            // pillar so it was not left standing on air. With the pads gone
            // the plinths and the screw bosses are all that need solid ground.
            //
            // The outboard face is pushed 0.5 PAST the interior wall rather
            // than landing on it. Coplanar faces in a difference() have dropped
            // a face in this file before; the inboard face is left exact,
            // because that is the one slot_reach has to break through.
            if (bay_open)
                for (cy = [row_a_y, row_b_y])
                    let (out = cy < width / 2 ? 0.5 : 0)
                        translate([plinth_x0, cy - plinth_w / 2 - out,
                                   floor_solid - 0.1])
                            cube([plinth_x1 - plinth_x0, plinth_w + 0.5, floor_t]);
            else
                // The bay has closed to a sliver. Spare it as ONE box: same
                // extent as the two, but a row of cubes meeting face to face is
                // the butting case that makes non-manifold edges.
                translate([plinth_x0, wall - 0.5, floor_solid - 0.1])
                    cube([plinth_x1 - plinth_x0, inner_w + 1, floor_t]);

            if (closure == "screw")
                for (bx = [wall + boss_d / 2, length - wall - boss_d / 2])
                    for (by = [wall + boss_d / 2, width - wall - boss_d / 2])
                        translate([bx, by, floor_solid - 0.1])
                            cylinder(d = boss_d, h = floor_t);
        }
}


// --- Tray -----------------------------------------------------------------

/* The opening's outline, drawn centred in 2D and swept through the wall.

   Connector shells are not rectangles, and on a flush mount that shows: the
   whole point is the socket meeting the wall, so every corner the real shell
   curves away from is a gap a rectangle leaves behind.

       USB-C     an obround — a rectangle capped with semicircles, radius
                 exactly half the height, which is what the spec draws
       micro     a trapezoid, wider at the top. That taper is the thing that
       / mini    stops a micro plug going in upside down, so it is the most
                 recognisable part of the outline to get right
       USB-A     genuinely a rectangle, so it stays one

   The taper is approximate — a shell's exact draft varies by manufacturer far
   more than its overall size does. Bounding size is what the asserts and the
   cavity height use, and that is unchanged. */
module usb_profile(w, h) {
    taper = usb_type == "micro" ? 0.9 : usb_type == "mini" ? 1.2 : 0;

    if (usb_type == "c") {
        r = h / 2;
        hull()
            for (dx = [-1, 1])
                translate([dx * (w / 2 - r), 0]) circle(r = r);
    } else if (taper > 0) {
        bw = w - taper;                       // narrower at the bottom
        polygon([[-bw / 2, -h / 2], [bw / 2, -h / 2],
                 [ w / 2,   h / 2], [-w / 2,  h / 2]]);
    } else {
        square([w, h], center = true);
    }
}

module openings() {
    if (usb_opening) {
        translate([-0.1, width / 2, floor_t + usb_z + usb_oh / 2])
            rotate([90, 0, 90])
                linear_extrude(wall + 0.2)
                    usb_profile(usb_ow, usb_oh);

        /* The slot the overhanging nose slides down, from the opening's widest
           point clear up through the wall's top edge.

           Dropped 0.1 so it OVERLAPS the profile rather than butting onto it.
           Landing its base exactly on the profile's top, at exactly the same
           width, makes two coincident faces and the union comes back with
           non-manifold edges along the seam — 8 of them, where the rest of the
           tray has none. The step this leaves in the taper is under 0.05mm. */
        if (usb_notch && usb_wall_above > 0)
            translate([-0.1, (width - usb_ow) / 2,
                       floor_t + usb_notch_z - 0.1])
                cube([wall + 0.2, usb_ow,
                      wall_h - floor_t - usb_notch_z + 0.2]);
    }
    if (end_opening)
        translate([length - wall - 0.1, (width - end_w) / 2, floor_t + opening_z])
            cube([wall + 0.2, end_w, end_h]);
}

module screw_bosses() {
    for (bx = [wall + boss_d / 2, length - wall - boss_d / 2])
        for (by = [wall + boss_d / 2, width - wall - boss_d / 2])
            translate([bx, by, floor_t]) cylinder(d = boss_d, h = cavity);
}

module tray() {
    difference() {
        union() {
            difference() {
                rounded_box(length, width, wall_h, corner_r);

                // interior
                translate([wall, wall, floor_t])
                    rounded_box(inner_l, inner_w, cavity + 0.1, inner_r);

                openings();
            }

            if (closure == "screw") screw_bosses();
        }

        // dimples for the lid's latch balls, a touch oversize so they seat
        latch_balls(latch_r + latch_fit, wall_h + latch_z);

        // cut the header last so nothing added above can plug it
        pin_row(row_a_y);
        pin_row(row_b_y);
        terminal_troughs();
        floor_relief_cut();

        if (closure == "screw")
            for (bx = [wall + boss_d / 2, length - wall - boss_d / 2])
                for (by = [wall + boss_d / 2, width - wall - boss_d / 2])
                    translate([bx, by, floor_t + 0.6])
                        cylinder(d = screw_pilot_d, h = cavity);
    }
}


// --- Lid ------------------------------------------------------------------

/* Whatever the vent patch is made of, as a 2D shape centred on the origin. */
module vent_art() {
    if (vent_format == "png")
        // a heightmap sliced at vent_level: everything brighter becomes an
        // opening. The edges land on the pixel grid, which is why SVG is better.
        projection(cut = true)
            translate([0, 0, -vent_level])
                surface(file = vent_file, center = true, invert = vent_invert);
    else
        import(vent_file, center = true);
}

/* Openings confined to a patch over the radio module, which is the only part of
   a devkit that runs warm. Keeping them off the rest of the plate leaves the lid
   stiff and gives the label somewhere to live.

   Drawn in the xy plane and cut clean through, so the shape reads the right way
   round when you look at the closed case from above. */
module lid_vents() {
    if (vents)
        translate([vent_cx, width / 2, -0.1])
            linear_extrude(lid_t + 0.2)
                resize(vent_fit == "stretch" ? [vent_zone_l, vent_zone_w]
                                             : [vent_zone_l, 0], auto = true)
                    rotate(vent_angle)
                        vent_art();
}

/* Lid in assembled orientation: z = 0 is the underside that meets the top of
   the tray wall, the tongue hangs below it, the plate sits above. */
module lid_assembled() {
    difference() {
        union() {
            translate([0, 0, 0]) rounded_box(length, width, lid_t, corner_r);
            translate([0, 0, -tongue_h])
                outline_ring(rib_a, rib_b, tongue_h);

            // fills the USB notch, so the end wall closes up when the lid is on
            if (usb_notch && usb_tab_h > 0)
                translate([0, (width - usb_tab_w) / 2, -usb_tab_h])
                    cube([wall, usb_tab_w, usb_tab_h]);

            latch_balls(latch_r, latch_z);
        }

        /* The rib steps around the socket.

           Without this the rib is what sets the case height: it hangs down the
           inside of the end wall, the socket stands up just inside that wall,
           and the cavity has to be deep enough that they miss each other. Cut
           the rib away over the socket's width and the lid comes down 2.6mm,
           until it is the components holding it up instead.

           Only the rib is cut, not the tab beside it — the tab lives in the
           wall's thickness at x 0..wall, the rib starts at wall + clearance. */
        if (usb_opening)
            translate([rib_a - 0.05, (width - usb_ow) / 2, -tongue_h - 0.1])
                cube([rib_w + 0.1, usb_ow, tongue_h + 0.1]);

        // and the same at the far end, for whatever goes through there — without
        // it the end opening has to finish below the rib, which is exactly the
        // constraint the notch exists to remove
        if (end_opening)
            translate([length - rib_b - 0.05, (width - end_w) / 2,
                       -tongue_h - 0.1])
                cube([rib_w + 0.1, end_w, tongue_h + 0.1]);

        lid_vents();

        if (label != "")
            translate([label_cx, width / 2, lid_t - label_depth])
                rotate(label_rotate)
                    linear_extrude(label_depth + 0.1)
                        text(label, size = label_size, halign = "center",
                             valign = "center", $fn = 32);

        if (closure == "screw")
            for (bx = [wall + boss_d / 2, length - wall - boss_d / 2])
                for (by = [wall + boss_d / 2, width - wall - boss_d / 2])
                    translate([bx, by, -tongue_h - 1])
                        cylinder(d = screw_d, h = lid_t + tongue_h + 2);
    }
}

/* Where the latches sit. One list of positions, used by the lid to place the
   balls and by the tray to cut the dimples, so the two cannot drift apart. The
   tray passes a slightly bigger radius and the assembled height. */
module latch_balls(r, z0) {
    if (latches && latch_count > 0)
        for (i = [0 : latch_count - 1]) {
            lx = latch_count == 1 ? length / 2
               : length * 0.25 + i * (length * 0.5) / (latch_count - 1);
            for (ly = [latch_y, width - latch_y])
                translate([lx, ly, z0]) sphere(r = r, $fn = 32);
        }
}

/* Print orientation: rolled over so the plate lies on the bed. */
module lid() {
    translate([0, width, lid_t]) rotate([180, 0, 0]) lid_assembled();
}



// --- Fit template ---------------------------------------------------------

/* A shallow stand-in for the tray: same footprint, same interior outline, same
   pin holes in the same places, same rests, same screw bosses — but a few
   millimetres tall instead of twenty.

   Drop your actual board into it and a short print answers the three things
   that would otherwise only surface once the real tray is done: whether the
   board fits between the walls, whether the header lines up with the holes,
   and whether the module has its antenna bay. It is a geometry check at case
   scale: it answers whether the parts fit each other, not how tightly a pin
   grips, which only the real thing will tell you. */
module template() {
    difference() {
        union() {
            difference() {
                rounded_box(length, width, template_t + template_rim, corner_r);

                translate([wall, wall, template_t])
                    rounded_box(inner_l, inner_w, template_rim + 0.1, inner_r);

                // notch the rim so you can see the socket line up
                if (usb_opening)
                    translate([-0.1, (width - usb_ow) / 2, template_t])
                        cube([wall + 0.2, usb_ow, template_rim + 0.1]);
            }

            // stubs, so you can see whether the bosses crowd the board
            if (closure == "screw")
                for (bx = [wall + boss_d / 2, length - wall - boss_d / 2])
                    for (by = [wall + boss_d / 2, width - wall - boss_d / 2])
                        translate([bx, by, template_t])
                            cylinder(d = boss_d, h = template_rim);
        }

        // the real opening, in the real place — a channel if the tray has one,
        // or the holes if it does not. It has to follow: at the pitch that
        // makes the channel worth switching on, a template full of separate
        // holes is exactly as unprintable as the tray would have been.
        for (cy = [row_a_y, row_b_y])
            if (slot_on)
                pin_slot_row(cy, 0, template_t);
            else
                for (i = [0 : pin_count - 1])
                    translate([x_first + i * pin_pitch, cy, 0])
                        plate_hole(template_t, hole);

        // a scored line at the board's far edge — everything past it is bay
        if (antenna_gap > 0)
            translate([pcb_x + pcb_l + 0.1, wall, template_t - 0.4])
                cube([0.4, inner_w, 0.5]);
    }
}


// --- Render ---------------------------------------------------------------

if (part == "tray")          tray();
else if (part == "lid")      lid();
else if (part == "template") template();
else if (part == "all") {
    tray();
    translate([0, width + layout_gap, 0]) lid();
}
else if (part == "assembled") {
    tray();
    translate([0, 0, wall_h]) lid_assembled();
}
else assert(false, str("Unknown part \"", part,
                       "\". Use tray, lid, template, all or assembled."));
