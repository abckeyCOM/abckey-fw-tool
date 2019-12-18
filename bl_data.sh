#!/bin/bash
source f.sh
# demo: ./bl_data.sh ./test/boot.dat ./dist/bl_data.h 32

f_main() {
  rm -f $2
  f_fileInfo $1
  readonly 
  readonly bl_data=$(xxd -ps -c 1 $1 | awk '{printf"0x%s,",$0}')
  readonly bl_sha256d=$(f_sha256d $1)
  readonly bl_hash=$(echo -n $bl_sha256d | xxd -r -ps | xxd -ps -c 1 | awk '{printf"0x%s,",$0}')
  echo "static const uint8_t bl_data[32768] = {$bl_data};" >>$2
  echo "static const uint8_t bl_hash[32] = {$bl_hash};" >>$2
  f_fileInfo $2
}

f_main "$@"
