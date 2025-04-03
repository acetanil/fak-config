let { tap, hold, td, combo, macro, ..} = import "fak/keycode.ncl" in

# add number of combos to physical keys for later use
let virtual_key_count = 4 in
let key_count = 34 + virtual_key_count in

# convenience aliases
# taps
let kc = tap.reg.kc in # normal keys
let ks = tap.reg.ks in # shifted keys
let md = tap.reg.mod in # combinable mods (ex.: md.lsft & kc.N1 will result in a shifted One ("!" on US layout))
# mod-hold
let mdh = hold.reg.mod in
# layer control
let lt = hold.reg.layer in
# boot, reset, etc
let fak = tap.custom.fak in
# media and mouse control
let media = tap.custom.media in
let mouse = tap.custom.mouse in
# unmapped / transparent taps and holds (transparent hold can make hrm work on any layer!)
let tx = tap.none in
let tt = tap.trans in
let hx = hold.none in
let ht = hold.trans in


# thumb keys defined here
# this function maps the numbers 0, 1, 2, 3 to the below behaviors
let thumb = fun thumb_idx =>
  let thumb_behavior = {
    timeout_ms = 150,
    timeout_decision = 'hold,
    key_interrupts = std.array.replicate key_count { decision = 'hold, trigger_on = 'release },
  } in
  [
    mdh.lgui & kc.TAB & hold.reg.behavior thumb_behavior, # thumb 0
    kc.SPC   & lt 1   & hold.reg.behavior thumb_behavior, # thumb 1
    kc.SPC   & lt 2   & hold.reg.behavior thumb_behavior, # thumb 2
    mdh.rgui & kc.DEL & hold.reg.behavior thumb_behavior, # thumb 3
  ]
  |> std.array.at thumb_idx # pick out the appropriate entry from the above list
in

let mk = {
  Z     = mdh.lsft & kc.Z & hold.reg.behavior {  },
  X     = mdh.lctl & kc.X & hold.reg.behavior {  },
  C     = mdh.lalt & kc.C & hold.reg.behavior {  },
  M     = mdh.ralt & kc.M & hold.reg.behavior {  },
  COMM  = mdh.rctl & kc.COMM & hold.reg.behavior {  },
  DOT   = mdh.rsft & kc.DOT & hold.reg.behavior {  },
  ENT   = kc.ENT & lt 3 & hold.reg.behavior { timeout_ms = 150, timeout_decision = 'hold, key_interrupts = std.array.replicate key_count { decision = 'hold, trigger_on = 'release }, },
} in

### Keymap itself! ###
{
  # combos and other virtual keys are defined here
  # (careful, changes here require changes above! marked by "#1")
  virtual_keys = [
    combo.make 50 [0,  29],
    combo.make 50 [0,  1 ],
    combo.make 50 [8,  9 ],
    combo.make 50 [10, 11],
  ],
  layers = [
    # ALPHAS
    [
      kc.Q,    kc.W,    kc.E,    kc.R,    kc.T,        kc.Y,    kc.U,    kc.I,    kc.O,     kc.P,
      kc.A,    kc.S,    kc.D,    kc.F,    kc.G,        kc.H,    kc.J,    kc.K,    kc.L,     mk.ENT,
      mk.Z,    mk.X,    mk.C,    kc.V,    kc.B,        kc.B,    kc.N,    mk.M,    mk.COMM,  mk.DOT, 
                                 # thumb keys are defined above in the function "thumb"
                                 thumb 0, thumb 1,     thumb 2, thumb 3,
      # combos:
      fak.BOOT, kc.ESC, kc.BSPC, kc.TAB, 
    ],
    # NUM, transparent holds makes hrm work on the left hand here
    [
      kc.N1,    kc.N2,    kc.N3,    kc.N4,    kc.N5,    kc.N6,    kc.N7,    kc.N8,    kc.N9,    kc.N0,
      kc.TAB,   kc.GRV,   kc.MINUS, kc.EQL,   tx & hx,  kc.SCLN,  kc.QUOT,  kc.LBRC,  kc.RBRC,  kc.BSLS,
      tx & ht,  tx & ht,  tx & ht,  tx & hx,  tx & hx,  kc.SLSH,  tx & hx,  tx & ht,  tx & ht,  tx & ht,
                                    tt & ht,  tt & ht,  tt & ht,  tt & ht,
      # combos (need to add these to every layer)
      tx & hx, tt & hx, tt & hx, tt & hx,
    ],
    # SYM
    [
      kc.F1,   kc.F2,   kc.F3,   kc.F4,   kc.F5,   kc.F6,   kc.F7,   kc.F8,   kc.F9,   kc.F10,
      kc.F11,  kc.F12,  tx & hx, tx & hx, tx & hx, tx & hx, tx & hx, tx & hx, tx & hx, tx & hx,
      tx & hx, tx & hx, tx & hx, tx & hx, tx & hx, tx & hx, tx & hx, tx & hx, tx & hx, tx & hx,
                                 tt & ht, tt & ht, tt & ht, tt & ht,
      # combos (need to add these to every layer)
      tx & hx, tx & hx, tx & hx, tx & hx,
    ],
    # NAV
    [
      tx & hx,      tx & hx,        tx & hx,        tx & hx,   tx & hx,     tx & hx,    tx & hx,    kc.UP,      tx & hx,   tx & hx,
      kc.INS,       kc.HOME,        kc.PGUP,        tx & hx,   tx & hx,     tx & hx,    kc.LEFT,    kc.RGHT,    tx & hx,   tx & ht,
      kc.DEL & ht,  kc.END & ht,    kc.PGDN & ht,   tx & hx,   tx & hx,     tx & hx,    kc.DOWN,    tx & ht,    tx & ht,   tx & ht,
                                    tt & ht,        tt & ht,   tt & ht,     tt & ht,
      # combos (need to add these to every layer)
      tx & hx, tx & hx, tx & hx, tx & hx,
    ],
  ]
}
