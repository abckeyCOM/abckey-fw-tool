#!/usr/bin/env bash
source f.sh

# ./bitcoin.sh tmp/bitcoin 201912201814

readonly SRC_DIR=$1
readonly OUT_VER=$2
readonly OUT_DIR="dist"
readonly OUT_C_NAME="coin_info.c"
readonly OUT_H_NAME="coin_info.h"
readonly OUT_C="$OUT_DIR/$OUT_C_NAME"
readonly OUT_H="$OUT_DIR/$OUT_H_NAME"

index=0
for file_name in $(ls $SRC_DIR); do
  ((index++))
  echo "$index $SRC_DIR/$file_name"
  json="$(cat $SRC_DIR/$file_name)"
  signed_message_header=$(bj "$json" signed_message_header)
  force_bip143=$(bj "$json" force_bip143)
  decred=$(bj "$json" decred)
  decimals=$(bj "$json" decimals)
  address_type=$(bj "$json" address_type)
  address_type_p2sh=$(bj "$json" address_type_p2sh)
  xpub_magic=$(bj "$json" xpub_magic)
  xpub_magic_segwit_p2sh=$(bj "$json" xpub_magic_segwit_p2sh)
  xpub_magic_segwit_native=$(bj "$json" xpub_magic_segwit_native)
  fork_id=$(bj "$json" fork_id)
  bech32_prefix=$(bj "$json" bech32_prefix)
  cashaddr_prefix=$(bj "$json" cashaddr_prefix)
  slip44=$(bj "$json" slip44)
  negative_fee=$(bj "$json" negative_fee)
  curve_name=$(bj "$json" curve_name)
  
  COIN_LIST="$COIN_LIST
  {
    .coin_name = \"$(bj "$json" coin_name)\",
    .coin_shortcut = \" $(bj "$json" coin_shortcut)\",
    .maxfee_kb =  $(to_int $(bj "$json" maxfee_kb)),
    .signed_message_header = \"\x$(to_hex $(str_len "$signed_message_header"))\" \"$signed_message_header\",
    .has_segwit = $segwit,
    .has_fork_id = $(is_def "$fork_id"),
    .force_bip143 = $force_bip143,
    .decred = $decred,
    .decimals = $decimals,
    .address_type = $address_type,
    .address_type_p2sh = $address_type_p2sh,
    .xpub_magic = 0x$(to_hex $xpub_magic 8),
    .xpub_magic_segwit_p2sh = 0x$(to_hex $xpub_magic_segwit_p2sh 8),
    .xpub_magic_segwit_native =  0x$(to_hex $xpub_magic_segwit_native 8),
    .fork_id = $(to_int $fork_id),
    .bech32_prefix = $(to_str "$bech32_prefix"),
    .cashaddr_prefix = $(to_str "$cashaddr_prefix"),
    .coin_type = ($(to_int $slip44) | 0x80000000),
    .negative_fee = $negative_fee,
    .curve_name = $(str2upper "$curve_name")_NAME,
    .curve = &${curve_name}_info,
  },"
done

cat << EOF > $OUT_C
// $OUT_VER
#include "coins.h"
#include "curves.h"
#include "secp256k1.h"
const CoinInfo coins[COINS_COUNT] = {$COIN_LIST};
EOF

cat << EOF > $OUT_H
// $OUT_VER
#ifndef __COIN_INFO_H__
#ifndef __COIN_INFO_H__
#include "coins.h"
#define COINS_COUNT ($(ls -l $SRC_DIR | grep "^-" | wc -l))
extern const CoinInfo coins[COINS_COUNT];
#endif
EOF

file_info $OUT_C
file_info $OUT_H
