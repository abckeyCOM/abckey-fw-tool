#!/usr/bin/env bash
source f.sh
# v0.0.1
# ./boot.sh tmp/boot.dat v1.0.0

readonly SRC_DAT=$1
readonly OUT_VER=$2
readonly OUT_H="dist/bl_data.h"

readonly bl_data=$(xxd -ps -c 1 $SRC_DAT | awk '{printf"0x%s,",$0}')
readonly bl_hash=$(echo -n $(sha256d $SRC_DAT) | xxd -r -ps | xxd -ps -c 1 | awk '{printf"0x%s,",$0}')

cat << EOF > $OUT_H
// $OUT_VER
static const uint8_t bl_data[32768] = {$bl_data};
static const uint8_t bl_hash[32] = {$bl_hash};
EOF

file_info $SRC_DAT
file_info $OUT_H
