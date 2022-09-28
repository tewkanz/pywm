{pkgs ? import <nixpkgs> {}}:
with pkgs;
  python3Packages.buildPythonPackage rec {
    pname = "pywm";
    name = "${pname}-dev2";

    srcs = [
      ./.
      (fetchgit {
        url = "https://gitlab.freedesktop.org/wlroots/wlroots";
        rev = "e279266f714c7122e9ad97d56d047313f78cfdbe";
        sha256 = "8RldE5JsQILUZ2DF1nB6AEz1pZecgnURIjRXK/dCAdI=";
        fetchSubmodules = true;
      })
    ];

    setSourceRoot = ''
      for i in ./*; do
        if [ -f "$i/wlroots.syms" ]; then
          wlrootsDir=$i
        fi
        if [ -f "$i/pywm/pywm.py" ]; then
          sourceRoot=$i
        fi
      done
    '';
    preConfigure = ''
      echo "--- Pre-configure --------------"
      echo "  wlrootsDir=$wlrootsDir"
      echo "  sourceRoot=$sourceRoot"
      echo "--- ls -------------------------"
      ls -al
      echo "--- ls ../wlrootsDir -----------"
      ls -al ../$wlrootsDir
      rm -rf ./subprojects/wlroots 2> /dev/null
      cp -r ../$wlrootsDir ./subprojects/wlroots
      rm -rf ./build
      echo "--- ls ./subprojects/wlroots ---"
      ls -al ./subprojects/wlroots/
      echo "--------------------------------"
    '';
    mesonFlags = ["-Dxwayland=enabled"];

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      meson
      ninja
      pkg-config
      wayland-scanner
      glslang
    ];

    preBuild = "cd ..";

    buildInputs = with pkgs;
      [
        libGL
        wayland
        wayland-protocols
        libinput
        libxkbcommon
        pixman
        vulkan-loader
        mesa
        seatd
        libcap
        libdrm

        libpng
        ffmpeg
        libcap

        xorg.xcbutilwm
        xorg.xcbutilrenderutil
        xorg.xcbutilerrors
        xorg.xcbutilimage
        xorg.libX11
      ]
      ++ [
        xwayland
      ];

    propagatedBuildInputs = with pkgs.python3Packages; [
      imageio
      numpy
      pycairo
      evdev
    ];
  }
