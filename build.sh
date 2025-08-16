#! /usr/bin/env bash

set -euo pipefail

ME=$(readlink -e -- "$BASH_SOURCE")
HERE=$(dirname -- "$ME")

{
    cd "$HERE"

    compiler='./sourcemod/addons/sourcemod/scripting/spcomp'

    if [ ! -f "$compiler" ]; then
        echo "The compiler needs to be present at the following location: $compiler"
        echo 'You can download it from https://www.sourcemod.net/downloads.php'
        exit 1
    fi

    # mark compiler as executable
    chmod +x "$compiler"

    if [ -d "/etc/nix" ]; then
        nixos_fixer="steam-run"
    else
        nixos_fixer=""
    fi

    # compile ACS
    "$nixos_fixer" "$compiler" ./scripting/campaign_switcher.sp -v:0

    cd -
}

echo 'you can now copy the compiled ".smx" file into "left4dead2/addons/sourcemod/plugins"'
