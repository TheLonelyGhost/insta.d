#!/usr/bin/env bash

VERSION="0.1.0"

: "${COMMENT_CHAR:=#}"
: "${LOG_LEVEL:=7}"
: "${VERBOSE:=0}"
if [ -n "$VERBOSE" ] && [ "$VERBOSE" != 0 ]; then
  LOG_LEVEL=9
fi

__message() {
  local msg
  msg="$*"
  printf '>>>  %s\n' "$msg"
}

print-version() {
  local cmd
  cmd="${1:-instant.d}"

  printf '%s version %s\n' "$cmd" "$VERSION"
}

debug() {
  if [ "$LOG_LEVEL" -gt 8 ]; then
    __message "$@"
  fi
}

info() {
  if [ "$LOG_LEVEL" -gt 6 ]; then
    __message "$@"
  fi
}

warn() {
  if [ "$LOG_LEVEL" -gt 4 ]; then
    __message "$@"
  fi
}

fatal() {
  if [ "$LOG_LEVEL" -gt 2 ]; then
    __message "$@" 1>&2
  fi
  exit 1
}

backup-target() {
  local target bak
  target="$1"
  bak="${1}.old"
  debug "Backing up ${target} as ${bak}"

  # Use `cat` because it'll handle symlinks invisibly. `cp` will
  # make a copy of the symlink, not the content we wish to back up
  cat "${target}" > "${bak}"
}

pretty-path() {
  local pth
  pth="${1/${HOME}/~}"

  printf '%s\n' "$pth"
}

append-warning-header() {
  local target config_d
  target="$1"
  config_d="$2"

  cat <<EOF >> "${target}"
${COMMENT_CHAR}
${COMMENT_CHAR} ================== WARNING ==================
${COMMENT_CHAR} This file is managed by \`instant.d'. Do not manually alteranything here. Instead, add or alter
${COMMENT_CHAR} files in \`$(pretty-path "$config_d")/*'.
${COMMENT_CHAR} ================== /WARNING ==================
${COMMENT_CHAR}

EOF

}

append-file() {
  local file target
  target="$1"
  file="$2"

  printf '\n%s\n%s\n\n' \
    "${COMMENT_CHAR} ==========================================" \
    "${COMMENT_CHAR} From file: $(pretty-path "$file")" \
    >> "${target}"

  # Filter out the vim/vi modeline, if it exists
  grep -vFe "${COMMENT_CHAR} v"'im: ' "$file" | grep -ve "${COMMENT_CHAR} v"'i: ' >> "${target}"
}
