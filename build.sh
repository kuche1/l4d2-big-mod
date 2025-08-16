#! /usr/bin/env bash

set -euo pipefail

ME=$(readlink -e -- "$BASH_SOURCE")
HERE=$(dirname -- "$ME")

COMPILER="$HERE/sourcemod/addons/sourcemod/scripting/spcomp"

INPUT="$HERE/src/main.sp"
OUTPUT="$HERE/big_mod.smx"

{
    cd "$HERE"

    if [ ! -f "$COMPILER" ]; then
        echo "The compiler needs to be present at the following location: $COMPILER"
        echo 'You can download it from https://www.sourcemod.net/downloads.php'
        exit 1
    fi

    # mark compiler as executable
    chmod +x "$COMPILER"

    # compile ACS
    "$COMPILER" "$INPUT" -v:0 -o "$OUTPUT"

    cd -
}

echo "Compilation done - you can now copy the compiled \"$OUTPUT\" file into \"left4dead2/addons/sourcemod/plugins\""
