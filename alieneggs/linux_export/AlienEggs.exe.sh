#!/bin/sh
echo -ne '\033c\033]0;AlienEggs\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/AlienEggs.exe.x86_64" "$@"
