#!/bin/bash
# demo: ./cat.sh ./dist/_boot.bin ./dist/_mark.bin ./dist/boot_mark.bin
# demo: ./cat.sh ./dist/boot_mark.bin ./test/core.bin ./dist/boot_mark_core.bin

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
  rm -f $3
  cat $1 $2 >$3

  f_fileInfo $1
  f_fileInfo $2
  f_fileInfo $3
}

f_main "$@"
