#!/bin/bash

f_sha256d() {
  echo -n $(sha256sum -b $1 | head -c 64) | xxd -r -ps | sha256sum | head -c 64
}

f_fileInfo() {
  echo ""
  echo "FilePath: $1"
  echo "FileSize: $(wc -c <$1) bytes"
  echo "FileHash: $(f_sha256d $1)"
  echo ""
}
