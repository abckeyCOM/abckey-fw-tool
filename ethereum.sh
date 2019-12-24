#!/usr/bin/env bash
source f.sh
# v0.0.1
# ./ethereum.sh tmp/ethereum 201912201814

readonly SRC_DIR=$1
readonly SRC_JSON="networks.json"
readonly OUT_DIR="dist"
readonly OUT_VER=$2
readonly OUT_H_NAME="ethereum_networks.h"
readonly OUT_H="$OUT_DIR/$OUT_H_NAME"

json=$(cat $SRC_DIR/$SRC_JSON)
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

cat << EOF > $OUT_H
// $OUT_VER
#ifndef __ETHEREUM_NETWORKS_H__
#define __ETHEREUM_NETWORKS_H__
#define ASSIGN_ETHEREUM_SUFFIX(suffix, chain_id) \\
  switch (chain_id) { \\$COIN_LIST
    default: suffix = " UNKN"; break;  /* unknown chain */ \\
  }
#endif
EOF

file_info $OUT_H
