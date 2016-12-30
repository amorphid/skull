#!/bin/bash

set -eu

Installer.help () {
  Installer.help_message
  exit 0
}

Installer.help_message () {
  cat <<EOF
Usage: install.sh [options]

options:
  -h, --help
    display this help
EOF
}

Installer.initialize () {
  if [[ $@ ]]; then
    Installer.parse_options "${@}"
  else
    Installer.raise_help
  fi
}

Installer.parse_options () {
  case "${1}" in
    -h|--help)
      Installer.help
      ;;
    *)
      Installer.raise_parse_option "${1}"
      ;;
  esac

  shift
  if [[ $@ ]]; then
    Installer.parse_options "${@}"
  fi
}

Installer.raise () {
  echo "${1}" >&2
  exit 1
}

Installer.raise_help () {
  Installer.raise "$(Installer.help_message)"
}

Installer.raise_parse_option () {
  Installer.raise "[""${0}""] unknown option: ""\"""${1}""\""
}

Installer.initialize "${@:1}"
