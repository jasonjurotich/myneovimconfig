env:
  TERM: alacritty
live_config_reload: true
background_opacity: 0.5

window:
  dimensions:
    columns: 0
    lines: 0
  padding:
    x: 2
    y: 2
  dynamic_padding: false
  startup_mode: Fullscreen
  # startup_mode: Windowed
  decorations: none
  
scrolling:
  history: 10000
  multiplier: 3
  auto_scroll: false
  
tabspaces: 2
draw_bold_text_with_bright_colors: true

selection:
  semantic_escape_chars: ",│`|:\"' ()[]{}<>\t"
  save_to_clipboard: true
  
cursor:
  style: Block  
  unfocused_hollow: true

debug:
  render_timer: false
  persistent_logging: false
  log_level: Warn
  print_events: false
  ref_test: false
  
font:
  normal:
    family: "Hack"
    style: Regular
  bold:
    family: "Hack"
    style: Bold
  italic:
    family: "Hack"
    style: Italic
  bold_italic:
    family: "Hack"
    style: Italic
  size: 22.0
  offset:
    x: 0
    y: 0
  glyph_offset:
    x: 0
    y: 1
  use_thin_strokes: true
  
colors:
  primary:
    background: '0x2a2e38'
    foreground: '0xF0FDFF'
    # dim_foreground: '0x9a9a9a'
    # bright_foreground: '0xffffff'
  normal:
    black:   '0x2a2e38'
    red:     '0xd08785'
    green:   '0x6f98b3'
    yellow:  '0xfdf8ce'
    blue:    '0xa6b8cc'
    magenta: '0xfcdbd9'
    cyan:    '0xffd17f'
    white:   '0xf0fdff'
  bright:
    black:   '0x71798a'
    red:     '0xff3334'
    green:   '0x9ec400'
    yellow:  '0xe7c547'
    blue:    '0x7aa6da'
    magenta: '0xb77ee0'
    cyan:    '0x54ced6'
    white:   '0xffffff'
  dim:
    black:   '0x333333'
    red:     '0xf2777a'
    green:   '0x99cc99'
    yellow:  '0xffcc66'
    blue:    '0x6699cc'
    magenta: '0xcc99cc'
    cyan:    '0x66cccc'
    white:   '0xdddddd'
  cursor:
    text: '0x2a2e38'
    # cursor: '0x71798a'
    # cursor: '0xF0FDFF'
    # cursor: '0xe6d3c6'
    cursor: '0xffd17f'
  selection:
    text: '0x2a2e38'
    cursor: '0xF0FDFF'  
  
mouse:
  double_click: { threshold: 300 }
  triple_click: { threshold: 300 }
  hide_when_typing: false
  url:
    launcher: open
  
  
  
  
key_bindings:
  - { key: LBracket, mods: Command, chars: "\x5c\x70" }
  - { key: RBracket, mods: Command, chars: "\x5c\x6e" }
  - { key: Key6, mods: Control, chars: "\x1e" }
  - { key: N,        mods: Command, action: SpawnNewInstance            }
  - { key: V,        mods: Command, action: Paste                        }
  - { key: C,        mods: Command, action: Copy                         }
  - { key: Paste,                   action: Paste                        }
  - { key: Copy,                    action: Copy                         }
  - { key: H,        mods: Command, action: Hide                         }
  - { key: Q,        mods: Command, action: Quit                         }
  - { key: W,        mods: Command, action: Quit                         }
  - { key: Home,                    chars: "\x1bOH",   mode: AppCursor   }
  - { key: Home,                    chars: "\x1b[H",   mode: ~AppCursor  }
  - { key: End,                     chars: "\x1bOF",   mode: AppCursor   }
  - { key: End,                     chars: "\x1b[F",   mode: ~AppCursor  }
  - { key: Key0,     mods: Command, action: ResetFontSize                }
  - { key: Equals,   mods: Command, action: IncreaseFontSize             }
  - { key: Minus,    mods: Command, action: DecreaseFontSize             }  
