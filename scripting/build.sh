#! /usr/bin/env bash

set -euo pipefail

ME=$(readlink -e -- "$BASH_SOURCE")
HERE=$(dirname -- "$ME")

# how to get the compiler:
# download a build from https://www.sourcemod.net/downloads.php
# unarchive to `local-sourcemod` in the parent folder

{
    cd "$HERE"

    # compile ACS
    ./../sourcemod/addons/sourcemod/scripting/spcomp ./campaign_switcher.sp -v:0

    cd -
}

echo 'you can now copy the compiled ".smx" file into "left4dead2/addons/sourcemod/plugins"'
