#!/usr/bin/env bash
#
# Origin: https://github.com/torokmark/assert.sh

RED=$(echo -en "\e[31m")

log_failure() {
  printf "${RED}✖ %s${NORMAL}\n" "$@" >&2
}

assert_eq() {
  local expected="$1"
  local actual="$2"
  local msg="${3-}"

  if [ "$expected" == "$actual" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$expected == $actual :: $msg" || true
    return 1
  fi
}


filter=".[].env?.urls? | select (.!=null)"


read -r -d '' derivation << EOF
{
  "/nix/store/abcdef123456789": {
    "env": {
      "urls": "https://example.org"
    }
  }
}
EOF

assert_eq "$(echo $derivation | jq "$filter" -r)" "https://example.org" "Invalid url"


read -r -d '' ignore_path << EOF
{
  "/nix/store/0987654321": {
    "env": {
      "urls": "https://example.com"
    }
  }
}
EOF

assert_eq "$(echo $ignore_path | jq "$filter" -r)" "https://example.com" "Invalid path"


read -r -d '' without_urls << EOF
{
  "/nix/store/path": {
    "env": 42
  }
}
EOF

assert_eq "$(echo $without_urls | jq "$filter" -r)" "" "Expected empty"


read -r -d '' without_env << EOF
{
  "/nix/store/path": {
    "env": 42
  }
}
EOF

assert_eq "$(echo $without_env | jq "$filter" -r)" "" "Expected empty"


without_path="{}"

assert_eq "$(echo $without_path | jq "$filter" -r)" "" "Expected empty"

