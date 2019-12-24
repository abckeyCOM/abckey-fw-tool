#!/usr/bin/env bash

sha256d() {
  if [[ ! -n "$1" ]]; then echo "sha256d: No file path!" exit 1; fi
  echo -n $(sha256sum -b $1 | head -c 64) | xxd -r -ps | sha256sum | head -c 64
}

file_len() {
  if [[ ! -n "$1" ]]; then echo "file_len: No file path!" exit 1; fi
  wc -c < $1
}

file_info() {
  if [[ ! -n "$1" ]]; then echo "file_info: No file path!" && exit 1; fi
  echo ""
  echo "FilePath: $1"
  echo "FileSize: $(file_len $1) bytes"
  echo "FileHash: $(sha256d $1)"
  echo ""
}

typeof() {
  local val="$1"
  printf "%d" "$val" &>/dev/null && echo "integer" && return
  printf "%d" "$(echo $val|sed 's/^[+-]\?0\+//')" &>/dev/null && echo "integer" && return
  printf "%f" "$val" &>/dev/null && echo "number" && return
  [ ${#val} -eq 1 ] && echo "char" && return
  echo "string"
}

to_int() {
  if [[ $1 == "null" ]]; then
    echo 0
  else
    echo $1
  fi
}

to_str() {
  if [[ $1 == "null" ]]; then
    echo "NULL"
  else
    echo "\"$1\""
  fi
}

to_hex() {
  local num=0
  local size=2
  if [[ $(typeof "$2") != "integer" ]]; then echo "to_hex: integer type required!" && exit 1; fi
  if [[ $1 != "null" ]]; then num=$1; fi
  size=$2;
  printf %0${size}x $num
}

str_len() {
  if [[ $(typeof "$1") != "string" ]]; then echo "str_len: No string!" && exit 1; fi
  echo -e -n $1 | wc -c
}

str2upper()  {
  if [[ $(typeof "$1") != "string" ]]; then echo "str2upper: No string!" && exit 1; fi
  echo $1 | tr "[a-z]" "[A-Z]"
}

str2lower() {
  if [[ "$(typeof "$1")" != "string" ]]; then echo "str2lower: No string!" && exit 1; fi
  echo $1 | tr "[A-Z]" "[a-z]"
}

is_def() {
  if [[ $1 == "null" ]]; then
    echo "false"
  else
    echo "true"
  fi
}

abs_dir(){
  if [[ ! -n "$1" ]]; then echo "abs_dir: No file path!" exit 1; fi
  for file in $1/*
  do
    if test -f $file
    then
      echo $file
    else
      abs_dir $file
    fi
  done
}

# bj.sh is a Bash library for parsing JSON. https://github.com/memotype/bj.sh
# Copyright Isaac Freeman (memotype@gmail.com), licensed under the MIT license
bj() { declare -A bs=(['[']=] ['{']=});local sre='^"(([^\"]|\\.)*)"' \
gre='[[:space:]]+' wre='[[:space:]]*' ore='^(\[|\{)' bre='^(true|false|null)'
local nre='^(-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)?)' \
fre="$wre(,|\\}|\$)$wre" j=$1 v= k= n i q ol l b1 b2;shift;for q in "$@";do n=0
for ((i=1;i<${#j};i++));do if [[ ${j:$i} =~ ^$gre ]];then ((i+=\
${#BASH_REMATCH[0]}-1));continue;elif [[ ${j:0:1} = '[' ]];then k=$((n++))
elif [[ ${j:$i} =~ $sre$wre:$wre ]];then k=${BASH_REMATCH[1]};((i+=\
${#BASH_REMATCH[0]}));else return 1;fi;if [[ ${j:$i} =~ $sre || \
${j:$i} =~ $nre || ${j:$i} =~ $bre ]];then v=${BASH_REMATCH[1]}
((i+=${#BASH_REMATCH[0]}));elif [[ ${j:$i:1} =~ $ore ]];then ol=0
b1=${BASH_REMATCH[1]} b2=${bs[$b1]};for ((l="$i";l<"${#j}";l++));do case \
${j:$l:1} in $b1)((ol++));;$b2)((ol--));((ol<1))&&break;;esac;done
v=${j:$i:$((l-i+1))};((i+=${#v}));fi;if [[ ${j:$i} =~ ^$fre ]];then
((i+=${#BASH_REMATCH[0]}-1));fi;if [[ $k = "$q" ]];then break;fi;done;j=$v;done
echo "$v";}
