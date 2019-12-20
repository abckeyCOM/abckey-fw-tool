#!/usr/bin/env bash
source f.sh

# ./align.sh tmp/boot.bin dist/_boot.bin 32768

main() {
  rm -f $2
  cp -f -p $1 $2
  readonly total_size=$3
  readonly file_size=$(file_len $2)
  readonly fill_size=$[total_size - $file_size]
  readonly zero_num=$[fill_size * 2]
  readonly zero_str=$(to_hex 0 $zero_num)
  echo $zero_str | xxd -r -ps >> $2
  file_info $1
  file_info $2
}

main "$@"
