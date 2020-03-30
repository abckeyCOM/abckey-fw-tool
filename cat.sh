#!/usr/bin/env bash
source f.sh
# Merge files
# ./cat.sh dist/_boot.bin dist/_mark.bin dist/boot_mark.bin
# ./cat.sh dist/boot_mark.bin tmp/core.bin dist/boot_mark_core.bin

cat $1 $2 >$3
file_info $1
file_info $2
file_info $3
