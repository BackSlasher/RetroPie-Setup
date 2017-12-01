#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="moonlight"
rp_module_desc="Standalone Steam Controller Driver"
rp_module_desc="See source at https://github.com/irtimmer/moonlight-embedded"
rp_module_licence="GNU3 https://raw.githubusercontent.com/irtimmer/moonlight-embedded/master/LICENSE"
rp_module_section="exp"
rp_module_flags="!x11" # TODO NITZ why this? copied from limelight

# Based on https://github.com/TechWizTime/moonlight-retropie/blob/master/moonlight.sh

function depends_moonlight() {

    # Set source
    # XXX NITZ Assuming Debian
    local DEB_CODENAME
    DEB_CODENAME="$(awk -F"[)(]+" '/VERSION=/ {print $2}' /etc/os-release)"
    echo "deb http://archive.itimmer.nl/raspbian/moonlight ${DEB_CODENAME} main" > /etc/apt/sources.list.d/moonlight.list
    
    getDepends 'moonlight-express'
}

function sources_moonlight() {
  # NITZ Empty
  # TODO get some art
}

function install_moonlight() {
  # NITZ Empty
}

## @fn createscript_moonlight()
## @param filename relative to moonlight dir
## @param contents
## @brief Creates a runnable script in the moonlight dir
function createscript_moonlight() {
  local name
  local content
  name="$1"
  content="$2"

  name="$romdir/moonlight/${name}.sh"
  echo >"$name" "#!/bin/bash
$content" &&
  chmod +x "$name"
}

function configure_moonlight() {
  # TODO pair

  # Create romdir moonlight
  mkRomDir "moonlight"

  # Add System to es_system.cfg
  addEmulator 1 "$md_id" "moonlight" "%ROM%"
  addSystem "moonlight" "Moonlight streaming" ".sh"

  [[ "$md_mode" == "remove" ]] && return

  # Scripts
  createscript_moonlight 'moonlightconfig' "sudo $scriptdir/retropie_packages.sh moonlight configure"
  createscript_moonlight 'stream' "moonlight stream"
  createscript_moonlight 'stream' "moonlight quit"
  # TODO more interesting ones: quit, pair, scan (to create list of games)
}

function gui_steamcontroller() {
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local options=(
        1 "Pair"
        2 "List"
        3 "Quit"
    )
    while true; do
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        if [[ -n "$choice" ]]; then
            case "$choice" in
                1)
                    moonlight pair
                    ;;
                2)
                    moonlight list
                    ;;
                3)
                    moonlight quit
                    ;;
            esac
        else
            break
        fi
    done
}
