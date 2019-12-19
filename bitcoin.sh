#!/bin/bash
source f.sh
# demo: ./bitcoin.sh

readonly IN_PATH="bitcoin"

readonly OUT_FILE_C="coin_info.c"
readonly OUT_FILE_H="coin_info.h"
readonly OUT_FILE_PATH="dist"
readonly OUT_C="$OUT_FILE_PATH/$OUT_FILE_C"
readonly OUT_H="$OUT_FILE_PATH/$OUT_FILE_H"

f_c() {
echo "
#include \"coins.h\"

#include \"curves.h\"
#include \"secp256k1.h\"

const CoinInfo coins[COINS_COUNT] = {
  {
    .coin_name = ${c_str(c.coin_name)},
    .coin_shortcut = ${c_str(" " + c.coin_shortcut)},
    .maxfee_kb = ${c_int(c.maxfee_kb)},
    .signed_message_header = ${signed_message_header(c.signed_message_header)},
    .has_segwit = ${c_bool(c.segwit)},
    .has_fork_id = ${defined(c.fork_id)},
    .force_bip143 = ${c_bool(c.force_bip143)},
    .decred = ${c_bool(c.decred)},
    .decimals = ${c.decimals},
    .address_type = ${c.address_type},
    .address_type_p2sh = ${c.address_type_p2sh},
    .xpub_magic = ${hex(c.xpub_magic)},
    .xpub_magic_segwit_p2sh = ${hex(c.xpub_magic_segwit_p2sh)},
    .xpub_magic_segwit_native = ${hex(c.xpub_magic_segwit_native)},
    .fork_id = ${c_int(c.fork_id)},
    .bech32_prefix = ${c_str(c.bech32_prefix)},
    .cashaddr_prefix = ${c_str(c.cashaddr_prefix)},
    .coin_type = (${c_int(c.slip44)} | 0x80000000),
    .negative_fee = ${c_bool(c.negative_fee)},
    .curve_name = ${c.curve_name.upper()}_NAME,
    .curve = &${c.curve_name}_info,
  },
};
" >>$1
}

f_h() {
echo "
#ifndef __COIN_INFO_H__
#ifndef __COIN_INFO_H__

#include \"coins.h\"

#define COINS_COUNT (${test})

extern const CoinInfo coins[COINS_COUNT];

#endif
" >>$1
}

f_main() {
  rm -f $OUT_C $OUT_H
  f_c $OUT_C
  f_h $OUT_H
  f_fileInfo $OUT_C
  f_fileInfo $OUT_H
}

f_main "$@"
