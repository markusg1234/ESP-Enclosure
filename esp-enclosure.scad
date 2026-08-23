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
   tray, the template and the coupon render from it alone.

   The lid is the exception: its vents are cut from artwork in an SVG beside
   this one, named by vent_file. slots.svg (plain bars) and wifi.svg ship with
   it. That file has to travel with the model, and the Thingiverse / Printables
   web customizers cannot resolve it — they will fail to render the lid. Set
   vents = false and everything is standalone again.

   Open in OpenSCAD, then Window > Customizer. Pick a part with `part` at the
   top, press F6, then File > Export > STL.

   EVERY DIMENSION IS IN MILLIMETRES. The only settings that are not are the
   handful marked (in degrees), the plain counts, and the on/off switches.

   >> PRINT THE FIT COUPON FIRST. Set part = "coupon". It is a 2-minute print
   >> that tells you which hole clearance actually grips your pins, before you
   >> commit to a whole case. The Dupont and board defaults below are sensible
   >> starting points, not verified specifications for your hardware.
   =========================================================================== */


/* [Part] */

// Which part to render
part = "tray";          // [tray:Tray (bottom), lid:Lid (top), template:Fit template - check your board fits, coupon:Fit test coupon - check the hole size, all:Print layout, assembled:Assembly preview]

// Gap between parts in the print layout
layout_gap = 5;         // [0:0.5:40]


/* [Pin header] */

// Pins per row. Two rows, one down each long side.
pin_count = 19;         // [1:60]

// Centre-to-centre along the length. Ignored unless Dupont size = Custom. (mm)
pin_pitch = 2.54;       // [0.5:0.01:5]

// Centre-to-centre between the two rows, across the width (mm). 22.86 is 0.9
// inch, which is what most ESP devkits use; 25.4 is a full inch.
row_spacing = 22.86;    // [5:0.01:60]

// Shift the whole header along the length. (mm)
pin_x_offset = 0;       // [-20:0.01:20]


/* [Dupont size] */

// Standard Dupont families. Sets the post size, hole clearance and pitch.
dupont_preset = 254;    // [254:2.54mm standard, 200:2.00mm compact, 127:1.27mm micro, 0:Custom]

// Square pin post across the flats. Used only when preset = Custom. (mm)
custom_post = 0.64;     // [0.2:0.01:2]

// Added to the post size to get the hole (mm). Raise if pins bind, lower if
// loose.
hole_clearance = 0.36;  // [0:0.01:1.5]

// Funnel on the upper side of each hole, to guide a descending pin in. A plain
// 45-degree chamfer, so this is both how far it opens out and how deep it cuts.
// It is capped at half the plate so it can never reach the underside — see
// lead_d below for why that matters. (mm)
lead_in = 0.5;          // [0:0.05:2]

// A channel beside each pin hole, so you can bring a wire off a pin and out
// into the box instead of taking it down through the underside. It runs from
// the hole clear through the side of the plinth and opens onto the relieved
// floor. Off = plain holes, and about 0.5 cm3 less plastic removed.
wire_channels = true;

// Width where the channel leaves the hole. 0 = the full width of the hole, so
// the channel simply opens straight out of it.
//
// Set it BELOW the pin post (see the Dupont preset) and it becomes a keyhole
// instead: the neck traps the pin on all four sides, which braces the pin while
// you push a terminal onto it from below and keeps the lead-in a complete
// funnel. It makes no difference to the wire, which enters the channel from the
// trough underneath and never passes through here. (mm)
slot_w = 0;             // [0:0.05:2]

// How far the opening runs past the hole's edge, in mm, before it widens to
// wire_w.
slot_neck = 0.6;        // [0.2:0.05:3]

// Width of the channel past the neck. Size it for your wire's OUTSIDE
// diameter, insulation included — 26 AWG hook-up wire is about 1.2mm. (mm)
wire_w = 1.4;           // [0.4:0.05:4]

// How far the channel runs, measured from the hole's CENTRE. 0 = far enough to
// break out through the side of the plinth, which is the whole point: a
// channel that stops inside the plinth is a pocket, not a way out.
//
// The channel always runs toward the middle of the box. Outboard there is only
// the side wall a couple of millimetres away, so a channel that way has nowhere
// to put the wire; inboard it opens onto the relieved floor, which is the whole
// open area under the board. (mm)
slot_depth = 0;         // [0:0.1:8]


/* [Terminal recess] */

// Close the underside. The troughs are the only thing that opens through the
// bottom of the case, so this puts a slab of floor_solid under them and the
// case has no holes in its base.
//
// Nothing else changes: the pin holes, the troughs, the plinths, the wire
// channels and the rests all stay exactly as they are. The troughs simply
// become blind pockets, which is where the pin tails then sit — so a sealed
// base also removes any question of the tails fouling anything. The case grows
// by the thickness of the slab.
seal_bottom = false;

// Sink the Dupont connectors into a trough in the underside of the floor, so
// they finish flush instead of hanging below the case. The board sits up on
// its ledges, its pins drop through the hole plate, and the connectors push up
// into the trough from below. Wires leave straight out of the open underside.
terminal_recess = true;

// Trough depth — make this at least as long as the part of the connector that
// would otherwise stick out. About 6mm suits a bare crimp terminal; a full
// plastic Dupont housing needs more like 15mm and a much thicker floor. (mm)
terminal_len = 6.0;     // [1:0.1:25]

// Trough width. Wide enough for the connector body plus a little slack. (mm)
trough_w = 3.0;         // [1:0.1:10]

// Material left above the trough. The pin holes run through this, and it is
// what the trough has to bridge when printed. Thinner leaves more pin for the
// terminal to grip; too thin and the holes tear out. (mm)
hole_plate_t = 1.0;     // [0.6:0.1:4]

// How far the trough runs past the end pins, to get a finger in (mm)
trough_end_margin = 1.0; // [0:0.1:6]

// Angle of the ridge that roofs each trough, from horizontal. A flat trough
// ceiling would be a long unsupported span inside a slot too narrow to ever
// clean support out of, so the trough is peaked instead. 60 clears any
// slicer's threshold; lowering it makes the case shorter but riskier.
// In degrees.
trough_roof_angle = 65; // [40:1:80]

// Relieve the floor between the two troughs. Only the strips carrying the
// troughs need the full floor depth; the rest drops to floor_solid, leaving a
// raised plinth along each pin row just wide enough to hold its trough. The
// outside of the case does not change — this only takes plastic out.
floor_relief = true;

// Material left each side of a trough (mm), which sets the plinth width.
plinth_wall = 1.2;      // [0.4:0.1:5]


/* [Board] */

// PCB length. 0 = derive from the header.
board_l = 0;            // [0:0.1:200]

// PCB width. 0 = derive from the header.
board_w = 0;            // [0:0.1:200]

// Added each side of the header to get the auto PCB length (mm)
board_end_margin = 3.0; // [0:0.1:20]

// Added each side of the header to get the auto PCB width (mm)
board_side_margin = 1.5; // [0:0.1:20]

// Gap between the PCB and the interior wall (mm)
board_clearance = 0.4;  // [0:0.05:3]

// How far the PCB sits above the floor, set by the end ledges. Keep it just
// big enough to clear the solder joints — every millimetre here is a
// millimetre of pin that no longer reaches the terminal. (mm)
pcb_standoff = 1.2;     // [0:0.1:10]

// How far the header pins stick out below the PCB. MEASURE YOURS. The stock
// tail on a pre-soldered devkit is only about 3mm, which is not enough to
// cross the standoff and hole plate AND still grip a terminal — this default
// assumes long-tail headers. With short pins, set terminal_recess = false.
// Millimetres.
pin_length = 6.0;       // [1:0.1:20]

// PCB thickness. Only used to work out how tall the cavity has to be. (mm)
board_t = 1.6;          // [0.4:0.1:5]

// The tallest thing standing on TOP of the board, measured from the board's
// upper face. The radio module is about 3.1mm; a micro-USB socket is a little
// less. Raise it if your board has tall electrolytics. Only used to work out
// the cavity height, and ignored if you set cavity_h yourself. (mm)
component_h = 4.0;      // [1:0.1:40]

// Depth of the rests the PCB sits on, measured in from each end wall (mm)
ledge_d = 3.0;          // [0:0.1:12]

// Width of each rest. There are two at each end, in the corners, rather than
// one bar across the full width: the header pins already carry and locate the
// board, so the rests only have to stop it rocking (mm). Set ledge_d = 0 for
// none.
ledge_w = 6.0;          // [1:0.1:60]


/* [Case size] */

// Outer length. 0 = derive from the header.
length_override = 0;    // [0:0.1:250]

// Outer width. 0 = derive from the header.
width_override = 0;     // [0:0.1:250]

// Clear air added at the FAR end, past the board, for the module's onboard
// antenna. Devkits mount the radio module hard against that end of the board
// and the antenna sits at the module's tip, often overhanging the board edge —
// so without this the module fouls the end wall and the antenna radiates into
// plastic pressed right against it. The case grows at the far end only: the
// USB end, the header, the troughs and the board all stay exactly where they
// are. MEASURE YOUR OWN BOARD — this default is a starting point. (mm)
antenna_gap = 6.0;      // [0:0.1:30]

// Row centre to the outer side face. Carries the wall thickness: at 5.8 with a
// 3.2mm wall the interior is the same 30.8mm it was with a 2.4mm wall. (mm)
side_margin = 5.8;      // [2:0.01:30]

// Wall thickness. 3.2 is two 0.4mm perimeters either side of a 1.2mm lid slot,
// with enough left under the latch dimples to stay solid. (mm)
wall = 3.2;             // [1:0.05:6]

// Floor thickness: the whole floor when the terminal recess is switched off,
// or the thin part between the plinths when the floor relief is on. (mm)
floor_solid = 2.0;      // [0.8:0.1:8]

// Lid plate thickness (mm)
lid_t = 2.0;            // [0.8:0.1:8]

// Interior height above the floor. 0 = derive it, as the standoff plus the
// board plus whatever stands on top of the board, which is as short as the box
// can be and still close. Set a number to pin it.
cavity_h = 0;           // [0:0.1:60]

// Outer corner rounding (mm)
corner_r = 3.0;         // [1:0.1:12]


/* [Closure] */

// How the lid is held on
closure = "friction";   // [friction:Tongue and groove only, screw:Corner screw bosses]

// Width of the lid slot. Sets the rib that drops into it, and what is left of
// the lip either side. 1.2 in a 3.2mm wall gives 1.0mm lips and a 0.9mm rib —
// everything at two 0.4mm perimeters or better, with 0.55mm of lip still under
// the deepest point of a latch dimple. (mm)
groove_w = 1.2;         // [0.4:0.05:3]

// Depth of the slot in the wall top. The rib is this minus the clearance, so
// it is also how much springy rib the latches have to work with. Deeper grips
// and aligns better but costs height: the cavity has to be deep enough for the
// slot to clear the wall openings, so every millimetre here is a millimetre on
// the case until the board becomes the taller constraint again. (mm)
groove_depth = 4.0;     // [0.5:0.1:6]

// Clearance all round the joint. Raise if the lid is tight. (mm)
joint_clearance = 0.15; // [0:0.01:0.6]

// Screw clearance hole in the lid, e.g. 2.2 for M2 (mm)
screw_d = 2.2;          // [1:0.1:6]

// Pilot hole in the boss, e.g. 1.6 for an M2 self-tapper (mm)
screw_pilot_d = 1.6;    // [0.8:0.05:5]

// Screw boss outer diameter (mm)
boss_d = 4.5;           // [2:0.1:12]

// Ball latches: half-round bumps on the lid's rib that click into dimples in
// the slot wall, so the lid latches rather than only gripping by friction.
latches = true;

// How many down each long side
latch_count = 2;        // [0:1:6]

// How far the ball has to squeeze past the slot wall going in. This is the
// grip, and it is the number that has to survive your printer: below about
// 0.25mm on a 0.4mm nozzle it disappears into dimensional tolerance and you
// get either no click or a seized lid, unpredictably. (mm)
latch_grip = 0.35;      // [0.1:0.05:1]

// Slack in the tray's dimple so the ball seats instead of jamming on the way
// in. Comes straight off what is left of the lip, so do not be generous. (mm)
latch_fit = 0.10;       // [0:0.02:0.4]


/* [Openings] */

// Opening in the near end wall, for the USB socket
usb_opening = true;

// USB opening width (mm)
usb_w = 12;             // [1:0.1:60]

// USB opening height (mm)
usb_h = 6;              // [1:0.1:40]

// Opening in the far end wall
end_opening = false;

// Far end opening width (mm)
end_w = 8;              // [1:0.1:60]

// Far end opening height (mm)
end_h = 5;              // [1:0.1:40]

// Height of both openings above the floor top (mm)
opening_z = 0.5;        // [0:0.1:30]


/* [Lid] */

// Text engraved into the lid. Blank for none, which is the default — the
// engraving is the only thing on the lid that needs bridging, so leaving it
// off takes the lid to zero overhang.
label = "";

// Label size (mm)
label_size = 6;         // [2:0.5:20]

// How deep the label is engraved (mm)
label_depth = 0.6;      // [0.2:0.05:2]

// Where the label sits along the length. 0 = auto, centred in the space
// between the USB end and the vent patch. (mm)
label_x = 0;            // [0:0.1:250]

// Turn the label, in degrees, counter-clockwise as you look down at the closed
// case. -90 stands it on its side reading down the case, 90 reading up it.
// Unlike the vents there is no quarter turn built in: 0 is as you typed it.
label_rotate = 0;       // [-180:5:180]

// Ventilation over the radio module. The module is the only part of a devkit
// that gets meaningfully warm, so the openings sit over it rather than being
// spread across the lid — the rest of the plate stays solid and stiff.
vents = true;

// Centre of the vent patch, measured from the board's FAR edge (the end away
// from USB, where the radio module sits on most devkits). (mm)
vent_from_end = 15;     // [0:0.5:80]

// Length of the vent patch, along the case (mm)
vent_zone_l = 20;       // [2:0.5:80]

// Width of the vent patch, across the case. Used by the slots, and by
// vent_fit = stretch. With vent_fit = aspect it is not used at all: the
// artwork is scaled to vent_zone_l and its own proportions set the height.
// Millimetres.
vent_zone_w = 20;       // [2:0.5:60]


/* [Vent artwork] */

// How the artwork is scaled into the vent patch.
vent_fit = "aspect";    // [aspect:Keep its proportions, stretch:Fill the patch exactly]

// Turn the artwork on the lid, in degrees, counter-clockwise as you look down
// at the closed case.
//
// Zero is not "as drawn": artwork is laid down a quarter turn CLOCKWISE from
// how it sits in the file, which is what puts the shipped wifi.svg the right
// way round on the lid. This setting turns it further from there, so 0 is the
// orientation you want and you only touch it to deviate.
//
// Applied before the artwork is scaled, so vent_zone_l always measures across
// the finished orientation.
vent_rotate = 0;        // [-180:5:180]

// The artwork cut into the vent patch, which has to sit next to this file.
// slots.svg (plain bars) and wifi.svg ship alongside; drop in your own and
// name it here.
//
// >> THE LID NEEDS THIS FILE. Vents are always cut from artwork now, so the
// >> model is only standalone with vents = false. The Thingiverse and
// >> Printables customizers cannot resolve it and will fail to render the lid.
vent_file = "slots.svg";

// SVG imports as a true outline. PNG is read as a heightmap and thresholded,
// which leaves the edges stepped by the pixel grid — measured on a disc, a PNG
// wobbled 0.75mm on a 10mm radius where the SVG was exact. Prefer SVG.
vent_format = "svg";    // [svg:SVG - a true outline, png:PNG - stepped edges]

// PNG only: brightness cut-off. Pixels brighter than this become openings.
vent_level = 50;        // [0:1:100]

// PNG only: cut the dark parts instead of the light ones
vent_invert = false;


/* [Fit template] */

// Floor thickness of the fit template. Two or three layers is plenty — it only
// has to hold its shape while you drop the board in and look. (mm)
template_t = 1.2;       // [0.4:0.1:4]

// How high the template's wall stands. Enough to catch the board's edges and
// show you it clears, without printing a whole case. (mm)
template_rim = 3.0;     // [0:0.1:15]


/* [Quality] */

// Facets per full circle. 100+ for a final render, 30 for a fast preview.
$fn = 64;               // [12:200]


/* [Hidden] */


// --- Dupont preset lookup -------------------------------------------------
// No struct type in the Customizer, so presets are a ternary chain.

pitch = dupont_preset == 254 ? 2.54
      : dupont_preset == 200 ? 2.00
      : dupont_preset == 127 ? 1.27
      : pin_pitch;

post  = dupont_preset == 254 ? 0.64
      : dupont_preset == 200 ? 0.50
      : dupont_preset == 127 ? 0.40
      : custom_post;

hole  = post + hole_clearance;

/* Sealing the bottom does not take anything away: the holes, the troughs, the
   plinths and the wire channels all stay. It just puts a slab of floor_solid
   under the troughs, which are the only things that open through the underside.
   The troughs become blind pockets — which is exactly where the pin tails want
   to go — and the case grows by that slab. */
base_t = seal_bottom ? floor_solid : 0;

// With the recess on, the floor is the trough plus the plate that carries the
// holes. The trough is open at the bottom, so the connectors sink into it and
// the wires drop straight out. Sealed or recess-off, it is a plain slab of
// floor_solid — that is the base thickness.
floor_t   = base_t + (terminal_recess ? terminal_len + (trough_w / 2) * tan(trough_roof_angle) + hole_plate_t : floor_solid);
trough_roof_h = (trough_w / 2) * tan(trough_roof_angle);
trough_z  = base_t + (terminal_recess ? terminal_len + trough_roof_h : 0);
plate_z   = trough_z;                             // underside of the hole plate
// what a pin actually has to pass through: the thin plate when the recess is
// on, the whole floor when it is off
plate_t   = terminal_recess ? hole_plate_t : floor_solid;
// The hole has to start below the trough's ridge, not at it: at the apex the
// trough is a knife edge, so a hole stopping there would never break through.
hole_z0   = base_t + (terminal_recess ? terminal_len : 0);
hole_h    = plate_z - hole_z0 + plate_t;

/* How far the funnel actually opens out in the tray's hole plate.

   The funnel is a 45-degree chamfer, so its depth equals its width — and it is
   capped at half the plate's thickness. That cap is not cosmetic: the funnel is
   cut from the top down, so if it is deeper than the plate it breaks out of the
   underside, and the hole's narrowest point stops being `hole` at all. The
   coupon is the plate at its thinnest, so it fails first, which is exactly
   backwards — the coupon exists to report the fit the case will give.

   The angle is not a parameter because it has no manufacturing consequence: the
   funnel faces up, so it never overhangs at any angle. The old lead_angle
   claimed otherwise and defaulted to 65, which made the funnel 1.07mm deep in a
   1.00mm coupon and reported holes about 0.1mm oversize — two whole steps of
   the coupon's own scale. */
lead_d = min(lead_in, plate_t / 2);



// --- Derived dimensions ---------------------------------------------------

span = (pin_count - 1) * pitch;

// screw bosses need corner room across the width the auto size would not
// otherwise leave. Along the length they tuck into the corners beside the
// board, so they cost nothing there.
screw_pad = closure == "screw" ? boss_d : 0;

pcb_l = board_l > 0 ? board_l : span + 2 * board_end_margin;
pcb_w = board_w > 0 ? board_w : row_spacing + 2 * board_side_margin;

// The board sits hard against the inside of the USB end wall, so its socket
// lines up with the opening in that wall. That fixes the USB end, and the far
// end is the board plus the antenna bay — so the length is the board, not the
// header, plus the bay and two walls.
length = length_override > 0 ? length_override
       : 2 * wall + pcb_l + antenna_gap;
width  = width_override  > 0 ? width_override
       : row_spacing + 2 * side_margin + 2 * screw_pad;

inner_l = length - 2 * wall;
inner_w = width  - 2 * wall;
inner_r = max(corner_r - wall, 0.5);

// How deep the cavity has to be: enough for the standoff, the board and
// whatever stands on top of it, and enough that the lid's groove clears the
// openings cut in the walls. The second one usually wins, because the floor
// already carries the sockets high — if you want a shorter case, terminal_len
// is a far bigger lever than this.
opening_top = max(usb_opening ? opening_z + usb_h : 0,
                  end_opening ? opening_z + end_h : 0);
cavity = cavity_h > 0 ? cavity_h
       : max(pcb_standoff + board_t + component_h,
             opening_top + groove_depth + 0.4);

wall_h = floor_t + cavity;

row_a_y = (width - row_spacing) / 2;
row_b_y = (width + row_spacing) / 2;

pcb_x = wall;                                // flush to the USB end wall
pcb_y = (width  - pcb_w) / 2;

// the header is soldered to the board, so it goes where the board goes
x_first = pcb_x + (pcb_l - span) / 2 + pin_x_offset;

// --- PCB rests ------------------------------------------------------------
// Two pads at each end, in the board's own corners, rather than a bar across
// the full width: the header pins already carry and locate the board, so the
// rests only have to stop it rocking. Each pad is trimmed to the room between
// the board's edge and the nearest pin hole, so a rest can never cap a hole.

pad_w   = min(ledge_w, pcb_w / 2);

// Clear the funnels, not just the holes: the lead-in opens out to lead_in past
// the hole on every side, and a pad that clips a funnel rim hangs 0.1mm over
// the void and shows up as a flat overhang.
header_x0 = x_first - hole / 2 - lead_d;
header_x1 = x_first + span + hole / 2 + lead_d;
near_room = header_x0 - pcb_x;
far_room  = (pcb_x + pcb_l) - header_x1;
near_ledge_d = min(ledge_d, max(near_room - 0.2, 0));
far_ledge_d  = min(ledge_d, max(far_room  - 0.2, 0));

// --- Floor relief ---------------------------------------------------------
// Only the strips carrying the troughs need the full floor depth. The rest of
// the floor drops to floor_solid, so each row keeps a raised plinth and the
// slab between them goes away. Nothing here moves floor_t: the plinth top IS
// the old floor top, which is why the case outside is untouched.

relief   = terminal_recess && floor_relief;
plinth_w = trough_w + 2 * plinth_wall;

/* Where the wire channel starts and ends, both measured from the hole's centre.

   The neck holds the pin in its hole; past it the channel opens out to wire_w
   and runs until it is clear through the plinth's side face, which is what
   gives the wire somewhere to go. Stopping inside the plinth would leave a
   pocket the wire could never get out of.

   The channel is cut through the full height of the hole, not sunk from the
   plinth's top. That matters: a groove in the top face would never reach the
   trough, so no wire could get into it from below. Full height, it meets the
   trough void where it crosses the trough's sloping roof. */
neck_w        = slot_w > 0 ? slot_w : hole;
slot_neck_end = hole / 2 + slot_neck;
slot_reach    = slot_depth > 0 ? slot_depth : plinth_w / 2 + 0.6;

/* How far the channel reaches BELOW the hole.

   Without this the channel would start level with the trough's shoulder, and
   its mouth into the trough would be only (trough_w/2 - slot_neck_end) wide —
   0.4mm at the defaults, which no wire fits through. Dropping the channel by a
   wire's width opens a mouth that tall into the trough's straight-sided
   section, so the wire can actually turn the corner and come out.

   Only with the recess on: without a trough there is nothing below the hole to
   open into, and dropping the cut would just breach the underside of the floor. */
channel_drop = terminal_recess ? wire_w : 0;

// the same x extent terminal_troughs() extrudes over, so the plinth and the
// trough it carries cannot drift apart
trough_x0 = x_first - hole / 2 - trough_end_margin;
trough_x1 = x_first + span + hole / 2 + trough_end_margin;

// a sliver of relief left between a plinth end and the interior wall would be
// a slot too narrow to print, so close the gap when it gets that small
plinth_x0 = (trough_x0 - plinth_wall) - wall < 1 ? wall - 0.5
                                                 : trough_x0 - plinth_wall;
plinth_x1 = (length - wall) - (trough_x1 + plinth_wall) < 1 ? length - wall + 0.5
                                                            : trough_x1 + plinth_wall;

// tongue-and-groove, both cut from the same insets so they cannot disagree
groove_a = (wall - groove_w) / 2;      // outer inset
groove_b = groove_a + groove_w;        // inner inset
groove_z = wall_h - groove_depth;
tongue_h = groove_depth - joint_clearance;

/* Ball latches. The ball is a half round, so its radius is also how far it
   stands proud of the rib: clearing the joint clearance first, then biting
   latch_grip into the slot wall. It sits on the rib's inner face, so the
   dimple opens into the cavity rather than showing on the outside. */
latch_r = joint_clearance + latch_grip;
latch_y = groove_b - joint_clearance;      // the rib's inner face
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
pin_free  = pcb_standoff + hole_plate_t;
pin_engage = pin_length - pin_free;   // pin left inside the trough to grip


// --- Sanity checks --------------------------------------------------------

assert(x_first - hole / 2 >= wall && x_first + span + hole / 2 <= length - wall,
       str("Pin header does not fit. It spans ", x_first - hole / 2, " to ",
           x_first + span + hole / 2, " but the floor inside the walls runs ",
           wall, " to ", length - wall,
           ". Raise board_end_margin, lower pin_count, or set length_override."));

assert(row_a_y - hole / 2 >= wall,
       str("Pin holes reach into the side wall: row centre ", row_a_y,
           " with a ", hole, " hole reaches ", row_a_y - hole / 2,
           " but the wall ends at ", wall, ". Raise side_margin."));

// the channels sit one per pin, so anything approaching the pitch merges them
// into a single long slot and takes the plate's inboard support with it
assert(!wire_channels || wire_w + 0.8 <= pitch,
       str("wire_w ", wire_w, " leaves only ", pitch - wire_w,
           " mm of rib between one channel and the next at a ", pitch,
           " pitch. Below 0.8 the channels merge and the hole plate loses the ",
           "shoulder holding it up. Lower wire_w."));

assert(2 * groove_b < min(inner_l, inner_w),
       str("The tongue-and-groove joint meets itself: 2 x ", groove_b,
           " exceeds the smaller interior dimension ", min(inner_l, inner_w),
           ". Lower groove_w or raise the case size."));

assert(groove_depth < wall_h - floor_t,
       str("groove_depth ", groove_depth, " is deeper than the wall above the floor (",
           wall_h - floor_t, "). Lower it or raise cavity_h."));

// the board is flush to the USB wall by design, so there is no clearance to
// check at that end — only across the width, and in the bay past the far edge
assert(pcb_l <= inner_l && pcb_w + 2 * board_clearance <= inner_w,
       str("The PCB does not fit the interior: board is ", pcb_l, " x ", pcb_w,
           ", interior is ", inner_l, " x ", inner_w,
           ". Raise antenna_gap or side_margin, or lower the board size."));

assert(!usb_opening || opening_z + usb_h + groove_depth <= cavity,
       str("The USB opening runs up into the lid's groove: it tops out ",
           opening_z + usb_h, " above the floor, but the groove starts at ",
           cavity - groove_depth, ". Raise cavity_h, or lower usb_h/opening_z."));

assert(!end_opening || opening_z + end_h + groove_depth <= cavity,
       str("The far end opening runs up into the lid's groove: it tops out ",
           opening_z + end_h, " above the floor, but the groove starts at ",
           cavity - groove_depth, ". Raise cavity_h, or lower end_h/opening_z."));

assert(!usb_opening || usb_w <= inner_w,
       str("usb_w ", usb_w, " exceeds the interior width ", inner_w, "."));

assert(!end_opening || end_w <= inner_w,
       str("end_w ", end_w, " exceeds the interior width ", inner_w, "."));

assert(!terminal_recess || trough_w > hole,
       str("trough_w ", trough_w, " is narrower than the pin hole ", hole,
           ". Widen the trough."));

assert(!terminal_recess || row_a_y - trough_w / 2 >= wall,
       str("The terminal troughs cut into the side wall: they reach ",
           row_a_y - trough_w / 2, " but the wall ends at ", wall,
           ". Raise side_margin or narrow trough_w."));

assert(!terminal_recess || 2 * (row_a_y + trough_w / 2) < width ||
       row_b_y - trough_w / 2 > row_a_y + trough_w / 2,
       str("The two terminal troughs overlap in the middle. Raise row_spacing ",
           "or narrow trough_w."));

assert(!relief || floor_solid < floor_t - 0.4,
       str("floor_relief has nothing to remove: floor_solid ", floor_solid,
           " is not thinner than the ", floor_t, " floor the troughs need. ",
           "Lower floor_solid, or switch floor_relief off."));

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

if (wire_channels && slot_neck_end >= slot_reach)
    echo(str("WARNING: slot_neck (", slot_neck, ") uses up the whole channel, ",
             "so you get a plain ", slot_w, " mm slot and no wire channel. ",
             "Lower slot_neck or raise slot_depth."));

if (wire_channels && slot_reach > slot_neck_end && !relief)
    echo(str("WARNING: with floor_relief off there is no plinth for the wire ",
             "channel to break out of, so it dead-ends in the floor. The wire ",
             "has to climb out of the top instead, with only pcb_standoff (",
             pcb_standoff, " mm) before it fouls the board."));

// the rests are trimmed to fit rather than asserted against, but if there is
// no room for either of them the board has nothing but the pins holding it
if (pcb_standoff > 0 && ledge_d > 0 && near_ledge_d == 0 && far_ledge_d == 0)
    echo(str("WARNING: no room for a PCB rest at either end — the pin holes ",
             "reach the board's edges. The header pins are carrying the board ",
             "on their own. Raise board_end_margin to make room."));

echo(str("Case ", length, " x ", width, " x ", wall_h + lid_t,
         " mm  |  header ", pin_count, " x2 @ ", pitch,
         "  |  ", pin_engage, " mm of pin inside the trough",
         seal_bottom ? str("  |  base SEALED, ", base_t, " mm under the troughs")
                     : "",
         "  |  antenna bay ", antenna_gap, " mm",
         "  |  rests ", near_ledge_d, "/", far_ledge_d, " x ", pad_w,
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

/* An axis-aligned square frustum, centred on x/y. A 4-sided cylinder turned
   45 degrees is a square; r = side / sqrt(2) puts the corners in the right place. */
module sq_frustum(s1, s2, h) {
    rotate([0, 0, 45])
        cylinder(h = h, r1 = s1 / sqrt(2), r2 = s2 / sqrt(2), $fn = 4);
}

/* A closed ring following the case outline, between two insets from the outer
   face. Both the groove and the tongue come from this, so they cannot drift. */
module outline_ring(a, b, h) {
    translate([a, a, 0]) difference() {
        rounded_box(length - 2 * a, width - 2 * a, h, max(corner_r - a, 0.3));
        translate([b - a, b - a, -0.1])
            rounded_box(length - 2 * b, width - 2 * b, h + 0.2, max(corner_r - b, 0.3));
    }
}


// --- Pin holes ------------------------------------------------------------

/* One clearance hole through a plate `t` thick, with the lead-in funnel on the
   upper face. The tray, the coupon and the fit template all cut their holes
   with this, so what the two test prints report is what the case will give.

   `mat` is the thickness of the material the funnel must not break out of,
   when that differs from the height of the cut — in the tray the cut spans the
   trough as well, so only the hole plate is really there to be chamfered.
   Defaults to `t`, which is right for a plate cut straight through. */
module plate_hole(t, size, mat = 0) {
    d = min(lead_in, (mat > 0 ? mat : t) / 2);
    translate([0, 0, -0.1]) sq_prism(size, t + 0.2);
    if (d > 0)
        translate([0, 0, t - d])
            sq_frustum(size, size + 2 * d, d + 0.1);
}

/* One row of header holes through the hole plate: a square clearance hole, a
   funnel on the upper side so a descending pin finds it, and the wire channel.
   The funnel faces up on purpose — it guides the pin, and an upward cone has no
   overhang when the tray is printed floor-down.

   The channel is a keyhole. The neck beside the hole stays narrower than the
   pin post, so the pin cannot walk out of its hole sideways; past the neck it
   opens to wire_w and runs out through the plinth's side. A wire coming off a
   pin therefore leaves at plate level and drops into the relieved floor, rather
   than climbing over the plinth top — where it would have only pcb_standoff of
   room before it fouled the board. */
module pin_row(cy) {
    dir = cy < width / 2 ? 1 : -1;      // always toward the middle of the box
    for (i = [0 : pin_count - 1]) {
        cx = x_first + i * pitch;
        translate([cx, cy, hole_z0]) {
            plate_hole(hole_h, hole, plate_t);

            if (wire_channels && slot_reach > 0) {
                neck = min(slot_neck_end, slot_reach);
                translate([-neck_w / 2, dir > 0 ? 0 : -neck, -0.1])
                    cube([neck_w, neck, hole_h + 0.2]);

                if (slot_reach > slot_neck_end)
                    translate([-wire_w / 2,
                               dir > 0 ? slot_neck_end : -slot_reach,
                               -0.1 - channel_drop])
                        cube([wire_w, slot_reach - slot_neck_end,
                              hole_h + 0.2 + channel_drop]);
            }
        }
    }
}

/* A trough under each pin row, open at the underside of the case. The Dupont
   connectors push up into it so they finish flush with the floor rather than
   hanging below, and the wires leave straight down out of the open bottom.

   Two narrow troughs rather than one big recessed floor: each only has to
   bridge `trough_w` when printed, where a full-width recess would leave the
   whole floor hanging in the air and need support. */
module terminal_troughs() {
    if (terminal_recess) {
        // straight sides for the connector, then a peaked roof so nothing
        // inside the slot is ever an unsupported span
        profile = [[0, 0],
                   [trough_w, 0],
                   [trough_w, terminal_len],
                   [trough_w / 2, terminal_len + trough_roof_h],
                   [0, terminal_len]];
        // Open at the bottom normally, so the connectors go in and the wires
        // come out. Sealed, the cut stops at base_t and the slab below closes
        // it into a blind pocket — the floor of that pocket faces up, so it
        // still prints without support.
        for (cy = [row_a_y, row_b_y])
            translate([x_first - hole / 2 - trough_end_margin,
                       cy - trough_w / 2, seal_bottom ? base_t : -0.1])
                rotate([90, 0, 90])
                    linear_extrude(height = span + hole + 2 * trough_end_margin)
                        polygon(profile);
    }
}

/* The floor only has to be floor_t thick where a trough runs through it.
   Everywhere else it drops to floor_solid, which leaves a raised plinth along
   each pin row, only as wide as the connector needs.

   Cut downward out of the cavity, so every face it makes is either vertical or
   upward-facing: no new overhang, and the tray still prints without support.
   What it deliberately spares is anything that would otherwise be left standing
   on air — a pillar under each PCB rest, and one under each screw boss. */
module floor_relief_cut() {
    if (relief)
        difference() {
            translate([wall, wall, floor_solid])
                rounded_box(inner_l, inner_w, floor_t - floor_solid + 0.1, inner_r);

            // Deliberately taller than the cut it is subtracted from. If the
            // pillar's top lands exactly on the cut's top the two faces are
            // coplanar, and at some floor_solid values that leaves the pad
            // hanging 0.1mm over the void — a flat overhang that only shows up
            // at particular numbers. Overshooting past the cut cannot leave a
            // stub, because nothing is being cut up there to begin with.
            if (pcb_standoff > 0 && ledge_d > 0)
                rest_pads(floor_solid - 0.1, floor_t - floor_solid + 0.4);

            for (cy = [row_a_y, row_b_y])
                translate([plinth_x0, cy - plinth_w / 2, floor_solid - 0.1])
                    cube([plinth_x1 - plinth_x0, plinth_w, floor_t]);

            if (closure == "screw")
                for (bx = [wall + boss_d / 2, length - wall - boss_d / 2])
                    for (by = [wall + boss_d / 2, width - wall - boss_d / 2])
                        translate([bx, by, floor_solid - 0.1])
                            cylinder(d = boss_d, h = floor_t);
        }
}


// --- Tray -----------------------------------------------------------------

module openings() {
    if (usb_opening)
        translate([-0.1, (width - usb_w) / 2, floor_t + opening_z])
            cube([wall + 0.2, usb_w, usb_h]);
    if (end_opening)
        translate([length - wall - 0.1, (width - end_w) / 2, floor_t + opening_z])
            cube([wall + 0.2, end_w, end_h]);
}

/* Where the board rests: two pads at each end, in the board's own corners.
   The header pins carry and locate the board, so the pads only have to stop it
   rocking — a bar across the full width would be plastic for nothing, and with
   the board flush against the USB wall there is no room for one there anyway.

   Called twice with different z: once to build the pads, and once by the floor
   relief to keep solid ground under them, so the two cannot disagree. */
module rest_pads(z0, h) {
    for (px = [[pcb_x, near_ledge_d], [pcb_x + pcb_l - far_ledge_d, far_ledge_d]])
        if (px[1] > 0)
            for (py = [pcb_y, pcb_y + pcb_w - pad_w])
                translate([px[0], py, z0]) cube([px[1], pad_w, h]);
}

module pcb_ledges() {
    if (pcb_standoff > 0 && ledge_d > 0)
        rest_pads(floor_t, pcb_standoff);
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

                // groove for the lid tongue
                translate([0, 0, groove_z])
                    outline_ring(groove_a, groove_b, groove_depth + 0.1);

                openings();
            }

            pcb_ledges();
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
                outline_ring(groove_a + joint_clearance,
                             groove_b - joint_clearance, tongue_h);
            latch_balls(latch_r, latch_z);
        }

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


// --- Fit coupon -----------------------------------------------------------

/* Five holes, one per clearance offset, so a 2-minute print tells you which
   fit actually grips before you print a whole case. The engraved digit maps
   to the offsets listed in the README. */
coupon_offsets = [-0.10, -0.05, 0, 0.05, 0.10];

// the coupon reproduces the hole plate, which is what a pin actually passes
// through, so the fit it reports is the fit the case will give
coupon_t = plate_t;

module coupon() {
    n     = len(coupon_offsets);
    step  = max(hole + 2 * lead_in + 2.5, 7);
    pad   = 3;
    cw    = n * step + 2 * pad;
    cd    = 15;
    hy    = cd - 5;

    difference() {
        rounded_box(cw, cd, coupon_t, 2);
        for (i = [0 : n - 1]) {
            cx = pad + step * (i + 0.5);
            translate([cx, hy, 0])
                plate_hole(coupon_t, hole + coupon_offsets[i]);
            translate([cx, 4, coupon_t - 0.5])
                linear_extrude(0.6)
                    text(str(i + 1), size = 4, halign = "center",
                         valign = "center", $fn = 32);
        }
    }
}


// --- Fit template ---------------------------------------------------------

/* A shallow stand-in for the tray: same footprint, same interior outline, same
   pin holes in the same places, same rests, same screw bosses — but a few
   millimetres tall instead of twenty.

   Drop your actual board into it and a short print answers the three things
   that would otherwise only surface once the real tray is done: whether the
   board fits between the walls, whether the header lines up with the holes,
   and whether the module has its antenna bay. It is a geometry check — the
   coupon is still the one that tells you how the pins grip. */
module template() {
    difference() {
        union() {
            difference() {
                rounded_box(length, width, template_t + template_rim, corner_r);

                translate([wall, wall, template_t])
                    rounded_box(inner_l, inner_w, template_rim + 0.1, inner_r);

                // notch the rim so you can see the socket line up
                if (usb_opening)
                    translate([-0.1, (width - usb_w) / 2, template_t])
                        cube([wall + 0.2, usb_w, template_rim + 0.1]);
            }

            if (pcb_standoff > 0 && ledge_d > 0)
                rest_pads(template_t, pcb_standoff);

            // stubs, so you can see whether the bosses crowd the board
            if (closure == "screw")
                for (bx = [wall + boss_d / 2, length - wall - boss_d / 2])
                    for (by = [wall + boss_d / 2, width - wall - boss_d / 2])
                        translate([bx, by, template_t])
                            cylinder(d = boss_d, h = template_rim);
        }

        // the real holes, in the real places
        for (cy = [row_a_y, row_b_y])
            for (i = [0 : pin_count - 1])
                translate([x_first + i * pitch, cy, 0]) plate_hole(template_t, hole);

        // a scored line at the board's far edge — everything past it is bay
        if (antenna_gap > 0)
            translate([pcb_x + pcb_l + 0.1, wall, template_t - 0.4])
                cube([0.4, inner_w, 0.5]);
    }
}


// --- Render ---------------------------------------------------------------

if (part == "tray")          tray();
else if (part == "lid")      lid();
else if (part == "coupon")   coupon();
else if (part == "template") template();
else if (part == "all") {
    tray();
    translate([0, width + layout_gap, 0]) lid();
    translate([0, 2 * (width + layout_gap), 0]) coupon();
}
else if (part == "assembled") {
    tray();
    translate([0, 0, wall_h]) lid_assembled();
}
else assert(false, str("Unknown part \"", part,
                       "\". Use tray, lid, template, coupon, all or assembled."));
