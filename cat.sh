#!/usr/bin/env bash
source f.sh

# ./cat.sh dist/_boot.bin dist/_mark.bin dist/boot_mark.bin
# ./cat.sh dist/boot_mark.bin tmp/core.bin dist/boot_mark_core.bin

main() {
  rm -f $3
  cat $1 $2 >$3
  file_info $1
  file_info $2
  file_info $3
}

main "$@"
