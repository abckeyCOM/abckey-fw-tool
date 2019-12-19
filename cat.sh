#!/bin/bash
source f.sh
# demo: ./cat.sh dist/_boot.bin dist/_mark.bin dist/boot_mark.bin
# demo: ./cat.sh dist/boot_mark.bin tmp/core.bin dist/boot_mark_core.bin

f_main() {
  rm -f $3
  cat $1 $2 >$3
  f_fileInfo $1
  f_fileInfo $2
  f_fileInfo $3
}

f_main "$@"
