#!/usr/bin/env bash

set -euo pipefail

ZIP_DIR="data/dvf/zip"
RAW_DIR="data/dvf/raw"

mkdir -p "$ZIP_DIR" "$RAW_DIR"

download_resource() {
  local name="$1"
  local url="$2"
  local zip_path="$ZIP_DIR/$name.zip"

  echo "Downloading $name"
  curl -fsSL "$url" -o "$zip_path"

  echo "Extracting $name"
  unzip -o "$zip_path" -d "$RAW_DIR" >/dev/null
}

download_resource "valeursfoncieres-2025-s1" "https://www.data.gouv.fr/api/1/datasets/r/4d741143-8331-4b59-95c2-3b24a7bdbe3c"
download_resource "valeursfoncieres-2024" "https://www.data.gouv.fr/api/1/datasets/r/af812b0e-a898-4226-8cc8-5a570b257326"
download_resource "valeursfoncieres-2023" "https://www.data.gouv.fr/api/1/datasets/r/cc8a50e4-c8d1-4ac2-8de2-c1e4b3c44c86"
download_resource "valeursfoncieres-2022" "https://www.data.gouv.fr/api/1/datasets/r/8c8abe23-2a82-4b95-8174-1c1e0734c921"
download_resource "valeursfoncieres-2021" "https://www.data.gouv.fr/api/1/datasets/r/e117fe7d-f7fb-4c52-8089-231e755d19d3"
download_resource "valeursfoncieres-2020-s2" "https://www.data.gouv.fr/api/1/datasets/r/8d771135-57c8-480f-a853-3d1d00ea0b69"

echo "DVF files available in $RAW_DIR"
