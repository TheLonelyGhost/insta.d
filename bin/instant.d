#!/usr/bin/env bash
# vim: ft=sh

set -euo pipefail

: "${INSTANT_LIB:=$(dirname "$0")/../share/instant.d}"

# Load the share/instant.d/*.sh libraries
. "${INSTANT_LIB}/lib.sh"

usage() {
  cat <<EOH
Creates a \`*.d/' style directory shim to automatically include all configurations in the directory.

Usage: $(basename "$0") <config> [<directory>]

  <config>        Configuration file to replace

  <directory>     Configuration directory (e.g., \`config.d/') to compile the
                  <config> file.
                  Default: Same as <config> but with a \`.d' at the end.
                           \`~/.ssh/config' -> \`~/.ssh/config.d'

EOH
}

if [ $# -lt 1 ]; then
  usage
  print-version "$(basename "$0")"
  exit 0
elif [ $# -eq 1 ]; then
  config="$1"
  config_d="${config}.d"
else
  config="$1"
  config_d="$2"
fi

debug "target: $config"
debug "config.d: $config_d"

if [ ! -e "$config_d" ]; then
  fatal "ERROR: Directory does not exist (${config_d})"
fi

if [ -e "$config" ]; then
  backup-target "$config"
  rm -f "${config}"
fi

append-warning-header "$config" "$config_d"

if [ -e "${config_d}/pre" ]; then
  find "${config_d}/pre" -maxdepth 1 -not -type d | sort | while read -r file; do
    append-file "$config" "$file"
  done
fi

find "${config_d}" -maxdepth 1 -not -type d | sort | while read -r file; do
  append-file "$config" "$file"
done

if [ -e "${config_d}/post" ]; then
  find "${config_d}/post" -maxdepth 1 -not -type d | sort | while read -r file; do
    append-file "$config" "$file"
  done
fi
