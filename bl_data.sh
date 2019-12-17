#!/bin/bash
# demo: ./bl_data.sh ./test/boot.dat ./dist/bl_data.h

f_sha256d() {
  echo -n $(sha256sum -b $1 | head -c 64) | xxd -r -ps | sha256sum | head -c 64
}

f_fileInfo() {
  echo ""
  echo "FilePath: $1"
  echo "FileSize: $(wc -c <$1) bytes"
  echo "FileHash: $(f_sha256d $1)"
  echo ""
}

f_main() {
  rm -f $2
  f_fileInfo $1
  echo -e -n "static const uint8_t bl_data[32768] = {$(xxd -ps -c 1 $1 | awk '{printf"0x%s,",$0}')};\n" >>$2
  echo -e -n "static const uint8_t bl_hash[32] = {$(echo -n $(sha256sum -b $1 | head -c 64) | xxd -r -ps | sha256sum | head -c 64 | xxd -r -ps | xxd -ps -c 1 | awk '{printf"0x%s,",$0}')};" >>$2
  f_fileInfo $2
}

f_main "$@"
