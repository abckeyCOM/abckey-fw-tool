#!/usr/bin/env bash
source f.sh
# v0.0.1
# ./align.sh tmp/boot.bin

readonly OUT_FILE_MARK=$2
readonly OUT_FILE_PATH="dist"
readonly OUT_FILE_NAME="_boot.bin"

readonly SRC_FILE=$1
readonly OUT_FILE="$OUT_FILE_PATH/$OUT_FILE_NAME"

readonly SRC_FILE_SIZE=$(file_len $SRC_FILE)
readonly OUT_FILE_SIZE=32768

readonly fill_size=$[OUT_FILE_SIZE - $SRC_FILE_SIZE]
readonly zero_num=$[fill_size * 2]
readonly zero_str=$(to_hex 0 $zero_num)

cp -f -p $SRC_FILE $OUT_FILE && $(echo $zero_str | xxd -r -ps >> $OUT_FILE)

file_info $SRC_FILE
file_info $OUT_FILE
