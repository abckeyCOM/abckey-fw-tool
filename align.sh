#!/bin/bash
source f.sh
# demo: ./align.sh tmp/boot.bin dist/_boot.bin 32768

f_main() {
  rm -f $2
  cp -f -p $1 $2
  readonly total_size=$3
  readonly file_size=$(wc -c <$2)
  readonly fill_size=$(($total_size - $file_size))
  readonly zero_num=$(($fill_size * 2))
  readonly zero_str=$(printf %0${zero_list}d 0)
  echo $zero_str | xxd -r -ps >>$2
  f_fileInfo $1
  f_fileInfo $2
}

f_main "$@"
