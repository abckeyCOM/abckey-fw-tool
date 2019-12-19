#!/bin/bash
source f.sh
# demo: ./boot.sh tmp/boot.dat v1.0.0

readonly OUT_FILE_INFO=$2
readonly OUT_FILE_NAME="bl_data.h"
readonly OUT_FILE_PATH="dist"
readonly OUT_FILE="$OUT_FILE_PATH/$OUT_FILE_NAME"

f_main() {
  rm -f $OUT_FILE
  f_fileInfo $1
  readonly bl_data=$(xxd -ps -c 1 $1 | awk '{printf"0x%s,",$0}')
  readonly bl_sha256d=$(f_sha256d $1)
  readonly bl_hash=$(echo -n $bl_sha256d | xxd -r -ps | xxd -ps -c 1 | awk '{printf"0x%s,",$0}')
  echo "
// $OUT_FILE_INFO
static const uint8_t bl_data[32768] = {$bl_data};
static const uint8_t bl_hash[32] = {$bl_hash};
" >>$OUT_FILE
  f_fileInfo $OUT_FILE
}

f_main "$@"
