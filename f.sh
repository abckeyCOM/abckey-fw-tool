#!/usr/bin/env bash

sha256d() {
  if [ ! -n "$1" ]; then echo "sha256d: No file path!" exit 1; fi
  echo -n $(sha256sum -b $1 | head -c 64) | xxd -r -ps | sha256sum | head -c 64
}

file_len() {
  if [ ! -n "$1" ]; then echo "file_len: No file path!" exit 1; fi
  wc -c < $1
}

file_info() {
  if [ ! -n "$1" ]; then echo "file_info: No file path!" && exit 1; fi
  echo ""
  echo "FilePath: $1"
  echo "FileSize: $(file_len $1) bytes"
  echo "FileHash: $(sha256d $1)"
  echo ""
}

to_hex() {
  local num=0
  local size=2
  if [ -n "$1" ]; then
    num=$1
  fi
  if [ -n "$2" ]; then
    size=$2
  fi
  printf %0${size}x $num
}

to_int() {
  if [ $1 == "null" ]; then
    echo 0
  else
    echo $1
  fi
}

to_str() {
  if [ $1 == "null" ]; then
    echo "NULL"
  else
    echo "\"$1\""
  fi
}

str_len() {
  if [ ! -n "$1" ]; then echo "str_len: No string!" && exit 1; fi
  echo -e -n $1 | wc -c
}

str2upper()  {
  if [ ! -n "$1" ]; then echo "str_len: No string!" && exit 1; fi
  echo $1 | tr "[a-z]" "[A-Z]"
  
}

str2lower() {
  if [ ! -n "$1" ]; then echo "str_len: No string!" && exit 1; fi
  echo $1 | tr "[A-Z]" "[a-z]"
}

is_def() {
  if [ $1 == "null" ]; then
    echo "false"
  else
    echo "true"
  fi
}
