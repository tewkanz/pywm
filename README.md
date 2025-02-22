# pywm - backend for [newm](https://github.com/jbuchermn/newm)

pywm is an abstraction layer for [newm](https://github.com/jbuchermn/newm) encapsulating all c code.

Basically this is a very tiny compositor built on top of [wlroots](https://github.com/swaywm/wlroots), making all the assumptions that wlroots does not. On the Python side pywm exposes Wayland clients (XDG and XWayland) as so-called views and passes along all input. This way, handling the positioning of views, animating their movement, ... based on keystrokes or touchpad inputs (i.e. the logical, not performance-critical part of any compositor) is possible Python-side, whereas rendering and all other performance-critical aspects are handled by c code.

Check the Python class `PyWM` and c struct `wm_server` for a start, as well as newms `Layout`. 

See also [pywm-fullscreen](https://github.com/jbuchermn/pywm-fullscreen) for a trivial implementation opening one application in fullscreen.

## Attention

v0.3 with a better renderer implementation supporting blur has been merged into master. There are still some bugs around but I consider it an alpha stage.

## Installing

If you install [newm](https://github.com/jbuchermn/newm) via the AUR, pywm is installed automatically.

### Prerequisites

Prerequisites for PyWM, apart from Python, are given by [wlroots](https://github.com/swaywm/wlroots):

* python and pip
* gcc, meson and ninja
* pkg-config
* wayland
* wayland-protocols
* xorg-xwayland
* EGL
* GLESv2
* libdrm
* GBM
* libinput
* xkbcommon
* udev
* pixman
* libseat

### Install

Compilation is handled by meson and started automatically via pip (you need to install prerequisites first):

```
pip3 install git+https://github.com/jbuchermn/pywm
```

In case of issues, clone the repo and execute `meson build && ninja -C build` in order to debug.

### Configuration

Configuration is handled via key-value pairs given to the `PyWM` contructor:

| Key                             | Default    | Description                                                                                             |
|---------------------------------|------------|---------------------------------------------------------------------------------------------------------|
| `enable_xwayland`               | `False`    | Boolean: Start `XWayland`                                                                               |
| `xkb_model`                     |            | String: Keyboard model (`xkb`)                                                                          |
| `xkb_layout`                    |            | String: Keyboard layout (`xkb`)                                                                         |
| `xkb_variant`                   |            | String: Keyboard variant (`xkb`)                                                                        |
| `xkb_options`                   |            | String: Keyboard options (`xkb`)                                                                        |
| `outputs`                       |            | List of dicts: Output configuration (see next lines)                                                    |
| `output.name`                   | `""`       | String: Name of output to attach config to actual output                                                |
| `output.scale`                  | `1.0`      | Number: HiDPI scale of output                                                                           |
| `output.width`                  | `0`        | Integer: Output width (or zero to use preferred)                                                        |
| `output.height`                 | `0`        | Integer: Output height (or zero to use preferred)                                                       |
| `output.mHz`                    | `0`        | Integer: Output refresh rate in milli Hertz (or zero to use preferred)                                  |
| `output.pos_x`                  | `None`     | Integer: Output position x in layout (or None to be placed automatically)                               |
| `output.pos_y`                  | `None`     | Integer: Output position y in layout (or None to be placed automatically)                               |
| `xcursor_theme`                 |            | String: `XCursor` theme (if not set, read from; if set, exported to `XCURSOR_THEME`)                    |
| `xcursor_size`                  | `24`       | Integer: `XCursor` size  (if not set, read from; if set, exported to `XCURSOR_SIZE`)                    |
| `tap_to_click`                  | `True`     | Boolean: On tocuhpads use tap for click enter                                                           |
| `natural_scroll`                | `True`     | Boolean: On touchpads use natural scrolling enter                                                       |
| `focus_follows_mouse`           | `True`     | Boolean: `Focus` window upon mouse enter                                                                |
| `contstrain_popups_to_toplevel` | `False`    | Boolean: Try to keep popups contrained within their window                                              |
| `encourage_csd`                 | `True`     | Boolean: Encourage clients to show client-side-decorations (see `wlr_server_decoration_manager`)        |
| `debug`                         | `False`    | Boolean: Loglevel debug plus output debug information to stdout on every F1 press                       |
| `texture_shaders`               | `basic`    | String: Shaders to use for texture rendering (see `src/wm/shaders/texture`)                             |
| `renderer_mode`                 | `pywm`     | String: Renderer mode, `pywm` (enable pywm renderer, and therefore blur), `wlr` (disable pywm renderer) |


### Troubleshooting

#### seatd

Be aware that current wlroots requires `seatd` under certain circumstances. Example systemd service (be sure to place your user in group `_seatd`):

```
[Unit]
Description=Seat management daemon
Documentation=man:seatd(1)

[Service]
Type=simple
ExecStart=seatd -g _seatd
Restart=always
RestartSec=1

[Install]
WantedBy=multi-user.target
```
