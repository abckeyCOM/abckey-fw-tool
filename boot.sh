#!/usr/bin/env bash
source f.sh
# v0.0.1
# ./boot.sh tmp/boot.dat v1.0.0

readonly SRC_File=$1
readonly OUT_FILE_MARK=$2
readonly OUT_FILE_NAME="bl_data.h"
readonly OUT_FILE_PATH="dist"
readonly OUT_FILE="$OUT_FILE_PATH/$OUT_FILE_NAME"

readonly bl_data=$(xxd -ps -c 1 $SRC_File | awk '{printf"0x%s,",$0}')
readonly bl_hash=$(echo -n $(sha256d $SRC_File) | xxd -r -ps | xxd -ps -c 1 | awk '{printf"0x%s,",$0}')

cat << EOF > $OUT_FILE
// $OUT_FILE_MARK
static const uint8_t bl_data[32768] = {$bl_data};
static const uint8_t bl_hash[32] = {$bl_hash};
EOF

file_info $SRC_File
file_info $OUT_FILE
