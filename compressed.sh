#!/usr/bin/env bash

cd "/Users/j5pu/Library/Mobile Documents/com~apple~CloudDocs/Compressed" || exit

while read -r file; do
  downloaded="$(dirname "${file}")/$(basename "${file}" .icloud | sed 's/^\.//g')"
  dest="/Volumes/USB-2TB/iCloud/Compressed/${downloaded/.\//}"

  if ! test -f "${dest}"; then
    brctl download "${file}"

    echo "${downloaded}: Start"
    while ! test -f "${downloaded}"; do
       sleep 1
    done
    echo "${downloaded}: Downloaded"

    if ! test -f "${dest}"; then
      cp -p "${downloaded}" "${dest}"
      if test -f "${dest}"; then
        echo "${downloaded}: Copied"
        brctl evict "${file}"
      fi
    fi
  fi
done < <(find . -type f -name "*.icloud")
