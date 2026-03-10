#!/usr/bin/env bash

set -euo pipefail

OUT_DIR="data/addresses/paris"
OUT_FILE="$OUT_DIR/adresses-paris.csv"

mkdir -p "$OUT_DIR"

echo "Downloading official Paris address file"
curl -fsSL "https://www.data.gouv.fr/api/1/datasets/r/d005b019-7712-4598-b49a-c0d4e72effcb" -o "$OUT_FILE"

echo "Paris addresses available in $OUT_FILE"
