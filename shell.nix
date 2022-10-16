{ pkgs ? import <nixpkgs> {} }:
let
  python-with-my-packages = pkgs.python3.withPackages (ps: with ps; [
      imageio
      numpy
      pycairo
      evdev
      matplotlib

      python-lsp-server
      (pylsp-mypy.overrideAttrs (old: { pytestCheckPhase = "true"; }))
      mypy
  ]);
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
      meson
      ninja
      pkg-config
      wayland-scanner
      glslang
  ];

  buildInputs = with pkgs; [
    libGL
    wayland
    wayland-protocols
    libinput
    libxkbcommon
    pixman
    seatd
    vulkan-loader
    mesa

    libpng
    ffmpeg
    libcap
    python-with-my-packages

    xorg.xcbutilwm
    xorg.xcbutilrenderutil
    xorg.xcbutilerrors
    xorg.xcbutilimage
    xorg.libX11
    xwayland
  ];
}
