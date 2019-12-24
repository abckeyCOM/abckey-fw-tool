#!/usr/bin/env bash
source f.sh

# ./ethereum.sh tmp/ethereum 201912201814

readonly IN_PATH=$1
readonly OUT_FILE_MARK=$2
readonly OUT_FILE_H="ethereum_networks.h"
readonly OUT_FILE_PATH="dist"
readonly OUT_H="$OUT_FILE_PATH/$OUT_FILE_H"

for file_name in $(ls $IN_PATH); do
  json="$(cat $IN_PATH/$file_name)"
  for((i = 0, old_id;; i++)); do
    chain_id=$(bj "$json" $i chain_id)
    if [[ $chain_id == $old_id ]]; then break; fi
    old_id=$chain_id
    shortcut=$(bj "$json" $i shortcut)
    name=$(bj "$json" $i name)
    echo "$i $name"
    COIN_LIST="$COIN_LIST
    case $chain_id: suffix = \" $shortcut\" break;  /* ${name} */ \\"
  done
done

cat << EOF > $OUT_H
// $OUT_FILE_MARK
#ifndef __ETHEREUM_NETWORKS_H__
#define __ETHEREUM_NETWORKS_H__
#define ASSIGN_ETHEREUM_SUFFIX(suffix, chain_id) \\
  switch (chain_id) { \\$COIN_LIST
    default: suffix = " UNKN"; break;  /* unknown chain */ \\
  }
#endif
EOF

file_info $OUT_H
